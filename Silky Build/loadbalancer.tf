# Public IP
resource "azurerm_public_ip" "publicIP" {
  name                = "sillk-pip"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "sillkLb" {
  name                = "sillkLb"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
  sku                 = "Standard"

  # associates the public IP to the load balancer
  frontend_ip_configuration {
    name                 = "sillkfend-ip"
    public_ip_address_id = azurerm_public_ip.publicIP.id
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "BackEnd-Pool" {
  loadbalancer_id = azurerm_lb.sillkLb.id
  name            = "sillkbend-pool"
}

resource "azurerm_lb_probe" "sillkprobe" {
  loadbalancer_id = azurerm_lb.sillkLb.id
  name            = "sillk-probe"
  port            = 22
  protocol        = "Tcp"
}

resource "azurerm_lb_rule" "LBRule" {
  loadbalancer_id                = azurerm_lb.sillkLb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "sillkfend-ip"
  probe_id                       = azurerm_lb_probe.sillkprobe.id
  disable_outbound_snat          = true
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.BackEnd-Pool.id]
}

resource "azurerm_lb_outbound_rule" "sillklbrule" {
  name                    = "sillkobrule"
  loadbalancer_id         = azurerm_lb.sillkLb.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.BackEnd-Pool.id

  frontend_ip_configuration {
    name = "sillkfend-ip"
  }
}













/* Creates a NIC for the subnet of the VM scaleset
resource "azurerm_network_interface" "ssnic" {
  name                = "sillk-ssnic"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name

  ip_configuration {
    name                          = "nicipconfig"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associates the NIC to the load balancer
resource "azurerm_network_interface_backend_address_pool_association" "nicpoolattach" {
  network_interface_id    = azurerm_network_interface.ssnic.id
  ip_configuration_name   = "nicipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.BackEnd-Pool.id
} */




