resource "azurerm_virtual_network" "sillk-vnet" {
  name                = "sillk-vnet"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.SiLLK.name
  virtual_network_name = azurerm_virtual_network.sillk-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "netapp-subnet" {
  name                 = "netapp-subnet"
  resource_group_name  = azurerm_resource_group.SiLLK.name
  virtual_network_name = azurerm_virtual_network.sillk-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "endpoint-subnet" {
  name                 = "endpoint-subnet"
  resource_group_name  = azurerm_resource_group.SiLLK.name
  virtual_network_name = azurerm_virtual_network.sillk-vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

