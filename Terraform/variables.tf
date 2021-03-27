### No default backend for this project -> just going to have to handle the state files ###
# terraform {
#   backend "azurerm" {
#     resource_group_name   = "tfstate-rg"
#     storage_account_name  = "randomsaname"
#     container_name        = "tfstates"
#     key                   = "marek.project.tfstate"
#   }
# }


### Set the Azure Provider ###
provider "azurerm" {
  version = "=2.48.0"
  features {}
}


### Variables utilized by the tf-scripts. For more info about the __XXX__-naming se the Terraform Readme ###
variable "__smtp_pwd__" {
  description = "From .env-file"
  default = ""
}

variable "__smtp_uid__" {
  description = "From .env-file"
  default = ""
}
