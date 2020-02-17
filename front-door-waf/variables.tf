variable "front-door-rg" {
  description = "(Required) Resource Group of the Azure Front Door WAF Policy to be created"  
}

variable "front-door-waf-object" {
  description = "(Required) AFD Settings of the Azure  Front Door to be created"  
}

variable "tags" {
  description = "(Required) Tags of the Azure  Front Door to be created"  
}
