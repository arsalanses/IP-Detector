# Provider
variable "ApiKey" {
  type      = string
  sensitive = true
}

# Arvan_iaas_abrak
variable "abrak_name" {
  type    = string
  default = "terraform-abrak-example"
}

variable "region" {
  type    = string
  default = "ir-thr-c2" # Forogh Datacenter
}
