module "rg_caftest" {
  source  = "aztfmod/caf-resource-group/azurerm"
  version = "0.1.1"
  
    prefix          = local.prefix
    resource_groups = local.resource_groups
    tags            = local.tags
}

module "front-door" {
  source = "../../../front-door"
  #version = "0.x.y"

  front-door-rg         = module.rg_caftest.names.test
  location              = local.location
  front-door-object     = var.front-door-object
  front-door-waf-object = var.front-door-waf-object
  tags                  = local.tags
}

