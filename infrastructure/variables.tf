variable "app_name" {
  type    = string
  default = "mycontainerapp"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["172.16.0.0/16"]
}

variable "gateway_subnet_address_prefixes" {
  type    = list(string)
  default = ["172.16.0.0/18"]
}

variable "app_subnet_address_prefixes" {
  type    = list(string)
  default = ["172.16.64.0/18"]
}

variable "db_subnet_address_prefixes" {
  type    = list(string)
  default = ["172.16.128.0/18"]
}

variable "services_subnet_address_prefixes" {
  type    = list(string)
  default = ["172.16.192.0/18"]
}

variable "container_app_image" {
  type    = string
  default = "helloworldapp:latest"
}

variable "postgresql_admin_username" {
  type    = string
  default = "supersecureusername"
}

variable "postgresql_admin_password" {
  type    = string
  default = "supersecurepassword"
}
