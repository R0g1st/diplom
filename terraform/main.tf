provider "openstack" {
  auth_url            = var.auth_url
  user_name           = var.user_name
  password            = var.password
  tenant_name         = var.project_name
  user_domain_name    = var.domain_name
  project_domain_name = var.domain_name
  region              = "RegionOne"
  insecure            = true
}

import {
  to = openstack_networking_secgroup_rule_v2.minecraft
  id = "87bfd51f-2263-49c8-a300-71cde71aab6a"
}


########################
# Security Group
########################

resource "openstack_networking_secgroup_v2" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Managed by Terraform"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.minecraft_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}


resource "openstack_networking_secgroup_rule_v2" "minecraft" {
  security_group_id = openstack_networking_secgroup_v2.minecraft_sg.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 25565
  port_range_max    = 25565
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}

#resource "openstack_networking_secgroup_rule_v2" "egress_ipv4" {
 # security_group_id = openstack_networking_secgroup_v2.minecraft_sg.id
  #direction         = "egress"
  #ethertype         = "IPv4"
  #remote_ip_prefix  = "0.0.0.0/0"
#}

########################
# Instances
########################

resource "openstack_compute_instance_v2" "minecraft_node" {
  count       = var.node_count
  name        = "minecraft-node-${count.index + 1}"
  flavor_name = var.flavor_name

  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  user_data = file("../scripts/setup_node.sh")

  network {
    name = var.network_name
  }

  security_groups = [
    openstack_networking_secgroup_v2.minecraft_sg.name
  ]
}

########################
# Floating IP
########################

resource "openstack_networking_floatingip_v2" "fip" {
  count = var.node_count
  pool  = var.floating_pool
}

resource "openstack_networking_floatingip_associate_v2" "assoc" {
  count       = var.node_count
  floating_ip = openstack_networking_floatingip_v2.fip[count.index].address
  port_id     = openstack_compute_instance_v2.minecraft_node[count.index].network[0].port
}

#resource "openstack_compute_floatingip_associate_v2" "assoc" {
#  count       = var.node_count
#  floating_ip = openstack_networking_floatingip_v2.fip[count.index].address
#  instance_id = openstack_compute_instance_v2.minecraft_node[count.index].id
#}

output "minecraft_ips" {
  value = openstack_networking_floatingip_v2.fip[*].address
}
