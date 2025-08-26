terraform {
  backend "azurerm" {
    resource_group_name   = "example-resources"
    storage_account_name  = "examplestorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}