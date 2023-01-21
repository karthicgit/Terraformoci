variable "management_type" {
  type        = string
  default     = "BASIC"
  description = "DB management type BASIC or ADVANCED"
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
}

variable "database_id" {
  type        = string
  description = "Database OCID"
}
variable "create_endpoint" {
  type        = bool
  default     = false
  description = "Whether to create private endpoint or not"
}
variable "private_endpoint_name" {
  type        = string
  default     = "dbmgmt_privateendpoint"
  description = "private endpoint name"
}

variable "enable_dbmanagement" {
  type        = bool
  default     = true
  description = "Whether to enable DB management or not"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id for private endpoint"
}
variable "is_cluster" {
  type        = bool
  default     = false
  description = "Private endpoint used for RAC or not"
}

variable "service_name" {
  type        = string
  description = "DB service name"
}

variable "private_end_point_id" {
  type        = string
  default     = null
  description = "Private Endpoint ID"
}

variable "vault_display_name" {
  type        = string
  default     = "DBVault"
  description = "Vault display name"
}

variable "vault_type" {
  type        = string
  default     = "DEFAULT"
  description = "Vault type"
}

variable "freeform_tags" {
  type = object({
    vault = map(any),
    key   = map(any),
    secret = map(any) }
  )
  default = {
    vault = {
      used_for = "db_mgmt"
    }
    key = {
      used_for = "db_mgmt"
    }
    secret = {}
  }
  description = "Freeform tags"
}

variable "key_display_name" {
  type        = string
  default     = "value"
  description = "KMS key display names"
}

variable "secret_metadata" {
  type = map(string)
  default = {
    "sqlcommand" = "sqlplus <user>/<password>@DBconnectionstring"
  }
  description = "Secret metadata"
}
variable "secret_name" {
  type        = string
  default     = "DBsecret"
  description = "Secret display name"
}
variable "secret_content" {
  type        = string
  sensitive   = true
  description = "Secret"
}

variable "key_protection_mode" {
  type        = string
  default     = "HSM"
  description = "Key protection mode SOFTWARE or HSM"
}
