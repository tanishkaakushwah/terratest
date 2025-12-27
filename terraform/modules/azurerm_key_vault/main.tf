data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                    = var.key_vaults
  name                        = each.value.kv_name
  location                    = each.value.location
  resource_group_name         = each.value.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name = "standard"
  rbac_authorization_enabled = true  
  
    network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  for_each = var.key_vaults
  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.object_id
}

resource "time_sleep" "wait_for_kv_rbac" {
  depends_on = [
    azurerm_role_assignment.kv_secrets_user
  ]
  create_duration = "180s"
}

output "object_id"{
  value=data.azurerm_client_config.current.object_id
}


resource "azurerm_key_vault_secret" "username" {
  depends_on = [time_sleep.wait_for_kv_rbac]
  for_each= var.secrets
  name         = "${each.key}-username"
  value        = each.value.username
  key_vault_id = azurerm_key_vault.kv["kv1"].id
}

resource "azurerm_key_vault_secret" "passwords" {
  depends_on = [time_sleep.wait_for_kv_rbac]
  for_each= var.secrets
  name         = "${each.key}-passwd"
  value        = each.value.password
  key_vault_id = azurerm_key_vault.kv["kv1"].id
}

