provider "openstack" {
  auth_url            = var.auth_url
  user_name           = var.user_name
  password            = var.password
  tenant_name         = var.project_name
  user_domain_name    = var.domain_name
  project_domain_name = var.domain_name
  
  region     = "RegionOne"
  insecure   = true
}

# Security Group (один на все сервера)
resource "openstack_networking_secgroup_v2" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Security group for Minecraft servers"
}

resource "openstack_networking_secgroup_rule_v2" "minecraft_port" {
  security_group_id = openstack_networking_secgroup_v2.minecraft_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 25565
  port_range_max    = 25565
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.minecraft_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
}

# ==================== MINECRAFT СЕРВЕРЫ ====================
resource "openstack_compute_instance_v2" "minecraft_node" {
  count = var.node_count

  name = "minecraft-node-${format("%02d", count.index + 1)}"   # minecraft-node-01, minecraft-node-02...

  # Используем Volume вместо ephemeral диска (рекомендуется)
  block_device {
    uuid                  = "335af725-4785-4217-945c-f85f528ecbfb"  # ID твоего образа
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 20
    delete_on_termination = true
  }

  flavor_name = "medium"

  user_data = file("${path.module}/setup_node.sh")

  network {
    name = "cloud-net"
  }

  security_groups = [openstack_networking_secgroup_v2.minecraft_sg.name]

  metadata = {
    environment = "production"
    role        = "minecraft"
    node        = count.index + 1
  }
}

# ==================== OUTPUT ====================
output "minecraft_servers" {
  value = {
    for instance in openstack_compute_instance_v2.minecraft_node :
    instance.name => instance.access_ip_v4
  }
  description = "IP-адреса всех Minecraft серверов"
}

output "minecraft_server_list" {
  value = [for instance in openstack_compute_instance_v2.minecraft_node : instance.access_ip_v4]
}