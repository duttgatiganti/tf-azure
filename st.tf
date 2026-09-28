terraform {
  

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
   backend "azurerm" {
    resource_group_name  = "demo-rg"
    storage_account_name = "demostorageaccount2891"  # <- use module output
    container_name       = "c2892"
    key                  = "stobackend.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = "East US"
}

# Storage Account
resource "azurerm_storage_account" "storage2" {

  name                     = "demostorageaccount2891"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_account" "storage3" {

  name                     = "demostorageaccount2891r"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  tags = {
    environment = "dev",
    environment2 = "dev2"
  }
    lifecycle {
      ignore_changes = [
    tags,
  ]
  } 
}

resource "azurerm_storage_container" "example" {
  name                  = "c289"
  storage_account_id    = azurerm_storage_account.storage3.id
  container_access_type = "blob"
}

resource "azurerm_storage_container" "example2" {
  name                  = "c2892"
  storage_account_id    = azurerm_storage_account.storage2.id
  container_access_type = "blob"
}


