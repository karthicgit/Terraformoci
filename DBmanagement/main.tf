# data "oci_database_database" "oci_database" {
#   database_id = var.database_id
# }

resource "oci_database_cloud_database_management" "db_mgmt" {
  database_id          = var.database_id
  management_type      = var.management_type
  private_end_point_id = coalesce(var.private_end_point_id, oci_database_management_db_management_private_endpoint.db_management_private_endpoint[0].id)
  service_name         = var.service_name #data.oci_database_database.oci_database.db_unique_name
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
  count = var.create_endpoint ? 1 : 0

  compartment_id = var.compartment_ocid
  name           = var.private_endpoint_name
  subnet_id      = var.subnet_id

  description = "Private Endpoint for DB management"
  is_cluster  = var.is_cluster
}

resource "oci_kms_vault" "kms_vault" {
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
  management_endpoint = oci_kms_vault.kms_vault.management_endpoint

  freeform_tags   = lookup(var.freeform_tags, "key", {})
  protection_mode = var.key_protection_mode
}

resource "oci_vault_secret" "kms_secret" {
  compartment_id = var.compartment_ocid
  secret_content {
    content_type = "BASE64"

    content = coalesce(var.secret_content, random_password.password.result)
  }
  secret_name = var.secret_name
  vault_id    = oci_kms_vault.kms_vault.id

  description   = "DB management secret"
  freeform_tags = lookup(var.freeform_tags, "secret", {})
  key_id        = oci_kms_key.kms_key.id
  metadata      = var.secret_metadata

}

resource "random_password" "password" {
  length           = 16
  special          = true
  min_lower        = 2
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  override_special = "#"
}
