#Database Resource Group
data "azurerm_resource_group" "database" {
  name = "database"
}

#Database
data "azurerm_mysql_flexible_server" "database" {
  name                = "conoco-project2"
  resource_group_name = data.azurerm_resource_group.database.name
}

#Create Private Endpoint for DB
resource "azurerm_private_endpoint" "dataprivend" {
  name                = "sillk-mysql"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
  subnet_id           = azurerm_subnet.endpoint-subnet.id

  private_service_connection {
    name                           = "sillk-privateserviceconnection"
    private_connection_resource_id = data.azurerm_mysql_flexible_server.database.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dbprivend.id]
  }
}

resource "azurerm_private_dns_zone" "dbprivend" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.SiLLK.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbprivendlink" {
  name                  = "virtualnetwork-link"
  resource_group_name   = azurerm_resource_group.SiLLK.name
  private_dns_zone_name = azurerm_private_dns_zone.dbprivend.name
  virtual_network_id    = azurerm_virtual_network.sillk-vnet.id
}