resource "azurerm_container_app_environment" "container_app_environment" {
  name                           = "cae-${var.app_name}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  infrastructure_subnet_id       = var.app_subnet.id
  internal_load_balancer_enabled = true
}

resource "azurerm_container_app" "container_app" {
  name                         = "ca-${var.app_name}"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  revision_mode                = "Single"

  depends_on = [
    null_resource.acr_image_deployment,
    azurerm_role_assignment.acr_pull
  ]

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.identity.id
    ]
  }

  ingress {
    target_port = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  # secret {
  #   name                = "secret-postgresql-admin-username"
  #   identity            = azurerm_user_assigned_identity.identity.id
  #   key_vault_secret_id = azurerm_key_vault_secret.postgresql_admin_username.id
  # }

  # secret {
  #   name                = "secret-postgresql-admin-password"
  #   identity            = azurerm_user_assigned_identity.identity.id
  #   key_vault_secret_id = azurerm_key_vault_secret.postgresql_admin_password.id
  # }

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.identity.id
  }

  template {
    container {
      name   = "ca-${var.app_name}-container"
      image  = "${azurerm_container_registry.acr.login_server}/${var.container_app_image}"
      cpu    = "0.5"
      memory = "1Gi"

      #   env {
      #     name  = "POSTGRES_HOST"
      #     value = azurerm_postgresql_flexible_server.postgresql_server.fqdn
      #   }

      #   env {
      #     name  = "POSTGRES_DATABASE"
      #     value = azurerm_postgresql_flexible_server_database.postgresql_database.name
      #   }

      #   env {
      #     name        = "POSTGRES_USER"
      #     secret_name = "secret-postgresql-admin-username"
      #   }

      #   env {
      #     name        = "POSTGRES_PASSWORD"
      #     secret_name = "secret-postgresql-admin-password"
      #   }
    }
  }
}
