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


  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "username" {
  for_each= var.secrets
  name         = "${each.key}-username"
  value        = each.value.username
  key_vault_id = azurerm_key_vault.kv["kv1"].id
}

resource "azurerm_key_vault_secret" "passwords" {
  for_each= var.secrets
  name         = "${each.key}-passwd"
  value        = each.value.password
  key_vault_id = azurerm_key_vault.kv["kv1"].id
}