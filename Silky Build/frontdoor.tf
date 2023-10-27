resource "azurerm_cdn_frontdoor_profile" "sillkFDProfile" {
  name                = "sillkFDProfile"
  resource_group_name = azurerm_resource_group.SiLLK.name
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "sillkFDEndpoint" {
  name                     = "sillkFDEndpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.sillkFDProfile.id

}

resource "azurerm_cdn_frontdoor_origin" "LBOrigin" {
  name                           = "LBOrigin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.originGroup.id
  enabled                        = true
  host_name                      = azurerm_public_ip.publicIP.ip_address
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_origin_group" "originGroup" {
  name                     = "originGroup"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.sillkFDProfile.id


  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.sillkFDEndpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.originGroup.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.LBOrigin.id]

  supported_protocols    = ["Http"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpOnly"
  https_redirect_enabled = false
}
