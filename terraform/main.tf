# ================== VELOCITY PROXY ==================
resource "proxmox_virtual_environment_vm" "velocity" {
  node_name = var.proxmox_node
  vm_id     = 800
  name      = "mc-velocity"

  cpu { cores = 4 }
  memory { dedicated = 4096 }

  disk {
    datastore_id = "local-lvm"   # ← поменяй если другой
    size         = 32
  }

  network_interface { name = "vmbr0" }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.100/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      username = "minecraft"
      password = "Minecraft2026!"
    }
  }
}

# ================== MINECRAFT BACKENDS ==================
resource "proxmox_virtual_environment_vm" "minecraft" {
  count     = var.minecraft_replicas
  node_name = var.proxmox_node
  vm_id     = 810 + count.index
  name      = "mc-backend-${count.index + 1}"

  cpu { cores = 6 }
  memory { dedicated = 8192 }

  disk {
    datastore_id = "local-lvm"
    size         = 64
  }

  network_interface { name = "vmbr0" }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.${110 + count.index}/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      username = "minecraft"
      password = "Minecraft2026!"
    }
  }
}