resource "null_resource" "nodes" {
  count = 3

  triggers = {
    # ВПИШИ СВОИ IP НИЖЕ
    node_ip = ["192.168.1.2", "192.168.2.2", "192.168.3.2"][count.index]
  }

  provisioner "local-exec" {
    # Запуск настройки через Ansible
    command = "ansible-playbook -i ${self.triggers.node_ip}, -u vboxuser playbook.yml"
  }
}
