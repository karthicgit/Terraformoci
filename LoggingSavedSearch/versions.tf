terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.115.0"
    }
  }
  required_version = ">= 1.2.0"
}
