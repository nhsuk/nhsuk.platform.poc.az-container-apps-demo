resource "azurerm_container_registry" "acr" {
  name                       = "acr${replace(replace(var.app_name, "-", ""), "_", "")}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = "Premium" // NOTE: premium is required for private endpoint
  admin_enabled              = true      // NOTE: admin should ideally be disabled, however it's used for image deployment below
  network_rule_bypass_option = "AzureServices"
  network_rule_set {
    default_action = "Deny"
    ip_rule = [{
      action   = "Allow"
      ip_range = "${var.deployment_ip}/32" // NOTE: this ip rule should ideally be removed after deployment
    }]
  }
}

resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "pe-${var.app_name}-acr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.services_subnet.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.acr_dns_zone.id]
  }

  private_service_connection {
    name                           = "psc-${var.app_name}-acr"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

resource "null_resource" "container_deployment" {
  triggers = {
    // Below will build and push the docker image every time the terraform is applied
    always_run = "${timestamp()}"

    // Below will build and push the docker image when something has changed 
    //on_docker_image_changed = sha256(join("", [for f in fileset(".", "../tools/test-app/**") : file(f)]))
  }

  provisioner "local-exec" {
    working_dir = "../tools/test-app"
    interpreter = ["powershell", "-Command"]
    command     = <<EOT
      docker login ${azurerm_container_registry.acr.login_server} -u ${azurerm_container_registry.acr.admin_username} -p ${azurerm_container_registry.acr.admin_password};
      docker build --no-cache -t ${azurerm_container_registry.acr.login_server}/${var.container_app_image} .;
      docker push ${azurerm_container_registry.acr.login_server}/${var.container_app_image};
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
}
