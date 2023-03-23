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
