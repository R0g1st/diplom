variable "auth_url" {}
variable "project_name" {}
variable "user_name" {}
variable "password" {}
variable "domain_name" {}

variable "node_count" {
  default = 2
}

variable "flavor_name" {
  default = "large"
}

variable "image_id" {
  default = "335af725-4785-4217-945c-f85f528ecbfb"
}

variable "network_name" {
  default = "cloud-net"
}

variable "floating_pool" {
  default = "public"
}
