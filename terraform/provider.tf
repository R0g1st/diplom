provider "proxmox" {
  endpoint = "https://192.168.13.132:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
}