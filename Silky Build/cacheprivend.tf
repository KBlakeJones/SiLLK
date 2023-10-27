#Create Private Endpoint for Azure Cache for Redis 
resource "azurerm_private_endpoint" "cacheprivend" {
  name                = "sillk-cachepep"
  location            = azurerm_resource_group.SiLLK.location
  resource_group_name = azurerm_resource_group.SiLLK.name
  subnet_id           = azurerm_subnet.endpoint-subnet.id


  #Create private service connection
  private_service_connection {
    name                           = "sillk-privateserviceconnection"
    private_connection_resource_id = azurerm_redis_cache.cache.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  #create private dns group
  private_dns_zone_group {
    name                 = "cacheprivend-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cacheprivend.id]
  }
}

#create private dns zone
resource "azurerm_private_dns_zone" "cacheprivend" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.SiLLK.name
}

#create private network link
resource "azurerm_private_dns_zone_virtual_network_link" "cacheprivend" {
  name                  = "sillkcache-link"
  resource_group_name   = azurerm_resource_group.SiLLK.name
  private_dns_zone_name = azurerm_private_dns_zone.cacheprivend.name
  virtual_network_id    = azurerm_virtual_network.sillk-vnet.id
}
