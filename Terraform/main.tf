### Usually I put the RG and VNET in the main file ###

resource "azurerm_resource_group" "main_rg" {
  name     = "demo-rg"
  location = "westeurope"
}
