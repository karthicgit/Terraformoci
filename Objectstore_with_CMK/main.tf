provider "oci" {}

terraform {
  required_providers {
    oci = {
      version = ">= 6.0.0"
      source = "oracle/oci"
    }
  }
}


data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.tenancy_ocid
}


data "oci_kms_keys" "object_kms_keys" {
  compartment_id      = var.compartment_id 
  management_endpoint = var.mgmt_endpoint

  filter {
    name   = "display_name"
    values = ["<masterkey name used in your vault>"]
  }
}

locals {
  kms_key = data.oci_kms_keys.object_kms_keys.keys.0.id
}


# Add the optional argument as required.
resource "oci_objectstorage_bucket" "bucket_with_cmk" {
  compartment_id = var.compartment_id
  name           = "demo"
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  kms_key_id     = local.kms_key
  }
