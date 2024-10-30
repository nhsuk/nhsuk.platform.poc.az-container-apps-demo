output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "app_subnet" {
  value = azurerm_subnet.app_subnet
}

output "db_subnet" {
  value = azurerm_subnet.db_subnet
}

output "services_subnet" {
  value = azurerm_subnet.services_subnet
}

output "acr_dns_zone" {
  value = azurerm_private_dns_zone.acr_dns_zone
}

output "key_vault_dns_zone" {
  value = azurerm_private_dns_zone.key_vault_dns_zone
}

output "postgresql_dns_zone" {
  value = azurerm_private_dns_zone.postgresql_dns_zone
}
