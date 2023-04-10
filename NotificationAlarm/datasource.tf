data "oci_ons_notification_topics" "existing_topic" {

  compartment_id = var.compartment_ocid

  name  = var.notification_topic_name
  state = "ACTIVE"
}
