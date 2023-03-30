variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"

}

variable "is_retired" {
  type    = bool
  default = false

}

variable "tag_namespace_name" {
  default = "Project-Cost"
  type    = string

}

variable "tag_values" {
  type    = list(string)
  default = ["ProjectA"]

}
variable "tag_name" {
  type    = string
  default = "Projectname"

}
variable "is_cost_tracking" {
  default = true
  type    = bool

}
variable "tags" {
  type        = map(any)
  description = "Tags to be applied for Tag namespace"
  default = {
    "defined_tags"  = {},
    "freeform_tags" = {}

  }
}
