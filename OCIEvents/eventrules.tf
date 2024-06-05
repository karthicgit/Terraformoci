resource "oci_events_rule" "event_rules" {
  for_each = var.rule_configs

  actions {
    dynamic "actions" {
      for_each = each.value.actions.actions
      content {
        action_type = actions.value.action_type
        is_enabled  = actions.value.is_enabled
        description = actions.value.description
        topic_id    = actions.value.topic_id
        stream_id   = actions.value.stream_id
      }
    }
  }
  compartment_id = var.compartment_id
  condition      = each.value.condition
  display_name   = each.value.display_name
  is_enabled     = each.value.is_enabled

  description = each.value.description
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the events rules will be created"
}

variable "rule_configs" {
  type = map(object({
    actions = object({
      actions = list(object({
        action_type = string
        is_enabled  = bool
        description = optional(string)
        function_id = optional(string)
        stream_id   = optional(string)
        topic_id    = optional(string)
      }))
    })
    condition    = string
    display_name = string
    is_enabled   = bool
    description  = optional(string)
  }))
  description = "Map of rule configurations. Each key should be a unique identifier for the rule."
}

provider "oci" {}
