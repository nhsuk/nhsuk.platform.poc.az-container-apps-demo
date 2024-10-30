variable "app_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "deployment_client_id" {
  type = string
}

variable "deployment_ip" {
  type = string
}

variable "vnet" {
  type = any
}

variable "app_subnet" {
  type = any
}

variable "db_subnet" {
  type = any
}

variable "services_subnet" {
  type = any
}

variable "acr_dns_zone" {
  type = any
}

variable "key_vault_dns_zone" {
  type = any
}

variable "postgresql_dns_zone" {
  type = any
}

variable "container_app_image" {
  type = string
}

variable "postgresql_admin_username" {
  type = string
}

variable "postgresql_admin_password" {
  type = string
}
