resource "azurerm_cdn_frontdoor_firewall_policy" "sillkWAFpolicy" {
  name                              = "sillkWAFpolicy"
  resource_group_name               = azurerm_resource_group.SiLLK.name
  sku_name                          = azurerm_cdn_frontdoor_profile.sillkFDProfile.sku_name
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = azurerm_public_ip.publicIP.fqdn
  custom_block_response_status_code = 403
  custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="

  custom_rule {
    name                           = "sillkrule1"
    enabled                        = true
    priority                       = 1
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
    type                           = "MatchRule"
    action                         = "Allow"


    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["0.0.0.0/0"]
    }
  }
}

