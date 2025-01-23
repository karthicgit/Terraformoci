provider "oci" {}

terraform {
  required_providers {
    oci = {
      version = ">= 6.15.0"
      source = "oracle/oci"
    }
  }
}


variable "compartment_id" {}


variable "tenancy_id" {
    
}
variable "fleet_type" {
    default = "PRODUCT"
}

variable "resources" {
    default = []
  
}

variable "rule_conditions" {
  type = object({
    conditions = list(object({
      attr_group = string
      attr_key   = string
      attr_value = string
    }))
  })
}

variable "topic_id" {
   
}

variable "fleet_display_name" {
    default = "DBPRODUCTFLEET"
}


variable "fleet_description" {
    default = "Fleet for DB Patching"
}

variable "defined_tags" {
    default = {}
}

variable "freeform_tags" {
    default = {}
}

variable "fleet_products" {
    default = ["Oracle Base Database Service"]
}

