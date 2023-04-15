variable "compartment_ocid" {
  description = "Compartment OCID"
  type = string
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type = string
}

variable "defined_tags" {
  default = {}
  description = "Tagging"
  type = map(any)

}

variable "freeform_tags" {
  default = {}
  description = "Freeform tags"
  type = map(any)
  
}

variable "task_type" {
  default = null
  type = string
  description = "Service Connector optional Task type"
  
}

variable "sch_source" {
  default = "logging"
  description = "Service connector source service"
  type = string
  validation {
    condition = contains(["logging","streaming"],var.sch_source)
    error_message = "Allowed values are logging and streaming."
  }
}

variable "service_connector_display_name" {
  default = "OCIServicetoLA"
  description = "Service Connector display name"
  type = string
}

variable "stream_cursor" {
  default = null
  type = string
  description = "Streaming Cursor"
}

variable "stream_id" {
  type = string
  description = "Stream OCID needed when sch_source is streaming"
  default = null
}

variable "la_log_source" {
  description = "OCI logging Analytics log source when source type is streaming"
  type = string
  default = "OCI Unified Schema Logs"
}

#Refer OCI logging module for allowed resource types
variable "service_logdef" {
  type = map(object({
    loggroup = string,
    service = string,
    resource = string,
    enable = optional(bool)

  }))
}

variable "policy_compartment_id" {
  type        = string
  description = "Compartment where the policy will be created.If empty it will get created in the compartment specified in compartment_ocid"
  default     = null

}

variable "dynamic_group_name" {
  type    = string
  default = "serviceconnector_dg"
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
  default = "serviceconnector_LA_policy"
}

variable "la_log_group_name" {
  type = string
  default = "OCIService_Loggroup"
}

variable "la_log_group_id" {
  type = string
  default = null

}

variable "create_lg" {
  type = bool
  default = true
}

variable "tasks_batch_size_in_kbs" {
  default = null
  type = string
  description = "Optional task batch size in Kbs for function"
}

variable "tasks_batch_time_in_sec" {
 default = null 
 type = string
 description = "Optional task batch time in sec for function"
}

variable "function_id" {
  type = string
  description = "Function OCID"
  default = ""
  
}

variable "tasks_condition" {
  default = null
  description = "Optional task condition for logRule"
  type = string
}
