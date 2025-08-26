resource "random_string" "storage_suffix" {
  length  = 8
  upper   = false
  special = false
}

#Resource Group
resource "azurerm_resource_group" "example" {
  name     = "terraform-rg"
  location = "westeurope"
}


#Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "terra01${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


#Vnet
resource "azurerm_virtual_network" "example" {
  name                = "terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}