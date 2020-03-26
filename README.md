[![Gitter](https://badges.gitter.im/aztfmod/community.svg)](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# Create a Front Door with associated WAF Policies linked to Frontend Endpoints

Creates a Front Front Door with:

* 1 to many Backend Pools
* 1 to many Routing Rules
* 1 to many Frontend Endpoints
* 1 to many WAF Policies and links them to Frontend Endpoints
 
Reference the module to a specific version (recommended):
```hcl
module "front-door" {
    source = "aztfmod/caf-frontdoor/azurerm"           #Point to front-end module location
    version = "0.x.y"
    
    front-door-rg           = var.rg
    location                = var.location
    front-door-object       = var.front-door-object
    front-door-waf-object   = var.front-door-waf-object
    tags                    = var.tags
}
```
Link to Terraform providor:
  * Front Door: https://www.terraform.io/docs/providers/azurerm/r/frontdoor.html
  * Front Door WAF: https://www.terraform.io/docs/providers/azurerm/r/frontdoor_firewall_policy.html

## Inputs
| Name | Type | Default | Description | 
| -- | -- | -- | -- | 
| front-door-rg | string | None | Name of the resource group where to create the resource. Changing this forces a new resource to be created. |
| location | string | None | Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created.  | 
| front-door-object | object | None | Front Door configuration object as described in the Parameters section.  | 
| front-door-waf-object | object | None | Front Door WAF configuration object as described in the Parameters section.  | 
| tags | map | None | Map of tags for the deployment.  | 

## Parameters

### front-door-object
(Required) Confirguration object describing the Front Door configuration.
The object has sections are as follows:

#### Front Door Parameters
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the Front Door service. Changing this forces a new resource to be created. | 
|resource_group_name  | Required |  Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created. | 
|location  | Required |  Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | 
|backend_pool  | Required |  A backend_pool block as defined below. | 
|backend_pool_health_probe  | Required |  A backend_pool_health_probe block as defined below. | 
|backend_pool_load_balancing  | Required |  A backend_pool_load_balancing block as defined below. | 
|enforce_backend_pools_certificate_name_check  | Required |  Enforce certificate name check on HTTPS requests to all backend pools, this setting will have no effect on HTTP requests. Permitted values are true or false. | 
|load_balancer_enabled  | Optional |  Should the Front Door Load Balancer be Enabled? Defaults to true. | 
|friendly_name  | Optional |  A friendly name for the Front Door service. | 
|frontend_endpoint  | Required |  A frontend_endpoint block as defined below. | 
|routing_rule  | Required |  A routing_rule block as defined below. | 
|tags  | Optional |  A mapping of tags to assign to the resource. | 

#### Backend Pool Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the Backend Pool. | 
|backend  | Required |  A backend block as defined below. | 
|load_balancing_name  | Required |  Specifies the name of the backend_pool_load_balancing block within this resource to use for this Backend Pool. | 
|health_probe_name  | Required |  Specifies the name of the backend_pool_health_probe block whithin this resource to use for this Backend Pool. | 

#### Backend Block
| Name | Type | Description |
| -- | -- | -- |
|enabled  | Optional |  Specifies if the backend is enabled or not. Valid options are true or false. Defaults to true. | 
|address  | Required |  Location of the backend (IP address or FQDN) | 
|host_header  | Required |  The value to use as the host header sent to the backend. | 
|http_port  | Required |  The HTTP TCP port number. Possible values are between 1 - 65535. | 
|https_port  | Required |  The HTTPS TCP port number. Possible values are between 1 - 65535. | 
|priority  | Optional |  Priority to use for load balancing. Higher priorities will not be used for load balancing if any lower priority backend is healthy. Defaults to 1. | 
|weight  | Optional |  Weight of this endpoint for load balancing purposes. Defaults to 50. | 

#### Frontend Endpoint Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the frontend_endpoint. | 
|host_name  | Required |  Specifies the host name of the frontend_endpoint. Must be a domain name. | 
|session_affinity_enabled  | Optional |  Whether to allow session affinity on this host. Valid options are true or false Defaults to false. | 
|session_affinity_ttl_seconds  | Optional |  The TTL to use in seconds for session affinity, if applicable. Defaults to 0. | 
|custom_https_provisioning_enabled  | Required |  Should the HTTPS protocol be enabled for a custom domain associated with the Front Door? | 
|custom_https_configuration  | Optional |  A custom_https_configuration block as defined below. **NOTE**: This block is required when custom_https_provisioning_enabled is set to true. | 
|web_application_firewall_policy_link_id  | Optional |  Defines the Web Application Firewall policy ID for each host. | 


#### Backend Pool Health Probe Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the Health Probe. | 
|path  | Optional |  The path to use for the Health Probe. Default is /. | 
|protocol  | Optional |  Protocol scheme to use for the Health Probe. Defaults to Http. | 
|interval_in_seconds  | Optional |  The number of seconds between each Health Probe. Defaults to 120. | 

#### Backend Pool Load Balancing Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the Load Balancer. | 
|sample_size  | Optional |  The number of samples to consider for load balancing decisions. Defaults to 4. | 
|successful_samples_required  | Optional |  The number of samples within the sample period that must succeed. Defaults to 2. | 
|additional_latency_milliseconds  | Optional |  The additional latency in milliseconds for probes to fall into the lowest latency bucket. Defaults to 0. | 

#### Routing Rule Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Specifies the name of the Routing Rule. | 
|frontend_endpoints  | Required |  The names of the frontend_endpoint blocks whithin this resource to associate with this routing_rule. | 
|accepted_protocols  | Optional |  Protocol schemes to match for the Backend Routing Rule. Defaults to Http. | 
|patterns_to_match  | Optional |  The route patterns for the Backend Routing Rule. Defaults to /*. | 
|enabled  | Optional |  Enable or Disable use of this Backend Routing Rule. Permitted values are true or false. Defaults to true. | 
|forwarding_configuration  | Optional |  A forwarding_configuration block as defined below. | 
|redirect_configuration  | Optional |  A redirect_configuration block as defined below. | 

#### Forwarding Configuration Block
| Name | Type | Description |
| -- | -- | -- |
|backend_pool_name  | Required |  Specifies the name of the Backend Pool to forward the incoming traffic to. | 
|cache_enabled  | Optional |  Specifies whether to Enable caching or not. Valid options are true or false. Defaults to true. | 
|cache_use_dynamic_compression  | Optional |  Whether to use dynamic compression when caching. Valid options are true or false. Defaults to false. | 
|cache_query_parameter_strip_directive  | Optional |  Defines cache behavior in releation to query string parameters. Valid options are StripAll or StripNone. Defaults to StripNone. | 
|custom_forwarding_path  | Optional |  Path to use when constructing the request to forward to the backend. This functions as a URL Rewrite. Default behavior preserves the URL path. | 
|forwarding_protocol  | Optional |  Protocol to use when redirecting. Valid options are HttpOnly, HttpsOnly, or MatchRequest. Defaults to MatchRequest. | 

#### Redirect Confirguration Block
| Name | Type | Description |
| -- | -- | -- |
|custom_host  | Optional |  Set this to change the URL for the redirection. | 
|redirect_protocol  | Optional |  Protocol to use when redirecting. Valid options are HttpOnly, HttpsOnly, or MatchRequest. Defaults to MatchRequest | 
|redirect_type  | Optional |  Status code for the redirect. Valida options are Moved, Found, TemporaryRedirect, PermanentRedirect. Defaults to Found | 
|custom_fragment  | Optional |  The destination fragment in the portion of URL after '#'. Set this to add a fragment to the redirect URL. | 
|custom_path  | Optional |  The path to retain as per the incoming request, or update in the URL for the redirection. | 
|custom_query_string  | Optional |  Replace any existing query string from the incoming request URL. | 

#### Custom HTTPS Configuration Block
| Name | Type | Description |
| -- | -- | -- |
|certificate_source  | Optional |  Certificate source to encrypted HTTPS traffic with. Allowed values are FrontDoor or AzureKeyVault. Defaults to FrontDoor. | 

#### If Certificate Source is "AzureKeyVault" 
| Name | Type | Description |
| -- | -- | -- |
|azure_key_vault_certificate_vault_id  | Required |  The ID of the Key Vault containing the SSL certificate. | 
|azure_key_vault_certificate_secret_name  | Required |  The name of the Key Vault secret representing the full certificate PFX. | 
|azure_key_vault_certificate_secret_version  | Required |  The version of the Key Vault secret representing the full certificate PFX. | 


The following front-door-object shows an example of the composition:

```hcl
Sample of front door configuration object below

front-door-object = {
  name          = "<your AFD Name>"
  friendly_name = "My Azure Front Door Service"                                   #Optional
  #disable_bgp_route_propagation                = false                           #Default: false
  enforce_backend_pools_certificate_name_check = false
  load_balancer_enabled                        = true                             #Default: true  

  routing_rule = {
    rr1 = {
      name               = "exampleRoutingRule1"
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      accepted_protocols = ["Http", "Https"]                                      #Default: "Http"
      patterns_to_match  = ["/*"]                                                 #Default: "/*"
      enabled            = true                                                   #Default: true
      configuration      = "Forwarding"                                           #Options: Forwarding / Redirect  
      forwarding_configuration = {
        backend_pool_name                     = "exampleBackendBing1"
        cache_enabled                         = false                             #Default: false
        cache_use_dynamic_compression         = false                             #Default: false
        cache_query_parameter_strip_directive = "StripNone"                       #Default: "StripNone"
        custom_forwarding_path                = ""
        forwarding_protocol                   = "MatchRequest"                    #Default: "BestMatch"  
      }
      redirect_configuration = {
        custom_host         = ""                                                  #Optional
        redirect_protocol   = "MatchRequest"                                      #Default: "MatchRequest"  
        redirect_type       = "Found"                                             #Default: "Found"
        custom_fragment     = ""
        custom_path         = ""
        custom_query_string = ""
      }
    }                                                                             #Add extra routing rules here (e.g. rr2 = {...})
  }

  backend_pool_load_balancing = {
    lb1 = {
      name                            = "exampleLoadBalancingSettings1"
      sample_size                     = 4                                         #Default: 4
      successful_samples_required     = 2                                         #Default: 2
      additional_latency_milliseconds = 0                                         #Default: 0
    }                                                                             #Add extra backend load balancing names here (e.g. lb2 = {...})
  }

  backend_pool_health_probe = {
    hp1 = {
      name                = "exampleHealthProbeSetting1"
      path                = "/"
      protocol            = "Http"                                                #Default: Http
      interval_in_seconds = 120                                                   #Default: 120
    }                                                                             #Add extra health probes here (e.g. hp2 = {...})
  }

  backend_pool = {
    bp1 = {
      name = "exampleBackendBing1"
      backend = {
        be1 = {
          enabled     = true
          address     = "www.bing.com"
          host_header = "www.bing.com"
          http_port   = 80
          https_port  = 443
          priority    = 1                                                         #Default: 1
          weight      = 50                                                        #Default: 50
        },
        be2 = {
          enabled     = true
          address     = "www.bing.co.uk"
          host_header = "www.bing.co.uk"
          http_port   = 80
          https_port  = 443
          priority    = 1  #default: 1
          weight      = 50 #default: 50
        }                                                                        #Add extra backend's here (e.g. be3 = {...})
      }
      load_balancing_name = "exampleLoadBalancingSettings1"                      #Name of backend_pool_load_balancing to use
      health_probe_name   = "exampleHealthProbeSetting1"                         #Name of backend_pool_health_probe to use
    }                                                                            #Add extra backend pools here (e.g. bp2 = {...})
  }

  frontend_endpoint = {
    fe1 = {
      name                              = "exampleFrontendEndpoint1"
      host_name                         = "<your AFD Name>.azurefd.net"
      session_affinity_enabled          = false #default: false
      session_affinity_ttl_seconds      = 0     #default: 0
      custom_https_provisioning_enabled = false
      #Required if custom_https_provisioning_enabled is true
      custom_https_configuration = {
        certificate_source = "FrontDoor"                                         #Optional (FrontDoor / AzureKeyVault)
        #If certificate source is AzureKeyVault the below are required:
        azure_key_vault_certificate_vault_id       = ""
        azure_key_vault_certificate_secret_name    = ""
        azure_key_vault_certificate_secret_version = ""
      }
      #Links the WAF Policy to the Fronend Endpoints 
      web_application_firewall_policy_link_name = "TerraformPolicy"              #Optional Enter the name of the waf policy you'll be creating 
    }                                                                            #Add extra  frontend Endpoints here (e.g. fe2 = {...})

  }
}

```

### front-door-waf-object
(Required_ Confirguration object describing the Front Door WAF configuration.

#### Front Door WAF Parameters
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  The name of the policy. Changing this forces a new resource to be created. | 
|resource_group_name  | Required |  The name of the resource group. Changing this forces a new resource to be created. | 
|enabled  | Optional |  Is the policy a enabled state or disabled state. Defaults to true. | 
|mode  | Optional |  The firewall policy mode. Possible values are Detection, Prevention and defaults to Prevention. | 
|redirect_url  | Optional |  If action type is redirect, this field represents redirect URL for the client. | 
|custom_rule  | Optional |  One or more custom_rule blocks as defined below. | 
|custom_block_response_status_code  | Optional |  If a custom_rule block's action type is block, this is the response status code. Possible values are 200, 403, 405, 406, or 429. | 
|custom_block_response_body  | Optional |  If a custom_rule block's action type is block, this is the response body needs to be set here. Possible values are either a ***relative path to a file*** or ***content***. | 
|managed_rule  | Optional |  One or more managed_rule blocks as defined below. | 
|tags  | Optional |  A mapping of tags to assign to the Web Application Firewall Policy. | 

#### Custom Rules Block
| Name | Type | Description |
| -- | -- | -- |
|name  | Required |  Gets name of the resource that is unique within a policy. This name can be used to access the resource. | 
|action  | Required |  The action to perform when the rule is matched. Possible values are Allow, Block, Log, or Redirect. | 
|enabled  | Optional |  Is the rule is enabled or disabled? Defaults to true. | 
|priority  | Required |  The priority of the rule. Rules with a lower value will be evaluated before rules with a higher value. Defaults to 1. | 
|type  | Required |  The type of rule. Possible values are MatchRule or RateLimitRule. | 
|match_condition  | Required |  One or more match_condition block defined below. | 
|rate_limit_duration_in_minutes  | Optional |  The rate limit duration in minutes. Defaults to 1. | 
|rate_limit_threshold  | Optional |  The rate limit threshold. Defaults to 10. | 

#### Match Condition Block
| Name | Type | Description |
| -- | -- | -- |
|match_variable  | Required |  The request variable to compare with. Possible values are Cookies, PostArgs, QueryString, RemoteAddr, RequestBody, RequestHeader, RequestMethod, or RequestUri. | 
|match_values  | Required |  Up to 100 possible values to match. | 
|operator  | Required |  Comparison type to use for matching with the variable value. Possible values are Any, BeginsWith, Contains, EndsWith, Equal, GeoMatch, GreaterThan, GreaterThanOrEqual, IPMatch, LessThan, LessThanOrEqual or RegEx. | 
|selector  | Optional |  Match against a specific key if the match_variable is QueryString, PostArgs, RequestHeader or Cookies. | 
|negation_condition  | Optional |  Should the result of the condition be negated. | 
|transforms  | Optional |  Up to 5 transforms to apply. Possible values are Lowercase, RemoveNulls, Trim, Uppercase, URLDecode orURLEncode. | 

#### Managed Rule Block
| Name | Type | Description |
| -- | -- | -- |
|type  | Required |  The name of the managed rule to use with this resource. | 
|version  | Required |  The version on the managed rule to use with this resource. | 
|exclusion  | Optional |  One or more exclusion blocks as defined below. | 
|override  | Optional |  One or more override blocks as defined below. | 

#### Override Block
| Name | Type | Description |
| -- | -- | -- |
|rule_group_name  | Required |  The managed rule group to override. | 
|exclusion  | Optional |  One or more exclusion blocks as defined below. | 
|rule  | Optional |  One or more rule blocks as defined below. If none are specified, all of the rules in the group will be disabled. | 

#### Rule Block
| Name | Type | Description |
| -- | -- | -- |
|rule_id  | Required |  Identifier for the managed rule. | 
|action  | Required |  The action to be applied when the rule matches. Possible values are Allow, Block, Log, or Redirect. | 
|enabled  | Optional |  Is the managed rule override enabled or disabled. Defaults to false | 
|exclusion  | Optional |  One or more exclusion blocks as defined below. | 

#### Exclusion Block
| Name | Type | Description |
| -- | -- | -- |
|match_variable  | Required |  The variable type to be excluded. Possible values are QueryStringArgNames, RequestBodyPostArgNames, RequestCookieNames, RequestHeaderNames. | 
|operator  | Required |  Comparison operator to apply to the selector when specifying which elements in the collection this exclusion applies to. Possible values are: Equals, Contains, StartsWith, EndsWith, EqualsAny. | 
|selector  | Required |  Selector for the value in the match_variable attribute this exclusion applies to. | 

The following front-door-waf-object shows an example of the composition:

```hcl
Sample of front door waf configuration object below

front-door-waf-object = {
  waf1 = {
    name         = "TerraformPolicy"
    enabled      = true                                                        #Default: true
    mode         = "Prevention"                                                #Options: Prevention / Detection
    redirect_url = "https://www.bing.com"                                      #Optional
    custom_rule = {
      cr1 = {
        name     = "Rule1"
        action   = "Block"                                                     #Options: Allow/Block/Log/Redirect
        enabled  = true                                                        #Default: true
        priority = 1                                                           #Default: 1
        type     = "MatchRule"                                                 #Options: MatchRule / RateLimitRule
        match_condition = {
          match_variable     = "RequestHeader"                                 #Options: Cookies, PostArgs, QueryString, RemoteAddr, RequestBody, RequestHeader, RequestMethod, or RequestUri
          match_values       = ["windows"]
          operator           = "Contains"                                      #Options: Any, BeginsWith, Contains, EndsWith, Equal, GeoMatch, GreaterThan, GreaterThanOrEqual, IPMatch, LessThan, LessThanOrEqual or RegEx
          selector           = "UserAgent"                                     #Used if matched_variable is  QueryString, PostArgs, RequestHeader or Cookies
          negation_condition = false                                           #If result of condition is negative
          transforms         = ["Lowercase", "Trim"]                           #Options: transforms - (Optional) Up to 5 transforms to apply. Possible values are Lowercase, RemoveNulls, Trim, Uppercase, URLDecode or URLEncode
        }
        rate_limit_duration_in_minutes = 1
        rate_limit_threshold           = 10

      }                                                                        #Add extra custom rules here (e.g. cr2 = {...})
    }
    custom_block_response_status_code = 403                                    #Options: 200, 403, 405, 406, or 429
    custom_block_response_body        = "./blocked-response.html"              #Options: Relative path to a file or content for the blocked response body. (e.g. "./blocked-response.html" or "Blocked by WAF Policy")

    managed_rule = {
      mr1 = {
        type    = "DefaultRuleSet"
        version = "1.0"
        exclusion = {
          ex1 = {
            match_variable = "QueryStringArgNames"                             #Options: match_variable - (Required) The variable type to be excluded. Possible values are QueryStringArgNames, RequestBodyPostArgNames, RequestCookieNames, RequestHeaderNames
            operator       = "Equals"                                          #Options: Equals, Contains, StartsWith, EndsWith, EqualsAny
            selector       = "not_suspicious"
          }                                                                    #Add extra managed rule exclusions here (e.g. ex2 = {...})
        }
        override = {
          or1 = {
            rule_group_name = "PHP"
            exclusion = {
              ex1 = {
                match_variable = "QueryStringArgNames"                         #Options: match_variable - (Required) The variable type to be excluded. Possible values are QueryStringArgNames, RequestBodyPostArgNames, RequestCookieNames, RequestHeaderNames
                operator       = "Equals"                                      #Options: Equals, Contains, StartsWith, EndsWith, EqualsAny
                selector       = "not_suspicious"
              }                                                                #Add extra override exclusions here (e.g. ex2 = {...})
            }
            rule = {
              r1 = {
                rule_id = "933100"
                action  = "Block"                                              #Options: Allow, Block, Log, or Redirect
                enabled = false                                                #Default: true
                exclusion = {
                  ex1 = {
                    match_variable = "QueryStringArgNames"                     #Options: match_variable - (Required) The variable type to be excluded. Possible values are QueryStringArgNames, RequestBodyPostArgNames, RequestCookieNames, RequestHeaderNames
                    operator       = "Equals"                                  #Options: Equals, Contains, StartsWith, EndsWith, EqualsAny
                    selector       = "not_suspicious"
                  }                                                            #Add extra rule exclusions here (e.g. ex2 = {...})
                }
              }                                                                #Add extra rule to override here (e.g. r2 = {...})
            }
          }                                                                    #Add extra overrides here (e.g or2 = {...}
        }
      }                                                                        #Add extra managed rules here (e.g. mr2 = {...})
    }
    tags = ""

  }                                                                            #Add extra WAF Policies here (e.g. waf2 = {...})
}
```

## Output

| Name | Type | Description | 
| -- | -- | -- | 
| front-door-object | Object | Object with the outputs from the Front Door provider. |
| front-door-waf-object | Object | Object with the outputs from the Front Door WAF provider. |

 The WAF policies are linked to the Frontend Endpoints within Azure Front Door.
 
