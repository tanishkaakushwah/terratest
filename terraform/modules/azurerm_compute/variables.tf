variable "vms" {
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
    }
  ))
}
