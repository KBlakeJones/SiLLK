# Create an Azure Key Vault
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "sillkkv" {
  name                        = "sillk-keyvault"
  location                    = azurerm_resource_group.SiLLK.location
  resource_group_name         = azurerm_resource_group.SiLLK.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

