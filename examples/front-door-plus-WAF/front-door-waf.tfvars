front-door-waf-object = {
  waf1 = {
    name         = "caftestwafpolicy"
    enabled      = true
    mode         = "Prevention"
    redirect_url = "https://www.bing.com"
    custom_rule = {
      cr1 = {
        name     = "Rule1"
        action   = "Block"
        enabled  = true
        priority = 1
        type     = "MatchRule"
        match_condition = {
          match_variable     = "RequestHeader"
          match_values       = ["windows"]
          operator           = "Contains"
          selector           = "UserAgent"
          negation_condition = false
          transforms         = ["Lowercase", "Trim"]
        }
        rate_limit_duration_in_minutes = 1
        rate_limit_threshold           = 10

      }
    }
    custom_block_response_status_code = 403
    custom_block_response_body        = "./blocked-response.html"

    managed_rule = {
      mr1 = {
        type    = "DefaultRuleSet"
        version = "1.0"
        exclusion = {
          ex1 = {
            match_variable = "QueryStringArgNames"
            operator       = "Equals"
            selector       = "not_suspicious"
          }
        }
        override = {
          or1 = {
            rule_group_name = "PHP"
            exclusion = {
              ex1 = {
                match_variable = "QueryStringArgNames"
                operator       = "Equals"
                selector       = "not_suspicious"
              }
            }
            rule = {
              r1 = {
                rule_id = "933100"
                action  = "Block"
                enabled = false
                exclusion = {
                  ex1 = {
                    match_variable = "QueryStringArgNames"
                    operator       = "Equals"
                    selector       = "not_suspicious"
                  }
                }
              }
            }
          }
        }
      }
    }
    tags = ""

  }


}
  
