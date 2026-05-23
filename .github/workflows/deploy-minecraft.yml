#!/bin/bash

apt update -y
apt install -y docker.io docker-compose wget

systemctl enable docker
systemctl start docker

mkdir -p /opt/minecraft/data

wget -O /opt/minecraft/data/server.jar \
https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar

cat > /opt/minecraft/docker-compose.yml <<EOF
version: "3.8"

services:
  mc-server:
    image: itzg/minecraft-server
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
      MOTD: "Minecraft Cluster 1.21.4"
      SKIP_DOWNLOAD_DEFAULTS: "true"
    stdin_open: true
    tty: true
EOF

cd /opt/minecraft
docker-compose up -d
