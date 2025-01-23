resource "oci_fleet_apps_management_fleet" "product_fleet" {
    count = var.fleet_type == "PRODUCT" ? 1 : 0
    compartment_id = var.tenancy_id
    fleet_type = "PRODUCT"

    lifecycle {
        ignore_changes = [defined_tags]
    }

    display_name = var.fleet_display_name
    is_target_auto_confirm = true
    notification_preferences {
        compartment_id = var.compartment_id
        topic_id = var.topic_id
        preferences {

            on_job_failure           = true
            on_topology_modification = true
            on_upcoming_schedule = true
            
        }
    }
    products = var.fleet_products
    resource_selection_type = "MANUAL" 

}


resource "oci_fleet_apps_management_fleet_resource" "product_fleet_resource" {
    for_each = var.fleet_type == "PRODUCT" ? toset(var.resources) : []
    compartment_id = var.compartment_id
    fleet_id = oci_fleet_apps_management_fleet.product_fleet[0].id
    resource_id = each.value
    tenancy_id = var.tenancy_id

}
