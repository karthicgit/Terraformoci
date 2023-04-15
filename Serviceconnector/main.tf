locals {
  policy_compartment_id = var.policy_compartment_id == null ? var.compartment_ocid : var.policy_compartment_id
  compartment_name      = data.oci_identity_compartment.this_compartment.name
  dg_rule               = "All {resource.type = 'serviceconnector', resource.compartment.id = '${var.compartment_ocid}'}" 
  svcconn_policy = ["Allow dynamic-group ${var.dynamic_group_name} to use loganalytics-log-group in compartment ${local.compartment_name}"]
    
}

#Create dynamic group
resource "oci_identity_dynamic_group" "service_dynamic_group" {
  count          = var.create_dg ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for service connector"
  matching_rule  = local.dg_rule
  name           = var.dynamic_group_name

}

#Create policy for service connector
resource "oci_identity_policy" "serviceconnector_policy" {
  count = var.create_policy ? 1 : 0

  compartment_id = local.policy_compartment_id
  description    = "Policy for service connector"
  name           = var.policy_name
  statements     = local.svcconn_policy

}

#Logging module to create new log group and service logs
module "logging" {
  source  = "oracle-terraform-modules/logging/oci"
  version = "0.3.0"
  compartment_id = var.compartment_ocid
  tenancy_id = var.tenancy_ocid
  service_logdef = var.service_logdef
}

#Create LA log group
resource "oci_log_analytics_log_analytics_log_group" "la_log_group" {
    count = var.create_lg ? 1 : 0
    compartment_id = var.compartment_ocid
    display_name = var.la_log_group_name
    namespace = data.oci_objectstorage_namespace.log_namespace.namespace
    defined_tags = lookup(var.defined_tags,"LA",{})
    freeform_tags = lookup(var.freeform_tags,"LA",{})

}

#Service connector for source Streaming & Logging and target Log Analytics
resource "oci_sch_service_connector" "oci_service_connector" {
  compartment_id = var.compartment_ocid
  display_name   = var.service_connector_display_name
  source {
    kind = var.sch_source
    dynamic "cursor" {
      for_each = var.sch_source == "streaming" ? [1] : []
      content {
        #https://docs.oracle.com/en-us/iaas/Content/Streaming/Tasks/using_a_single_consumer.htm#usingcursors
        kind = coalesce(var.stream_cursor, "LATEST")
      }
    }

    dynamic "log_sources" {
      for_each = var.sch_source == "logging" ? var.service_logdef : {}
      content {
        compartment_id = var.compartment_ocid
        log_group_id   = module.logging.vcn_loggroupid[log_sources.value.loggroup]
        log_id         = module.logging.vcn_logid[log_sources.key]

      }
    }
    stream_id = var.sch_source == "streaming" ? var.stream_id : null
  }
  target {
    kind = "loggingAnalytics"
    log_group_id          = coalesce(var.la_log_group_id,oci_log_analytics_log_analytics_log_group.la_log_group[0].id)
    log_source_identifier = var.sch_source == "streaming" ? var.la_log_source : null
    
  }
  defined_tags  = lookup(var.defined_tags, "svc_connector", {})
  description   = "Service connector to Logging Analytics"
  freeform_tags = lookup(var.freeform_tags, "svc_connector", {})
  dynamic "tasks" {
    for_each = var.task_type == "logRule" ? [1] : []
    content {
      kind      = var.task_type
      condition = var.tasks_condition
    }
  }
  dynamic "tasks" {
    for_each = var.task_type == "function" ? [1] : []
    content {

      kind = var.task_type

      batch_size_in_kbs = var.tasks_batch_size_in_kbs
      batch_time_in_sec = var.tasks_batch_time_in_sec
      function_id       = var.function_id
    }
  }
    depends_on = [module.logging]
}
