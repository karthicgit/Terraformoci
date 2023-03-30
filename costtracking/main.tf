resource "oci_identity_tag_namespace" "tag_namespace" {

  compartment_id = var.compartment_ocid
  description    = "Tag Namespace used for Cost tracking"
  name           = var.tag_namespace_name

  defined_tags  = lookup(var.tags, "defined_tags", {})
  freeform_tags = lookup(var.tags, "freeform_tags", {})
  is_retired    = var.is_retired
}

resource "oci_identity_tag" "tag" {

  description      = "Tag key used for cost tracking"
  name             = var.tag_name
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace.id


  is_cost_tracking = var.is_cost_tracking
  validator {
    validator_type = "ENUM"
    values         = var.tag_values
  }
  is_retired = var.is_retired
}
