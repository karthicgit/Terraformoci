variable "schedules" {
  type = map(object({
    action = string
    compartment_id = string
    recurrence_details = string
    recurrence_type = string

    defined_tags = optional(map(string))
    description = optional(string)
    display_name = string
    freeform_tags = optional(map(string))

    resource_filters = optional(list(object({
      attribute = optional(string)

      condition = optional(string)
      should_include_child_compartments = optional(bool)

      values = list(object({
        namespace = optional(string)
        tag_key = optional(string)
        value = optional(string)
      }))
    })))

    resources = optional(list(object({
      id = string
      metadata = optional(map(string))
    })))


    time_ends = string
    time_starts = string
  }))
}


