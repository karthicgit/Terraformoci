resource "oci_ons_notification_topic" "this_topic" {
  count          = var.create_topic ? 1 : 0
  compartment_id = var.compartment_ocid
  name           = var.notification_topic_name

  description   = "Notification Topic"
  defined_tags  = lookup(var.tags, "defined_tags", {})
  freeform_tags = lookup(var.tags, "freeform_tags", {})

}

locals {
  topic        = var.create_topic ? oci_ons_notification_topic.this_topic[0].id : data.oci_ons_notification_topics.existing_topic.notification_topics[0].topic_id
  current_time = timestamp()
}

resource "oci_ons_subscription" "func_subscription" {
  compartment_id = var.compartment_ocid
  endpoint       = var.function_id
  protocol       = "ORACLE_FUNCTIONS"
  topic_id       = local.topic


  defined_tags  = lookup(var.tags, "defined_tags", {})
  freeform_tags = lookup(var.tags, "freeform_tags", {})
}

resource "oci_monitoring_alarm" "alarm" {
  for_each                     = var.alarm_def
  compartment_id               = var.compartment_ocid
  destinations                 = [local.topic]
  display_name                 = each.key
  is_enabled                   = each.value.enabled
  metric_compartment_id        = each.value.metric_compartment == null ? var.compartment_ocid : each.value.metric_compartment
  namespace                    = each.value.namespace
  query                        = each.value.query
  severity                     = each.value.severity
  message_format               = "RAW"
  repeat_notification_duration = each.value.repeat
  pending_duration             = each.value.trigger
  dynamic "suppression" {
    for_each = each.value.suppression != null ? each.value.suppression : {}
    content {
      time_suppress_from  = timeadd(local.current_time, split(",", suppression.value[0]))
      time_suppress_until = timeadd(local.current_time, split(",", suppression.value[1]))
    }
  }

}
