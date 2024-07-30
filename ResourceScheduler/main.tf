resource "oci_resource_scheduler_schedule" "schedule" {
  for_each = var.schedules

  action = each.value.action
  compartment_id = each.value.compartment_id
  recurrence_details = each.value.recurrence_details
  recurrence_type = each.value.recurrence_type

  defined_tags = each.value.defined_tags
  description = each.value.description
  display_name = each.value.display_name
  freeform_tags = each.value.freeform_tags

  dynamic "resource_filters" {
    for_each = each.value.resource_filters == null ? [] : each.value.resource_filters
    content {

      attribute = resource_filters.value.attribute
      condition = resource_filters.value.condition
      should_include_child_compartments = resource_filters.value.should_include_child_compartments

      dynamic "value" {
        for_each = resource_filters.value.values
        content {
          namespace = value.value.namespace
          tag_key = value.value.tag_key
          value = value.value.value
        }
      }
    }
  }

  dynamic "resources" {
    for_each = each.value.resources == null ? [] : each.value.resources
    content {
      id = resources.value.id
      metadata = resources.value.metadata
    }
  }

  time_ends = each.value.time_ends
  time_starts = each.value.time_starts
}
