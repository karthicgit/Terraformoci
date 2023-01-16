provider "oci" {}

data "oci_apm_apm_domains" "apm_domains" {
  compartment_id = var.compartment_ocid

  display_name = var.apm_domain
  state        = "ACTIVE"
}

locals {
  apmdomain_id              = data.oci_apm_apm_domains.apm_domains.apm_domains.0.id
  all_public_vantage_points = data.oci_apm_synthetics_public_vantage_points.all_public_vantage_points.public_vantage_point_collection[0]["items"].*.name
  scriptname                = trimsuffix(basename(var.script), ".side")
  date                      = formatdate("DD-MM-YYYY-hh-mm", timestamp())

}

resource "oci_apm_synthetics_script" "apmmonitor_script" {
  apm_domain_id = local.apmdomain_id
  content       = file(var.script)
  content_type  = "SIDE"
  display_name  = format("%s-%s", local.scriptname, tostring(local.date))

}

resource "oci_apm_synthetics_monitor" "apm_monitor" {

  apm_domain_id              = local.apmdomain_id
  display_name               = var.monitor_display_name
  monitor_type               = var.monitor_type
  repeat_interval_in_seconds = 300
  vantage_points             = contains(var.vantage_points, "all") ? local.all_public_vantage_points : var.vantage_points

  script_id = (var.monitor_type == "SCRIPTED_BROWSER" || var.monitor_type == "SCRIPTED_REST") ? oci_apm_synthetics_script.apmmonitor_script.id : null
  status    = var.status
  dynamic "script_parameters" {
    for_each = var.monitor_script_parameters != null ? var.monitor_script_parameters : {}
    content {
      param_name  = script_parameters.key
      param_value = script_parameters.value

    }

  }
}

data "oci_apm_synthetics_public_vantage_points" "all_public_vantage_points" {

  apm_domain_id = local.apmdomain_id

}
