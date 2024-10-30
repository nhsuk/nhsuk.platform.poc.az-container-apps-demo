# resource "azurerm_postgresql_flexible_server" "postgresql_server" {
#   name                          = "psql-${var.app_name}"
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   version                       = "14"
#   delegated_subnet_id           = var.db_subnet.id
#   private_dns_zone_id           = var.postgresql_dns_zone.id
#   public_network_access_enabled = false
#   zone                          = "1"
#   sku_name                      = "B_Standard_B1ms"
#   storage_mb                    = 32768
#   administrator_login           = var.postgresql_admin_username
#   administrator_password        = var.postgresql_admin_password
# }

# resource "azurerm_postgresql_flexible_server_database" "postgresql_database" {
#   name      = var.app_name
#   server_id = azurerm_postgresql_flexible_server.postgresql_server.id
# }
