terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

data "external" "deployment_ip" {
  program = ["powershell", "-Command", "Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' | ConvertTo-Json"]
}

resource "azurerm_resource_group" "resource_group" {
  location = var.location
  name     = "rg-${var.app_name}"
}

module "network" {
  source                           = "./network"
  app_name                         = var.app_name
  location                         = azurerm_resource_group.resource_group.location
  resource_group_name              = azurerm_resource_group.resource_group.name
  vnet_address_space               = var.vnet_address_space
  gateway_subnet_address_prefixes  = var.gateway_subnet_address_prefixes
  app_subnet_address_prefixes      = var.app_subnet_address_prefixes
  db_subnet_address_prefixes       = var.db_subnet_address_prefixes
  services_subnet_address_prefixes = var.services_subnet_address_prefixes
}

module "services" {
  source                    = "./services"
  app_name                  = var.app_name
  location                  = azurerm_resource_group.resource_group.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  deployment_client_id      = data.azurerm_client_config.current.object_id
  deployment_ip             = data.external.deployment_ip.result.ip
  vnet                      = module.network.vnet
  gateway_subnet            = module.network.gateway_subnet
  app_subnet                = module.network.app_subnet
  db_subnet                 = module.network.db_subnet
  services_subnet           = module.network.services_subnet
  acr_dns_zone              = module.network.acr_dns_zone
  key_vault_dns_zone        = module.network.key_vault_dns_zone
  postgresql_dns_zone       = module.network.postgresql_dns_zone
  container_apps_dns_zone   = module.network.container_apps_dns_zone
  container_app_image       = var.container_app_image
  postgresql_admin_username = var.postgresql_admin_username
  postgresql_admin_password = var.postgresql_admin_password

  depends_on = [module.network]
}
