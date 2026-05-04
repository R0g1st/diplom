variable "proxmox_api_token" {
  sensitive = true
}

variable "proxmox_node" {
  default = "pve"     # ← обязательно проверь настоящее имя ноды!
}

variable "minecraft_replicas" {
  default = 2
}

variable "template_name" {
  default = "ubuntu-2404-template"   # ← замени на реальное имя шаблона
}