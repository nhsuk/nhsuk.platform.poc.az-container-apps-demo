resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.app_name}"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-${var.app_name}-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_subnet_address_prefixes
  service_endpoints    = ["Microsoft.KeyVault"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "snet-${var.app_name}-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.db_subnet_address_prefixes
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "snet-${var.app_name}-db-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "services_subnet" {
  name                 = "snet-${var.app_name}-services"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.services_subnet_address_prefixes
}
