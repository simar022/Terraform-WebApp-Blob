# Terraform-WebApp-Blob

## Overview

This Terraform project automates the deployment of an Azure Web App (Linux-based) integrated with Azure Blob Storage for logging purposes. The infrastructure includes:

- An Azure Resource Group
- An Azure Storage Account with a container for logs
- An Azure App Service Plan (using the free F1 tier)
- An Azure Linux Web App configured to log HTTP requests to the Blob Storage container
- Upload of a custom configuration file (`custom-config.txt`) to the Blob Storage

The project demonstrates Infrastructure as Code (IaC) best practices for deploying a simple web application with centralized logging in Azure.

## Architecture

The deployed architecture consists of:

1. **Resource Group**: A logical container for all Azure resources.
2. **Storage Account**: Provides Blob Storage for storing logs and custom files.
3. **Storage Container**: A private container named `webapp-logs` for storing web app logs.
4. **Storage Blob**: Uploads the `custom-config.txt` file to the storage container.
5. **App Service Plan**: Defines the compute resources (free tier F1) for the web app.
6. **Linux Web App**: The actual web application, configured to send HTTP logs to Blob Storage using a Shared Access Signature (SAS) token.

## Prerequisites

Before deploying this project, ensure you have the following:

- **Azure Account**: An active Azure subscription with sufficient permissions to create resources.
- **Azure CLI**: Installed and authenticated. You can install it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- **Terraform**: Version 1.0 or later. Download from [here](https://www.terraform.io/downloads.html).
- **Git**: For cloning the repository (optional, if not already cloned).

### Authentication

Authenticate with Azure using the Azure CLI:

```bash
az login
```

Set your subscription (if you have multiple):

```bash
az account set --subscription "Your-Subscription-ID"
```

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/simar022/Terraform-WebApp-Blob.git
   cd Terraform-WebApp-Blob
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```
   This downloads the necessary providers (e.g., AzureRM).

3. **Review Variables**:
   The project uses variables defined in `variables.tf`. You can override defaults by creating a `terraform.tfvars` file or passing them via command line.

   Default variables:
   - `resource_group_name`: "terraform-rg"
   - `location`: "Central India"
   - `storage_account_tier`: "Standard"

## Configuration

### Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `resource_group_name` | string | Name of the Azure Resource Group | "terraform-rg" |
| `location` | string | Azure region for resource deployment | "Central India" |
| `storage_account_tier` | string | Tier for the Storage Account (Standard/Premium) | "Standard" |

### Custom Configuration File

The project uploads `custom-config.txt` to Blob Storage. This file contains sample configuration data. You can modify it as needed for your application.

## Deployment

1. **Plan the Deployment**:
   ```bash
   terraform plan
   ```
   Review the plan to ensure it matches your expectations.

2. **Apply the Configuration**:
   ```bash
   terraform apply
   ```
   Confirm with `yes` when prompted. This will create all resources in Azure.

3. **Verify Deployment**:
   - Check the Azure Portal for the created resources.
   - Access the web app URL (outputted after deployment).

## Outputs

After successful deployment, Terraform provides the following outputs:

- **webapp_url**: The default hostname URL of the deployed web app (e.g., `https://webapp-12345.azurewebsites.net`).
- **storage_connection_string**: The primary connection string for the Storage Account (marked as sensitive).

You can view outputs with:

```bash
terraform output
```

## Usage

Once deployed:

1. **Access the Web App**: Use the `webapp_url` output to access your web application in a browser.
2. **View Logs**: Logs are automatically stored in the `webapp-logs` container in Blob Storage. You can access them via the Azure Portal or Azure Storage Explorer.
3. **Custom Config**: The uploaded `custom-config.txt` can be downloaded or referenced by your application if needed.

## Cleanup

To destroy all resources and avoid ongoing costs:

```bash
terraform destroy
```

Confirm with `yes` when prompted. This will remove all Azure resources created by this project.

## File Structure

```
Terraform-WebApp-Blob/
├── .gitignore              # Git ignore rules for Terraform files
├── custom-config.txt       # Sample configuration file uploaded to Blob Storage
├── main.tf                 # Main Terraform configuration
├── outputs.tf              # Terraform outputs
├── variables.tf            # Input variables
├── terraform.tfstate       # Terraform state file (generated)
├── terraform.tfstate.backup # Backup of state file (generated)
└── .terraform/             # Terraform provider cache (generated)
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -am 'Add your feature'`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details (if present).

## Support

If you encounter issues:

- Check the Terraform documentation: [https://www.terraform.io/docs](https://www.terraform.io/docs)
- Azure documentation: [https://docs.microsoft.com/en-us/azure](https://docs.microsoft.com/en-us/azure)
- Open an issue in this repository.

## Version History

- **v1.0**: Initial release with basic Web App and Blob Storage setup.