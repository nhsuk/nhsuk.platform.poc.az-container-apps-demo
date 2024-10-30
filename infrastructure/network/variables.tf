variable "app_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "app_subnet_address_prefixes" {
  type = list(string)
}

variable "db_subnet_address_prefixes" {
  type = list(string)
}

variable "services_subnet_address_prefixes" {
  type = list(string)
}
