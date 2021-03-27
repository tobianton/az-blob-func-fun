### Create a data lake. Normally I'd insert a network_rules block to lock down unknown IP-access to the datalake. ###
resource "azurerm_storage_account" "demo_datalake_sa" {
  name                        = "demodatalakecake"
  resource_group_name         = azurerm_resource_group.main_rg.name
  location                    = azurerm_resource_group.main_rg.location
  account_tier                = "Standard"
  account_replication_type    = "LRS"
  account_kind                = "StorageV2"
  is_hns_enabled              = "true"
}


### Have to create a role assignment due to Terraform client error. NB: can take up to 30 min for RA to complete ###
resource "azurerm_role_assignment" "sa_ra" {
  scope                = azurerm_storage_account.demo_datalake_sa.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

### Because of the delay above: sleep 120 to reduce the chance of 403-response ###
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  depends_on         = [azurerm_role_assignment.sa_ra]
}


### Create the file system for the data lake ###
resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name               = "demolake"
  storage_account_id = azurerm_storage_account.demo_datalake_sa.id
  depends_on = [azurerm_storage_account.demo_datalake_sa, azurerm_role_assignment.sa_ra]
}
