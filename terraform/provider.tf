terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.1.0"
    }
  }
}

provider "openstack" {
  auth_url    = https://10.10.10.15:5000/v3
  tenant_name = Project03
  user_name   = user03
  password    = P@ssw0rd
  domain_name = Region2026
  insecure    = true 
}