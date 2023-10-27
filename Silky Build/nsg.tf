resource "azurerm_network_security_group" "vm-nsg" {
  name                = "sillkvmnsg"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
}

resource "azurerm_network_security_group" "endpoint-nsg" {
  name                = "sillkepnsg"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
}

resource "azurerm_subnet_network_security_group_association" "vm-sga" {
  subnet_id                 = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "endpoint-sga" {
  subnet_id                 = azurerm_subnet.endpoint-subnet.id
  network_security_group_id = azurerm_network_security_group.endpoint-nsg.id
}

resource "azurerm_network_security_rule" "sillkallow-inbound" {
  name                        = "sillkallow-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"      
  source_port_range           = "*"       
  destination_port_range      = "80"       
  source_address_prefix       = "*" 
  destination_address_prefix  = "*" 
  resource_group_name         = azurerm_resource_group.SiLLK.name
  network_security_group_name = azurerm_network_security_group.vm-nsg.name 
}

resource "azurerm_network_security_rule" "allow-endpoints" {
  name                        = "allow-private-endpoint"
  priority                    = 300
  direction                   = "Outbound" 
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80" 
  source_address_prefix       = "10.0.2.0" 
  destination_address_prefix  = "10.0.4.0" 
  resource_group_name         = azurerm_resource_group.SiLLK.name
  network_security_group_name = azurerm_network_security_group.endpoint-nsg.name
}
resource "azurerm_network_security_rule" "allow-vmss" {
  name                        = "allow-vmss"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"      
  source_port_range           = "80"        
  destination_port_range      = "80"       
  source_address_prefix       = "10.0.2.0" 
  destination_address_prefix  = "10.0.4.0" 
  resource_group_name         = azurerm_resource_group.SiLLK.name
  network_security_group_name = azurerm_network_security_group.vm-nsg.name 
}

# 

  /* security_rule {
    name                       = "allow-endpoint"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0"
  }





/* resource "azurerm_network_security_group" "netapp-nsg" {
  name                = "netapp-nsg"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name

  security_rule {
    name                       = "allow-endpoint"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0"
  }
}

resource "azurerm_network_security_group" "endpoint-nsg" {
  name                = "endpoint-nsg"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name

  security_rule {
    name                       = "allow-endpoint"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.4.0"
  }
}

 */
