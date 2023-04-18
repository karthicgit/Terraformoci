locals {
  policy_compartment_id = var.policy_compartment_id == null ? var.compartment_ocid : var.policy_compartment_id
  compartment_name      = data.oci_identity_compartment.this_compartment.name
  dg_rule               = "ALL {resource.type='loganalyticsscheduledtask', resource.compartment.id='${var.compartment_ocid}'}"
  savedsearch_policy = ["allow dynamic-group ${var.dynamic_group_name} to use metrics in tenancy",
    "allow dynamic-group ${var.dynamic_group_name} to read management-saved-search in tenancy",
    "allow dynamic-group ${var.dynamic_group_name} to {LOG_ANALYTICS_QUERY_VIEW} in tenancy",
    "allow dynamic-group ${var.dynamic_group_name} to {LOG_ANALYTICS_QUERYJOB_WORK_REQUEST_READ} in tenancy",
    "allow dynamic-group ${var.dynamic_group_name} to READ loganalytics-log-group in tenancy",
  "allow dynamic-group ${var.dynamic_group_name} to read compartments in tenancy"]
}


resource "oci_identity_dynamic_group" "savedsearch_dynamic_group" {
  count          = var.create_dg ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for savedsearch in Logging analytics"
  matching_rule  = local.dg_rule
  name           = var.dynamic_group_name

}

resource "oci_identity_policy" "savedsearch_policy" {
  count = var.create_policy ? 1 : 0

  compartment_id = var.tenancy_ocid
  description    = "Policy for savedsearch in Logging analytics"
  name           = var.policy_name
  statements     = local.savedsearch_policy


}

#Delay for policy to take effect
resource "time_sleep" "wait_30_seconds" {
  depends_on = [oci_identity_policy.savedsearch_policy, oci_identity_dynamic_group.savedsearch_dynamic_group]

  create_duration = "30s"
  count           = (var.create_policy && var.create_dg) ? 1 : 0
}

resource "oci_log_analytics_namespace_scheduled_task" "scheduled_task" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]

  compartment_id = var.compartment_ocid
  kind           = var.kind
  namespace      = data.oci_objectstorage_namespace.log_namespace.namespace
  task_type      = var.task_type
  defined_tags   = lookup(var.tags, "defined_tags", {})
  display_name   = var.display_name
  freeform_tags  = lookup(var.tags, "freeform_tags", {})
  #saved_search_id = oci_log_analytics_saved_search.test_saved_search.id


  dynamic "action" {
    for_each = (var.kind == "STANDARD" && var.task_type == "SAVED_SEARCH") ? [1] : []
    content {
      type = "STREAM"
      metric_extraction {
        compartment_id = var.compartment_ocid
        metric_name    = var.metric_name
        namespace      = var.metric_namespace
        resource_group = var.metric_resource_group
      }
      saved_search_id = var.saved_search_id
    }
  }
  dynamic "action" {
    for_each = (var.kind == "STANDARD" && var.task_type == "PURGE") ? [1] : []
    content {
      type = "PURGE"

      compartment_id_in_subtree = var.purge_compartment_id_in_subtree
      data_type                 = var.purge_data_type

      purge_compartment_id = var.compartment_ocid
      purge_duration       = var.purge_duration
      query_string         = var.purge_query_string
    }
  }

  dynamic "schedules" {
    for_each = var.kind == "STANDARD" ? [1] : []
    content {
      schedule {
        type = var.schedule_type

        expression         = var.schedule_type == "CRON" ? var.expression : null
        misfire_policy     = "RETRY_ONCE"
        recurring_interval = var.recurring_interval
        repeat_count       = var.repeat_count
        time_zone          = var.schedule_type == "CRON" ? var.time_zone : null
      }
    }
  }
  #Used to ignore changes for auto-created defined tags
  lifecycle {
    ignore_changes = [
      defined_tags
    ]
  }
}
