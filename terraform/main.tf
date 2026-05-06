resource "openstack_compute_instance_v2" "minecraft_node" {
  name            = "ubuntu_serv"
  image_name      = "noble-server-cloudimg-amd64" 
  flavor_name     = "m1.medium"
  key_pair        = var.key_pair
  security_groups = ["default", "minecraft_secgroup"]

  # Проверь, что setup_node.sh лежит в той же папке, что и main.tf
  # Или поправь путь на "../setup_node.sh", если он уровнем выше
  user_data = file("setup_node.sh")

  network {
    name = "external-network" # Уточни имя сети в твоем Киберпротекте!
  }
}