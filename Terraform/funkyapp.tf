############################################
### Azure function for container syncing ###
############################################
resource "azurerm_app_service_plan" "demo_func_sp" {
  name                = "demo-func-sp"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  kind                = "functionapp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}



### Application insight so we can view the logs of the function ###
resource "azurerm_application_insights" "demo_func_ins" {
  name                = "demo-func-app-insight"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  application_type    = "web"
}

resource "random_string" "storage_name" {
 length = 4
 special = false
 upper = false
}

resource "azurerm_storage_account" "demo_func_sa" {
  name                     = "${random_string.storage_name.result}funkysa"
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


### Create a function app that runs apps from VSTS (DevOps) -> .zip files ###
resource "azurerm_function_app" "demo_funky_app" {
  name                       = "demo-funky-app"
  location                   = azurerm_resource_group.main_rg.location
  resource_group_name        = azurerm_resource_group.main_rg.name
  app_service_plan_id        = azurerm_app_service_plan.demo_func_sp.id
  storage_account_name       = azurerm_storage_account.demo_func_sa.name
  storage_account_access_key = azurerm_storage_account.demo_func_sa.primary_access_key
  version                    = "~3"
  identity {
     type = "SystemAssigned"
  }

  ### Leaving this as it's needed for DevOps CI/CD-deployments (for this demo the app is just deployed through VS/VS-code) ###
  site_config {
    scm_type = "VSTSRM"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.demo_func_ins.instrumentation_key
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = "true"
    "WEBSITE_RUN_FROM_PACKAGE"        = "1"
    "smtpUID"                         = "@Microsoft.KeyVault(VaultName=demo-funky-kv;SecretName=smtpUID)"
    "smtpPWD"                         = "@Microsoft.KeyVault(VaultName=demo-funky-kv;SecretName=smtpPWD)"
    "blobConnectionString"            = "@Microsoft.KeyVault(VaultName=demo-funky-kv;SecretName=blobConnectionString)"
  }

  depends_on = [azurerm_key_vault_secret.data_lake_prim_con_str_secret]
}

### Give KV-access to the func app ###
resource "azurerm_key_vault_access_policy" "func_kv_access" {
  key_vault_id = azurerm_key_vault.demo_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_function_app.demo_funky_app.identity[0].principal_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}