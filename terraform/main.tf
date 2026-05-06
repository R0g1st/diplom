provider "openstack" {
  auth_url            = var.auth_url
  user_name           = var.user_name
  password            = var.password
  tenant_name         = var.project_name
  user_domain_name    = var.domain_name
  project_domain_name = var.domain_name
  
  insecure            = true
}

# Security Group
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

# Основная ВМ
resource "openstack_compute_instance_v2" "minecraft_node" {
  name            = "minecraft-node-02"
  image_name      = "noble-server-cloudimg-amd64.img"  # ← проверь точное имя!
  flavor_name     = "medium"
  # key_pair        = var.key_pair
  #security_groups = [default]
  user_data = file("/setup_node.sh")

  block_device {
    uuid                  = "335af725-4785-4217-945c-f85f528ecbfb" # ID вашего образа
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 20 # Указываем реальный размер диска (в ГБ)
    delete_on_termination = true
  }

  network {
    name = "cloud-net"
  }
}

# Вывод IP
output "minecraft_server_ip" {
  value = openstack_compute_instance_v2.minecraft_node.access_ip_v4
}