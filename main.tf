# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Creating resource group
resource "azurerm_resource_group" "DevOpsProject" {
  name     = "DevOpsProject"
  location = "West Europe"
}

resource "azurerm_container_registry" "devopsprojectc" {
  name                = "devopsprojectc"
  resource_group_name = azurerm_resource_group.DevOpsProject.name
  location            = azurerm_resource_group.DevOpsProject.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "devopsprojectc" {
  scope                = azurerm_container_registry.devopsprojectc.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_app_service.devopsprojectc.identity[0].principal_id
}

resource "azurerm_app_service_plan" "ASP-DevOpsProject-86e8" {
  name                = "ASP-DevOpsProject-86e8"
  location            = azurerm_resource_group.DevOpsProject.location
  resource_group_name = azurerm_resource_group.DevOpsProject.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "devopsprojectc" {
  name                = "devopsprojectc"
  location            = azurerm_resource_group.DevOpsProject.location
  resource_group_name = azurerm_resource_group.DevOpsProject.name
  app_service_plan_id = azurerm_app_service_plan.ASP-DevOpsProject-86e8.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.devopsprojectc.name}.azurecr.io/${var.img_repo_name}:${var.tag}"
    always_on        = true
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = "https://${azurerm_container_registry.devopsprojectc.name}.azurecr.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_USERNAME     = azurerm_container_registry.devopsprojectc.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = azurerm_container_registry.devopsprojectc.admin_password
  }
}
