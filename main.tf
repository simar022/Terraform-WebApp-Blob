# 1. Define the Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Using the latest 2026 standards
    }
  }
}

provider "azurerm" {
  features {} # Required for the Azure provider to function
}

# Update your Resource Group to use variables
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
# 1. Create a Container for logs
resource "azurerm_storage_container" "logs" {
  name                  = "webapp-logs"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

# 2. Upload a Custom File (e.g., a config file or initial log)
# Ensure you have a file named 'custom-config.txt' in your folder!
resource "azurerm_storage_blob" "example_file" {
  name                   = "config/custom-config.txt"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.logs.name
  type                   = "Block"
  source                 = "custom-config.txt" # Path to your local file
}

# Update your Storage Account to use variables
resource "azurerm_storage_account" "example" {
  name                     = "tfstorage${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.storage_account_tier
  account_replication_type = "LRS"
}
# 4. Create an App Service Plan (The "Server" horsepower)
resource "azurerm_service_plan" "example" {
  name                = "beginner-service-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "F1" # Free tier
}

# 5. Create the Web App itself
resource "azurerm_linux_web_app" "example" {
  name                = "webapp-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  
  site_config {
    always_on = false
    }
    
    logs {
    http_logs {
      azure_blob_storage {
        # Using the SAS URL we generated in the previous step
        sas_url           = "https://${azurerm_storage_account.example.name}.blob.core.windows.net/${azurerm_storage_container.logs.name}${data.azurerm_storage_account_sas.example.sas}"
        retention_in_days = 7
      }
    }
  }
}

# Helper to generate the SAS Token for the Web App
data "azurerm_storage_account_sas" "example" {
  connection_string = azurerm_storage_account.example.primary_connection_string
  https_only        = true

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2026-01-01T00:00:00Z"
  expiry = "2027-01-01T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}
# Helper to ensure unique names
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}
# Use terraform_data (the modern 2026 way) to run a local command
resource "terraform_data" "open_browser" {
  # This ensures the browser only opens AFTER the web app is fully ready
  depends_on = [azurerm_linux_web_app.example]

  provisioner "local-exec" {
    # Use 'start' for Windows, 'open' for Mac, and 'xdg-open' for Linux
    command = <<EOT
      python3 -c "import webbrowser; webbrowser.open('https://${azurerm_linux_web_app.example.default_hostname}')"
    EOT
  }
}
