provider "oci" {}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

variable "compartment_ocid" {
  type        = string
  description = "The OCID of the compartment where the Resource Analytics Instance will be created"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for the Resource Analytics Instance"
}

variable "freeform_tags" {
  type        = map(string)
  default     = {}
  description = "Freeform tags for the Resource Analytics Instance"
}

variable "secret_id" {}

variable "license_model" {}

variable "description" {}

variable "display_name" {}

variable "subnet_id" {}

variable "ra_regions" {}


resource "oci_resource_analytics_resource_analytics_instance" "test_resource_analytics_instance" {
  lifecycle {
    ignore_changes = [ defined_tags ]
  }

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  adw_admin_password {
    password_type = "VAULT_SECRET"
    secret_id     = var.secret_id
  }
  compartment_id = var.compartment_ocid
  subnet_id      = var.subnet_id


  defined_tags           = var.defined_tags
  description            = var.description
  display_name           = var.display_name
  freeform_tags          = var.freeform_tags
  is_mutual_tls_required = false
  license_model          = var.license_model
  # nsg_ids = var.resource_analytics_instance_nsg_ids

}

resource "oci_resource_analytics_monitored_region" "test_monitored_region" {
  for_each                       = toset(var.ra_regions)
  region_id                      = each.value
  resource_analytics_instance_id = oci_resource_analytics_resource_analytics_instance.test_resource_analytics_instance.id

}
