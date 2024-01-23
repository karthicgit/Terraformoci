#To run in OCI Cloud Shell
provider "oci" {}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

data "oci_kms_vault" "oci_vault" {
    count = var.create_vault ? 0 : 1
    vault_id = var.vault_id
}

locals {
   vault_end_point = try(data.oci_kms_vault.oci_vault[0].management_endpoint,null)
}

resource "oci_identity_policy" "test_policy" {
  count          = var.create_policy ? 1 : 0
  compartment_id = var.compartment_ocid
  description    = "Policy to allow DB management service to read secret-family for mentioned compartment"
  name           = var.policy_name
  statements     = ["Allow service dpd to read secret-family in compartment id ${var.compartment_ocid}"]
}

resource "oci_database_cloud_database_management" "db_mgmt" {
  database_id          = var.database_id
  management_type      = var.management_type
  private_end_point_id = coalesce(var.private_end_point_id, try(oci_database_management_db_management_private_endpoint.db_management_private_endpoint[0].id,null))
  service_name         = var.service_name
  #Username is hardcoded to DBSNMP as default. change it if another username is used
  credentialdetails {
    user_name          = "DBSNMP"
    password_secret_id = oci_vault_secret.kms_secret.id
  }
  enable_management = var.enable_dbmanagement
  depends_on = [
    oci_vault_secret.kms_secret
  ]
}

resource "oci_database_management_db_management_private_endpoint" "db_management_private_endpoint" {
  count = var.create_private_endpoint ? 1 : 0

  compartment_id = var.compartment_ocid
  name           = var.private_endpoint_name
  subnet_id      = var.subnet_id

  description = "Private Endpoint for DB management"
  is_cluster  = var.is_cluster
}

resource "oci_kms_vault" "kms_vault" {
  count = var.create_vault ? 1 : 0

  compartment_id = var.compartment_ocid
  display_name   = var.vault_display_name
  vault_type     = var.vault_type

  freeform_tags = lookup(var.freeform_tags, "vault", {})
}

resource "oci_kms_key" "kms_key" {

  compartment_id = var.compartment_ocid
  display_name   = var.key_display_name
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = try(oci_kms_vault.kms_vault[0].management_endpoint,local.vault_end_point)

  freeform_tags   = lookup(var.freeform_tags, "key", {})
  protection_mode = var.key_protection_mode
}

resource "oci_vault_secret" "kms_secret" {
  compartment_id = var.compartment_ocid
  secret_content {
    content_type = "BASE64"
    content      = var.secret_content
  }
  secret_name = var.secret_name
  vault_id    = coalesce(var.vault_id,try(oci_kms_vault.kms_vault[0].id,null))

  description   = "DB management secret"
  freeform_tags = lookup(var.freeform_tags, "secret", {})
  key_id        = oci_kms_key.kms_key.id
  metadata      = var.secret_metadata

}

#Variables
variable "management_type" {
  type        = string
  default     = "ADVANCED"
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

variable "create_private_endpoint" {
  type        = bool
  default     = false
  description = "Whether to create private endpoint or not."
}

variable "create_vault" {
    type = bool
    description = "Whether to create Vault or not"
    default = true
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

variable "vault_id" {
    type = string
    description = "Vault ID"
}

variable "key_display_name" {
  type        = string
  default     = "MasterDBmgmt"
  description = "KMS key display names"
}

variable "policy_name" {
  type        = string
  description = "DB management policy name"
  default     = "DBmgmt"
}

variable "create_policy" {
  type        = bool
  default     = false
  description = "Create DB management policy or not"
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
