# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "f5d49c48-fe13-4374-a13d-4f34cd839929"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-api-container"
  location = "East US"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-analytics-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "example" {
  name                = "container-apps-env"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_container_app" "api1" {
  name                      = "api1-app"
  resource_group_name        = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.example.id
  revision_mode                = "Single"

  template {
    container {
      name   = "api1-container"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 5000
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "api2" {
  name                      = "api2-app"
  resource_group_name        = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.example.id
  revision_mode                = "Single"

  template {
    container {
      name   = "api2-container"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 5001
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

