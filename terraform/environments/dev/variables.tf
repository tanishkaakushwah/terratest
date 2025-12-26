variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = string
    tags       = map(string)
  }))
}

variable "networks" {}
variable "public_ips" {}
variable "key_vaults" {}
variable "secrets" {
  type = map(object({
    username = string
    password = string
  }))
}
variable "vm" {
  type = map(object(
    {
      nic_name               = string
      location               = string
      rg_name                = string
      vnet_name              = string
      subnet_name            = string
      pip_name               = string
      vm_name                = string
      size                   = string
      source_image_reference = map(string)
      kv_name     = string
      secret_username = string
      secret_password = string
      security_rules = list(object(
        {
          name                       = string
          priority                   = number
          direction                  = string
          access                     = string
          protocol                   = string
          source_port_range          = string
          destination_port_range     = string
          source_address_prefix      = string
          destination_address_prefix = string
        }
      ))
    }
  ))
}