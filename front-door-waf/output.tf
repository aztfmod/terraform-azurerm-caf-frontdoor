#outputs.tf
output "object" {
  depends_on = [azurerm_frontdoor_firewall_policy.afront-door-waf-policy]
  
  value = azurerm_frontdoor_firewall_policy.front-door-waf-policy
}

output "waf-map" {
  value = {
    for waf in azurerm_frontdoor_firewall_policy.front-door-waf-policy:
    waf.name => waf.id

  }
}
