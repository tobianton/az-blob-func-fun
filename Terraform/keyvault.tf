data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo_kv" {
  name                        = "demo-funkeh-kv"
  location                    = azurerm_resource_group.main_rg.location
  resource_group_name         = azurerm_resource_group.main_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

### For some reason I was not able to get the func app to access the KV over a VNET with a Dynamic Windows plan (I remember that this combo has some vnet-quirks).
### Since Az-Func-apps are not considered "trusted microsoft services I would, to remedy the "breach", (in a real environment) only allow only whitelisted ips access
### Another way that I've made my way around this is for all egress through a NAT-gateway with a static IP through a subnet integration -> this ensures a static func egress IP
#   network_acls {
#     default_action = "Deny"
#     bypass         = "AzureServices"
#     ip_rules       = concat(["XXX.XXX.XXX.XXX","XXX.XXX.XXX.XXX"], split(",", azurerm_function_app.demo_funky_app.possible_outbound_ip_addresses))
#   }
}

### Give myself key vault access ###
resource "azurerm_key_vault_access_policy" "current_user_kv_access" {
  key_vault_id = azurerm_key_vault.demo_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
      "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore"
  ]

  secret_permissions = [
      "backup", "delete", "get", "list", "purge", "recover", "set", "restore"
  ]

  storage_permissions = [
      "get", "list", "update", "delete", "recover", "backup", "restore"
  ]
}


### Because of the delay above: sleep 120 to reduce the chance of 403-response ###
resource "null_resource" "kv_delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  depends_on         = [azurerm_key_vault_access_policy.current_user_kv_access]
}



### Generate some secrets and insert them to the vault. I would normally insert them manually, but for the purpose of this demo -> makes it more plug and play ###
resource "azurerm_key_vault_secret" "data_lake_prim_con_str_secret" {
  name         = "blobConnectionString"
  value        = azurerm_storage_account.demo_datalake_sa.primary_blob_connection_string
  key_vault_id = azurerm_key_vault.demo_kv.id
  depends_on   = [null_resource.kv_delay]
}


resource "azurerm_key_vault_secret" "storage_acc_primary_key_secret" {
  name         = "storageAccKey"
  value        = azurerm_storage_account.demo_datalake_sa.primary_access_key
  key_vault_id = azurerm_key_vault.demo_kv.id
  depends_on   = [null_resource.kv_delay]
}

resource "azurerm_key_vault_secret" "smtp_uid_secret" {
  name         = "smtpUID"
  value        = var.__smtp_uid__
  key_vault_id = azurerm_key_vault.demo_kv.id
  depends_on   = [null_resource.kv_delay]
}

resource "azurerm_key_vault_secret" "smtp_pwd" {
  name         = "smtpPWD"
  value        = var.__smtp_pwd__
  key_vault_id = azurerm_key_vault.demo_kv.id
  depends_on   = [null_resource.kv_delay]
}