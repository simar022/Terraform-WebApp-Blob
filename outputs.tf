# Output the Web App URL
output "webapp_url" {
  description = "The default hostname of the web app"
  value       = "https://${azurerm_linux_web_app.example.default_hostname}"
}

# Output the Primary Connection String (Sensitive!)
output "storage_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.example.primary_connection_string
  sensitive   = true
}
