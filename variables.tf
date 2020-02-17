variable "front-door-rg" {
  description = "(Required) Resource Group of the Front Door to be created"  
}

variable "location" {
  description = "(Required) Location of the Front Door to be created"  
}

variable "front-door-object" {
  description = "(Required) Front Door Object configuration"  
}

variable "front-door-waf-object" {
    description = "(Required) Front Door WAF Object configuration"
}

variable "tags" {
  description = "(Required) Tags of the Front Door to be created"  
}

