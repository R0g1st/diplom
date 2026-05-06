#!/bin/bash
# Обновление системы
apt-get update && apt-get upgrade -y

# Установка Docker
apt-get install -y docker.io docker-compose
systemctl enable --now docker

# Создание директории для данных
mkdir -p /opt/minecraft/data
chmod 777 /opt/minecraft/data

# Инструкция для «Киберпротект»: 
# Здесь можно добавить установку агента «Кибер Бэкап»
# wget [ссылка_на_агент] && chmod +x agent.sh && ./agent.sh