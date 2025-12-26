data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault_secret" "sql_admin_username" {
  name         = var.secret_username
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = var.secret_password
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.sql_admin_username.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_password.value
  minimum_tls_version          = "1.2"
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_storage_account" "audit" {
  name                     = "stsqlauditrgdev01"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_mssql_server_extended_auditing_policy" "server_audit" {
  server_id                  = azurerm_mssql_server.sql_server.id
  storage_endpoint           = azurerm_storage_account.audit.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.audit.primary_access_key
  retention_in_days          = 90        # adjust to your policy
  log_monitoring_enabled     = true      # enables “DevOps operations” auditing
}
