output "kv_object_id" {
  value = module.key_vault.object_id
}


output "resource_group_names" {
  value = module.resource_group.rg_names
}

output "frontend_public_ip" {
  value = module.public_ip.frontend_ip_address
}