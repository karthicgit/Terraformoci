
data "oci_management_agent_management_agents" "management_agents" {
  compartment_id      = var.compartment_id
  availability_status = "ACTIVE"
  state               = "ACTIVE"

}

data "oci_management_agent_management_agent_plugins" "management_agent_plugins" {
  compartment_id = var.compartment_id

  agent_id     = var.management_agent_id
  display_name = "Logging Analytics"
  state        = "ACTIVE"
}

locals {
  management_agents = data.oci_management_agent_management_agents.management_agents.management_agents.*.id
  logan_plugin_id   = data.oci_management_agent_management_agent_plugins.management_agent_plugins.management_agent_plugins.0.id
}


resource "oci_management_agent_management_agent" "test_management_agent" {
  for_each          = toset(local.management_agents)
  managed_agent_id  = each.value
  deploy_plugins_id = [local.logan_plugin_id]
}
