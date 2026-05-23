#!/bin/bash

echo "root:toor" | chpasswd

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

apt update -y
apt install -y docker.io docker-compose

systemctl enable docker
systemctl start docker

mkdir -p /opt/minecraft
cd /opt/minecraft

cat > docker-compose.yml <<EOF
version: "3.8"

services:
  minecraft:
    image: itzg/minecraft-server:latest
    container_name: minecraft
    restart: always
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "1.21.5"
      MEMORY: "4G"
      MOTD: "Diplom Minecraft Cluster"
    volumes:
      - ./data:/data
EOF

docker-compose up -d
