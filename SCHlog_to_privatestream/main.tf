provider "oci" {
  
}

terraform {
  required_providers {
    oci = {
      version = ">= 6.34.0"
      source = "oracle/oci"
    }
  }
}

#Stream Pool
resource "oci_streaming_stream_pool" "test_stream_pool" {
  compartment_id = var.compartment_id
  name           = var.streampool_name

  private_endpoint_settings {
    nsg_ids             = [oci_core_network_security_group.test_nsg.id]
    subnet_id           = var.subnet_id
  }
}

variable "streampool_name" {
    type = string
}
variable "subnet_id" {
    type = string
    description = "Subnet id"
}

#OCI Streaming
resource "oci_streaming_stream" "test_stream" {
    name = "privstream"
    partitions = var.stream_partitions

    defined_tags = var.stream_defined_tags
    freeform_tags = var.stream_freeform_tags
    retention_in_hours = var.stream_retention_in_hours
    stream_pool_id = oci_streaming_stream_pool.test_stream_pool.id
}

variable "stream_partitions" {}
variable "compartment_id" {}
variable "stream_retention_in_hours" {}
variable "stream_defined_tags" {}
variable "stream_freeform_tags" {}


resource "oci_core_network_security_group" "test_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
}

variable "vcn_id" {}

#Connector HUB for Audit log to streaming
resource "oci_sch_service_connector" "test_service_connector" {
    compartment_id = var.compartment_id
    display_name = "Log_to_PrivateStream"
    source {
        kind = "logging"
        log_sources {
            compartment_id = var.compartment_id
            log_group_id = "_Audit"
        }
    }
    target {
        kind = "streaming"
        stream_id = oci_streaming_stream.test_stream.id
    }
    description = "logging to private streaming"
}


locals {
    rce_traffic =  "${oci_sch_service_connector.test_service_connector.target[0].private_endpoint_metadata[0].rce_traffic_ip_address}/32"
    stream_private_ip = "${oci_streaming_stream_pool.test_stream_pool.private_endpoint_settings[0].private_endpoint_ip}/32"
}


#NSG rule
resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.test_nsg.id
  direction                 = "INGRESS"
  source              = local.rce_traffic
  protocol                  = "6"
}

resource "oci_core_network_security_group_security_rule" "test_network_security_group_security_rule_3" {
  network_security_group_id = oci_core_network_security_group.test_nsg.id

  direction   = "EGRESS"
  protocol    = "6"
  destination = local.stream_private_ip
}
