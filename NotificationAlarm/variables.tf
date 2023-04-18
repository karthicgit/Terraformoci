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

variable "create_subscription" {
  default = true
  type = bool
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
    repeat             = optional(string,"PT5M")
    trigger            = optional(string,"PT5M")
    suppression        = optional(map(string))
  }))
}

variable "protocol" {
  type        = string
  description = "Protocol for Subscription"
}

variable "endpoint" {
  type        = string
  description = "Subscription endpoint"
}
