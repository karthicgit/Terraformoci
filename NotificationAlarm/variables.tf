variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}

variable "notification_topic_name" {
  description = "Notification Topic display name"
  type        = string
}

variable "create_topic" {
  default = true
  type    = bool
}

variable "tags" {
  type = map(any)
  default = {
    "defined_tags"  = {}
    "freeform_tags" = {}
  }
}


variable "alarm_def" {
  type = map(object({
    severity           = string
    query              = string
    enabled            = bool
    namespace          = string
    metric_compartment = optional(string)
    repeat             = optional(string)
    trigger            = optional(string,"PT5M")
    suppression        = optional(map(string))
  }))
}

variable "function_id" {
  type        = string
  description = "Existing Function OCID"
}
