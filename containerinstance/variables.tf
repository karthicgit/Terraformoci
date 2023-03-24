variable "compartment_ocid" {
  type = string

}

variable "tenancy_ocid" {
  type = string

}

variable "ad_number" {
  type    = number
  default = 1

}

variable "subnet_id" {
  type = string

}

variable "CI_dg" {
  type    = string
  default = "CIsecret"

}

variable "secret_id" {
  type = string

}

variable "registry_endpoint" {
  default = "fra.ocir.io"
  type    = string
}

variable "fluentbit_image_url" {
  type = string

}

variable "createdgandpolicy" {
  type    = bool
  default = false
}

variable "createvault" {
  type    = bool
  default = false
}
variable "vault_display_name" {
  type        = string
  default     = "CIVault"
  description = "Vault display name"
}

variable "vault_type" {
  type        = string
  default     = "DEFAULT"
  description = "Vault type"
}

variable "freeform_tags" {
  type = object({
    vault = map(any),
    key   = map(any)
    }
  )
  default = {
    vault = {
      used_for = "container_instance"
    }
    key = {
      used_for = "container_instance"
    }
  }
  description = "Freeform tags"
}


variable "key_display_name" {
  type        = string
  default     = "master"
  description = "KMS key display names"
}

variable "key_protection_mode" {
  type        = string
  default     = "HSM"
  description = "Key protection mode SOFTWARE or HSM"
}
