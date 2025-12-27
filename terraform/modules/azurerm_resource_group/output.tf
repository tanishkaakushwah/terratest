output "rg_ids" {
  value = { for k, v in azurerm_resource_group.rgs : k => v.id }
}

output "rg_names" {
  value = { for k, v in azurerm_resource_group.rgs : k => v.name }
}
