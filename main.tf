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
  location = "South India"
}

resource "azurerm_container_registry" "devopsprojectc" {
  name                = "devopsprojectc"
  resource_group_name = azurerm_resource_group.DevOpsProject.name
  location            = "Central US"
  sku                 = "Basic"
  admin_enabled       = true
}

# resource "azurerm_role_assignment" "devopsprojectc" {
#   scope                = azurerm_container_registry.devopsprojectc.id
#   role_definition_name = "acrpull"
#   principal_id         = azurerm_app_service.devopsprojectc.identity[0].principal_id
# }

resource "azurerm_app_service_plan" "ASP-DevOpsProject-86e8" {
  name                = "ASP-DevOpsProject-86e8"
  location            = "Japan East"
  kind                = "linux"
  reserved            = true
  resource_group_name = azurerm_resource_group.DevOpsProject.name

  sku {
    tier = "Premium"
    size = "P1V3"
  }
  timeouts {}
}

resource "azurerm_app_service" "devopsprojectc" {
  name                = "devopsprojectc"
  location            = "Japan East"
  resource_group_name = azurerm_resource_group.DevOpsProject.name
  app_service_plan_id = azurerm_app_service_plan.ASP-DevOpsProject-86e8.id

  site_config {
    always_on = false
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html",
    ]
    linux_fx_version          = "DOCKER|devopsprojectc.azurecr.io/devopsprojectc/testingdocker:latest"
    use_32_bit_worker_process = true
  }
  https_only = true

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = "https://${azurerm_container_registry.devopsprojectc.name}.azurecr.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_USERNAME     = azurerm_container_registry.devopsprojectc.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = "FG8Cwq4tfSA+idEf16QWyX6mcaRTILWLEWe7fIpTxN+ACRCWSLHP"
  }
  timeouts {}
}
