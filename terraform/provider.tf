terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.1.0"
    }
  }
}

provider "openstack" {
  auth_url    = var.auth_url
  tenant_name = var.project_name
  user_name   = var.user_name
  password    = var.password
  
  # Обязательно для Киберпротекта
  user_domain_name    = var.domain_name
  project_domain_name = var.domain_name
  
  region        = "RegionOne"
  endpoint_type = "public"
  insecure      = true
}