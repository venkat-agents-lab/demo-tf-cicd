resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
  numeric = true
}

resource "azurerm_storage_account" "this" {
  name                     = lower(substr("${var.storage_account_name_prefix}${random_string.suffix.result}", 0, 24))
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                     = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type  = "private"
}
