variable "monitor_display_name" {
  type        = string
  default     = "scriptedmonitor"
  description = "Monitor display name"
}

variable "monitor_type" {
  type        = string
  default     = "SCRIPTED_BROWSER"
  description = "Monitor type"
}

variable "apm_domain" {
  type        = string
  description = "APM Domain"
}

variable "script" {
  type        = string
  description = "absolute script file path"

}

variable "status" {
  type        = string
  default     = "ENABLED"
  description = "Monitor status ENABLED or DISABLED"
}

variable "vantage_points" {
  type        = list(string)
  description = "Vantage points. Oracle Public vantage points are in the format OraclePublic-<region>.ex: OraclePublic-eu-frankfurt-1"
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
}

variable "monitor_script_parameters" {
  type        = map(string)
  description = "Monitor script parameters"
}
