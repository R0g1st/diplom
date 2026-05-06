resource "openstack_compute_instance_v2" "minecraft_node" {
  name            = "ubuntu_serv"
  image_name      = "noble-server-cloudimg-amd64" # Уточни точное имя образа в твоем облаке
  flavor_name     = "m1.medium"    # Минимум 4GB RAM для Minecraft
  key_pair        = var.key_pair
  security_groups = ["default", "minecraft_secgroup"]

  user_data = file("${path.module}/../scripts/setup_node.sh")
}