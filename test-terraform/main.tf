resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg_terraform" {
  name     = "rg-terraform"
  location = var.resource_group_location
}

resource "azurerm_app_service_plan" "app_services" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}