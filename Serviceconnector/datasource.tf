data "oci_identity_compartment" "this_compartment" {
  id = var.compartment_ocid
}

data "oci_objectstorage_namespace" "log_namespace" {
  compartment_id = var.tenancy_ocid
}
