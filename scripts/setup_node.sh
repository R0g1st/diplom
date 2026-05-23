#!/bin/bash

echo "=== Ubuntu setup started ==="

# root пароль
echo "root:toor" | chpasswd

# разрешаем root ssh
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh || systemctl restart sshd

# обновляем пакеты
apt update -y

# ставим docker
apt install -y docker.io docker-compose wget

systemctl enable docker
systemctl start docker

# создаем папки
mkdir -p /opt/minecraft
mkdir -p /opt/minecraft/data

# скачиваем Minecraft 1.21.4 server.jar
wget -O /opt/minecraft/data/server.jar \
https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar

# создаем docker-compose.yml
cat > /opt/minecraft/docker-compose.yml <<EOF
version: "3.8"

services:
  mc-server:
    image: itzg/minecraft-server:latest
    container_name: mc-server
    restart: unless-stopped
    ports:
      - "25565:25565"
    volumes:
      - /opt/minecraft/data:/data
    environment:
      EULA: "TRUE"
      ONLINE_MODE: "false"
      TYPE: "CUSTOM"
      CUSTOM_SERVER: "/data/server.jar"
      MEMORY: "4G"
      MOTD: "Minecraft 1.21.4 Cluster"
      SKIP_DOWNLOAD_DEFAULTS: "true"
      OVERRIDE_SERVER_PROPERTIES: "true"
    stdin_open: true
    tty: true
EOF

# запуск контейнера
cd /opt/minecraft
docker-compose up -d

echo "=========================="
echo "Minecraft started"
echo "root / toor"
echo "=========================="