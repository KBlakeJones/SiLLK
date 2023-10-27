#Creation of Scale Set - 2 Instances
resource "azurerm_linux_virtual_machine_scale_set" "sillkss" {
  name                            = "sillkss"
  resource_group_name             = azurerm_resource_group.SiLLK.name
  location                        = azurerm_resource_group.SiLLK.location
  sku                             = "Standard_D1_v2"
  instances                       = 2
  computer_name_prefix            = "sillk-vm-1"
  admin_username                  = "adminuser"
  admin_password                  = "Pa$$w0rd"
  disable_password_authentication = false
  custom_data                     = filebase64("script.sh")


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "sillk-ssnic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.vm-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.BackEnd-Pool.id]
    }
  }

  boot_diagnostics {
    storage_account_uri = "https://bdlawson1234.blob.core.windows.net/"

  }
}
















#resource "azurerm_linux_virtual_machine_scale_set" "sillkvmss" {
# name                = "sillkvmss"
# resource_group_name = var.rg_name
# location            = var.location
#sku                 = "Standard_B2s"
#instances           = 2
#admin_username      = "sillk"
#admin_password      = "$iLLK"


#source_image_reference {
# publisher = "Canonical"
# offer     = "0001-com-ubuntu-server-focal"
# sku       = "20_04-lts-gen2"
# version   = "latest"
# }

#os_disk {
# storage_account_type = "Premium_LRS"
# caching              = "ReadWrite"
# }

#network_interface { #unfinished requires NIC
#name    = "example"
#primary = true

# ip_configuration { #unfinished, requires ipconfig from subnet.
#  name      = "internal"
# primary   = true
# subnet_id = azurerm_subnet.vm-subnet.id //updated BJ 6:04pm 11/23
# }
# }
#}
