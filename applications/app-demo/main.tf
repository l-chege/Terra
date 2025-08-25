resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "westeurope"
}


resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name      = "my-resource-group"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  resource_group_name = "my-resource-group"
}
