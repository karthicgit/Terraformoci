terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.114.0"
    }
  }
  required_version = ">= 1.3.0"
}
