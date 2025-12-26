module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "network" {
  depends_on = [ module.resource_group ]
  source   = "../../modules/azurerm_networking"
  networks = var.networks
}

module "public_ip" {
  depends_on = [ module.resource_group ]
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips
}

module "key_vault" {
  depends_on = [ module.resource_group ]
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.key_vaults
  secrets = var.secrets
}

module "sql_server" {
  depends_on      = [module.resource_group,module.key_vault]
  source          = "../../modules/azurerm_sql_server"
  sql_server_name = "sql-dev-todo-4983"
  rg_name         = "rg-pilu-dev-todoapp-01"
  location        = "centralindia"
  kv_name = "kv-dev-tani"
  secret_username  = "sql-server-username"
  secret_password  = "sql-server-passwd"
  tags            = {}
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-dev-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = {}
}

module "compute" {
  depends_on   = [module.network, module.public_ip, module.key_vault]
  source       = "../../modules/azurerm_compute"
  vms          = var.vm
}

module "nsg" {
  depends_on = [ module.compute]
  source     = "../../modules/azurerm_nsg"
  vms       = var.vm
}
