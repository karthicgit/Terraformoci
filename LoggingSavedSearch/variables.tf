variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}

variable "kind" {
  description = "scheduled task kind"
  type        = string
  default     = "STANDARD"
}

variable "task_type" {
  description = "Type of scheduled task"
  type        = string
  default     = "SAVED_SEARCH"
  validation {
    condition     = contains(["SAVED_SEARCH", "PURGE"], var.task_type)
    error_message = "Allowed values are SAVED_SEARCH and PURGE."
  }
}

variable "tags" {
  description = "Tags"
  type        = map(any)
  default = {
    defined_tags  = {}
    freeform_tags = {}
  }
}

variable "display_name" {
  description = "Saved search display name"
  type        = string
  default     = "tf_rule_1"
}

variable "metric_namespace" {
  description = "Metric Namespace"
  type        = string
  default     = "log_test"
}

variable "metric_resource_group" {
  description = "Metric Resource group"
  type        = string
  default     = null
}


variable "recurring_interval" {
  description = "Recurring Interval"
  type        = string
  default     = "PT5M"
}

variable "repeat_count" {
  description = "Repeat Count"
  type        = string
  default     = "3"
}

variable "schedules_time_zone" {
  description = "Schedule Timezone"
  type        = string
  default     = "UTC"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID"

}

variable "schedule_type" {
  type    = string
  default = "FIXED_FREQUENCY"
  validation {
    condition     = contains(["CRON", "FIXED_FREQUENCY"], var.schedule_type)
    error_message = "Allowed values are CRON and FIXED_FREQUENCY.CRON is used for purge task type"

  }
}

variable "expression" {
  type        = string
  description = "CRON expression for purge"
  default     = null
}

variable "time_zone" {
  type    = string
  default = "UTC"
}

variable "policy_compartment_id" {
  type        = string
  description = "Compartment where the policy will be created.If empty it will get created in the compartment specified in compartment_ocid"
  default     = null

}

variable "dynamic_group_name" {
  type    = string
  default = "savedsearch_dg"
}

variable "create_dg" {
  type    = bool
  default = false
}

variable "create_policy" {
  type    = bool
  default = false
}

variable "policy_name" {
  type    = string
  default = "savedsearch_policy"
}

variable "saved_search_id" {
  type = string
}

variable "metric_name" {
  type    = string
  default = "log_savedsearch"
}

variable "purge_query_string" {
  type    = string
  default = null
}

variable "purge_compartment_id_in_subtree" {
  type    = bool
  default = false
}

variable "purge_data_type" {
  type    = string
  default = "LOG"
  validation {
    condition     = contains(["LOG", "LOOKUP"], var.purge_data_type)
    error_message = "Allowed values are LOG and LOOKUP"
  }
}

variable "purge_duration" {
  type        = string
  default     = "-P1D"
  description = "Purge Duration.It should be in negative dates"
}
