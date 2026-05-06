#!/bin/bash
# =============================================
# Простая и надёжная настройка Ubuntu
# =============================================

# Установка пароля для ubuntu
echo "ubuntu:admin" | chpasswd

# Создаём пользователя admin (дублируем)
useradd -m -s /bin/bash admin 2>/dev/null || true
echo "admin:admin" | chpasswd
usermod -aG sudo admin

# Включаем авторизацию по паролю
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Перезапускаем SSH
systemctl restart ssh || systemctl restart sshd

# Установка Docker и Minecraft
apt-get update -y
apt-get install -y docker.io docker-compose-v2
systemctl enable --now docker

usermod -aG docker ubuntu
usermod -aG docker admin

mkdir -p /opt/minecraft/data
chmod 777 /opt/minecraft/data

cat > /opt/minecraft/docker-compose.yml << 'EOL'
version: '3.8'
services:
  mc:
    image: itzg/minecraft-server:latest
    container_name: minecraft-server
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "1.21.5"
      MEMORY: "3G"
      MOTD: "§aCyberMinecraft §7| §fubuntu/admin"
    volumes:
      - /opt/minecraft/data:/data
    restart: always
EOL

cd /opt/minecraft && docker compose up -d

echo "=================================================="
echo "✅ Сервер настроен успешно!"
echo "Логин: ubuntu"
echo "Пароль: admin"
echo "Логин: admin"
echo "Пароль: admin"
echo "Minecraft порт: 25565"
echo "=================================================="