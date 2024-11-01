resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.app_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "agw-${var.app_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "agw-${var.app_name}-gateway-ip-configuration"
    subnet_id = var.gateway_subnet.id
  }

  frontend_port {
    name = "agw-${var.app_name}-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "agw-${var.app_name}-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  http_listener {
    name                           = "agw-${var.app_name}-listener"
    frontend_ip_configuration_name = "agw-${var.app_name}-frontend-ip-configuration"
    frontend_port_name             = "agw-${var.app_name}-frontend-port"
    protocol                       = "Http"
  }

  backend_address_pool {
    name = "agw-${var.app_name}-backend-pool"
    fqdns = [
      azurerm_container_app.container_app.ingress[0].fqdn
    ]
  }

  backend_http_settings {
    name                  = "agw-${var.app_name}-backend-settings"
    port                  = 8080
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    probe_name            = "agw-${var.app_name}-backend-probe"
  }

  probe {
    protocol                                  = "Http"
    name                                      = "agw-${var.app_name}-backend-probe"
    host                                      = azurerm_container_app.container_app.ingress[0].fqdn
    port                                      = 8080
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 120
    unhealthy_threshold                       = 0
    pick_host_name_from_backend_http_settings = false
    minimum_servers                           = 0
    match {
      status_code = ["200-399"]
    }
  }

  request_routing_rule {
    name                       = "agw-${var.app_name}-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "agw-${var.app_name}-listener"
    backend_address_pool_name  = "agw-${var.app_name}-backend-pool"
    backend_http_settings_name = "agw-${var.app_name}-backend-settings"
    priority                   = 1
  }
}
