# resource "azurerm_key_vault" "key_vault" {
#   name                = "kv-${var.app_name}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tenant_id           = var.tenant_id
#   sku_name            = "standard"
#   network_acls {
#     bypass         = "None"
#     default_action = "Deny"
#     ip_rules = [
#       var.deployment_ip // NOTE: this ip rule should ideally be removed after deployment
#     ]
#     virtual_network_subnet_ids = [
#       var.app_subnet.id,
#       var.db_subnet.id
#     ]
#   }
# }

# # resource "azurerm_key_vault_access_policy" "deployment_user_access" {
# #   key_vault_id       = azurerm_key_vault.key_vault.id
# #   tenant_id          = var.tenant_id
# #   object_id          = var.deployment_client_id
# #   secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
# # }

# # resource "azurerm_key_vault_access_policy" "managed_identity_access" {
# #   key_vault_id       = azurerm_key_vault.key_vault.id
# #   tenant_id          = var.tenant_id
# #   object_id          = azurerm_user_assigned_identity.identity.principal_id
# #   secret_permissions = ["Get", "List"]
# # }

# # resource "azurerm_key_vault_secret" "postgresql_admin_username" {
# #   name         = "postgresql-admin-username"
# #   value        = var.postgresql_admin_username
# #   key_vault_id = azurerm_key_vault.key_vault.id

# #   depends_on = [
# #     azurerm_key_vault_access_policy.deployment_user_access
# #   ]
# # }

# # resource "azurerm_key_vault_secret" "postgresql_admin_password" {
# #   name         = "postgresql-admin-password"
# #   value        = var.postgresql_admin_password
# #   key_vault_id = azurerm_key_vault.key_vault.id

# #   depends_on = [
# #     azurerm_key_vault_access_policy.deployment_user_access
# #   ]
# # }

# resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
#   name                = "pe-${var.app_name}-kv"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.services_subnet.id

#   private_dns_zone_group {
#     name                 = "private-dns-zone-group"
#     private_dns_zone_ids = [var.key_vault_dns_zone.id]
#   }

#   private_service_connection {
#     name                           = "psc-${var.app_name}-kv"
#     private_connection_resource_id = azurerm_key_vault.key_vault.id
#     is_manual_connection           = false
#     subresource_names              = ["vault"]
#   }
# }
