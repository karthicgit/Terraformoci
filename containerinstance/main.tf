resource "oci_container_instances_container_instance" "container_instance" {
  availability_domain = data.oci_identity_availability_domain.oci_ad.name
  compartment_id      = var.compartment_ocid
  containers {

    image_url    = "nginx"
    display_name = "nginx"

    is_resource_principal_disabled = "false"
    resource_config {
      memory_limit_in_gbs = "1.0"
      vcpus_limit         = "1.0"
    }
    volume_mounts {
      mount_path  = "/var/log/nginx"
      volume_name = "nginxlogs"
    }

  }
  containers {
    image_url    = var.fluentbit_image_url
    display_name = "fluent-bitnginxlogs"

    is_resource_principal_disabled = "false"
    resource_config {
      memory_limit_in_gbs = "1.0"
      vcpus_limit         = "1.0"
    }
    volume_mounts {
      mount_path   = "/var/log/nginx"
      volume_name  = "nginxlogs"
      is_read_only = "true"

    }

  }
  shape = "CI.Standard.E4.Flex"
  shape_config {
    memory_in_gbs = "2"
    ocpus         = "1"
  }
  vnics {
    subnet_id = var.subnet_id

    #Optional

    # display_name = "displayName"
    # freeform_tags = {
    #   "freeformTag" = "freeformTags"
    # }
    # hostname_label         = "hostnamelabel"
    # is_public_ip_assigned  = "true"
    # nsg_ids                = []
    # private_ip             = "10.0.0.7"
    # skip_source_dest_check = "false"
  }

  container_restart_policy = "ON_FAILURE"
  display_name             = "CI"

  dns_config {

    # #Optional
    # nameservers = [
    # "8.8.8.8"]
    # options = [
    # "options"]
    # searches = [
    # "search domain"]
  }

  graceful_shutdown_timeout_in_seconds = "10"
  image_pull_secrets {
    registry_endpoint = var.registry_endpoint
    secret_type       = "VAULT"
    secret_id         = var.secret_id
  }

  state = "ACTIVE"
  volumes {
    name          = "nginxlogs"
    volume_type   = "EMPTYDIR"
    backing_store = "EPHEMERAL_STORAGE"

  }

}

output "private_ip" {
  value = oci_container_instances_container_instance.container_instance.vnics.0.private_ip
}

resource "oci_identity_dynamic_group" "ci_dynamic_group" {
  count = var.createdgandpolicy ? 1 : 0

  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for Container instance to read secrets"
  matching_rule  = local.cisecret_dg
  name           = var.CI_dg

}
resource "oci_identity_policy" "ci_policy" {
  count = var.createdgandpolicy ? 1 : 0

  compartment_id = var.compartment_ocid
  description    = "Policy for secret access for container instance"
  name           = "CIsecret"
  statements     = local.ci_policy

}

locals {
  cisecret_dg = "ALL {resource.type='computecontainerinstance', resource.compartment.id='${var.compartment_ocid}'}"
  ci_policy   = ["ALLOW DYNAMIC-GROUP ${var.CI_dg} TO read secret-bundles in COMPARTMENT ID ${var.compartment_ocid}"]

}

data "oci_identity_availability_domain" "oci_ad" {

  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_number
}

#Vault creation
resource "oci_kms_vault" "kms_vault" {
  count          = var.createvault ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = var.vault_display_name
  vault_type     = var.vault_type

  freeform_tags = lookup(var.freeform_tags, "vault", {})
}

resource "oci_kms_key" "kms_key" {
  count          = var.createvault ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = var.key_display_name
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = oci_kms_vault.kms_vault[0].management_endpoint

  freeform_tags   = lookup(var.freeform_tags, "key", {})
  protection_mode = var.key_protection_mode
}

