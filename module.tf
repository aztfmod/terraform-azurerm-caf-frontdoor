#Create 1 to x Azure Front Door Policies
module "azure_front_door_waf" {
  source = "./front-door-waf"

  front-door-rg           = var.front-door-rg
  front-door-waf-object   = var.front-door-waf-object
  tags                    = var.tags

}
  
#Create Azure Front Door Resource
resource "azurerm_frontdoor" "front-door" {
  depends_on                                   = [module.azure_front_door_waf]
  name                                         = var.front-door-object.name
  friendly_name                                = var.front-door-object.friendly_name
  location                                     = var.location
  resource_group_name                          = var.front-door-rg
  enforce_backend_pools_certificate_name_check = var.front-door-object.enforce_backend_pools_certificate_name_check
  load_balancer_enabled                        = var.front-door-object.load_balancer_enabled
  tags                                         = var.tags

  dynamic "routing_rule" {
    for_each = var.front-door-object.routing_rule
    content {
      name               = routing_rule.value.name
      accepted_protocols = routing_rule.value.accepted_protocols
      patterns_to_match  = routing_rule.value.patterns_to_match
      frontend_endpoints = routing_rule.value.frontend_endpoints
      dynamic "forwarding_configuration" {
        for_each = routing_rule.value.configuration == "Forwarding" ? [routing_rule.value.forwarding_configuration] : []
        content {
          backend_pool_name                     = routing_rule.value.forwarding_configuration.backend_pool_name
          cache_enabled                         = routing_rule.value.forwarding_configuration.cache_enabled                           
          cache_use_dynamic_compression         = routing_rule.value.forwarding_configuration.cache_use_dynamic_compression #default: false
          cache_query_parameter_strip_directive = routing_rule.value.forwarding_configuration.cache_query_parameter_strip_directive
          custom_forwarding_path                = routing_rule.value.forwarding_configuration.custom_forwarding_path
          forwarding_protocol                   = routing_rule.value.forwarding_configuration.forwarding_protocol
        }
      }
      dynamic "redirect_configuration" {
        for_each = routing_rule.value.configuration == "Redirecting" ? [routing_rule.value.redirect_configuration] : []
        content {
          custom_host         = routing_rule.value.redirect_configuration.custom_host
          redirect_protocol   = routing_rule.value.redirect_configuration.redirect_protocol
          redirect_type       = routing_rule.value.redirect_configuration.redirect_type
          custom_fragment     = routing_rule.value.redirect_configuration.custom_fragment
          custom_path         = routing_rule.value.redirect_configuration.custom_path
          custom_query_string = routing_rule.value.redirect_configuration.custom_query_string
        }
      }
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = var.front-door-object.backend_pool_load_balancing
    content {
      name                            = backend_pool_load_balancing.value.name
      sample_size                     = backend_pool_load_balancing.value.sample_size
      successful_samples_required     = backend_pool_load_balancing.value.successful_samples_required
      additional_latency_milliseconds = backend_pool_load_balancing.value.additional_latency_milliseconds
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.front-door-object.backend_pool_health_probe
    content {
      name                = backend_pool_health_probe.value.name
      path                = backend_pool_health_probe.value.path
      protocol            = backend_pool_health_probe.value.protocol
      interval_in_seconds = backend_pool_health_probe.value.interval_in_seconds
    }
  }

  dynamic "frontend_endpoint" {
    for_each = var.front-door-object.frontend_endpoint
    content {
      name                              = frontend_endpoint.value.name
      host_name                         = frontend_endpoint.value.host_name
      session_affinity_enabled          = frontend_endpoint.value.session_affinity_enabled
      session_affinity_ttl_seconds      = frontend_endpoint.value.session_affinity_ttl_seconds
      custom_https_provisioning_enabled = frontend_endpoint.value.custom_https_provisioning_enabled
      dynamic "custom_https_configuration" {
        for_each = frontend_endpoint.value.custom_https_provisioning_enabled == true ? [frontend_endpoint.value.custom_https_configuration] : []
        content {
          azure_key_vault_certificate_vault_id       = custom_https_configuration.value.azure_key_vault_certificate_vault_id
          azure_key_vault_certificate_secret_name    = custom_https_configuration.value.azure_key_vault_certificate_secret_name
          azure_key_vault_certificate_secret_version = custom_https_configuration.value.azure_key_vault_certificate_secret_version
        }
      }
      web_application_firewall_policy_link_id = frontend_endpoint.value.web_application_firewall_policy_link_name != "" ? module.azure_front_door_waf.waf-map[frontend_endpoint.value.web_application_firewall_policy_link_name] : ""
    }
  }

  dynamic "backend_pool" {
    for_each = var.front-door-object.backend_pool
    content {
      name                = backend_pool.value.name
      load_balancing_name = backend_pool.value.load_balancing_name
      health_probe_name   = backend_pool.value.health_probe_name

      dynamic "backend" {
        for_each = backend_pool.value.backend
        content {
          enabled     = backend.value.enabled
          address     = backend.value.address
          host_header = backend.value.host_header
          http_port   = backend.value.http_port
          https_port  = backend.value.https_port
          priority    = backend.value.priority
          weight      = backend.value.weight
        }
      }
    }
  }
}
