#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

set -euo pipefail

echo "Install Checkmk by Docker-compose"

read -p "Port (EX: 8080): " PORT
read -p "Site ID (EX: cmk): " SITE_ID
read -s -p "Password admin: " PASSWORD
echo
read -p "Email admin: " EMAIL

mkdir -p ~/checkmk
cd ~/checkmk

cat <<EOF > docker-compose.yml
version: '3'

services:
  checkmk:
    image: checkmk/check-mk-raw:2.2.0-latest
    container_name: checkmk
    restart: always
    ports:
      - "${PORT}:5000"
    volumes:
      - checkmk_data:/omd/sites
    environment:
      CMK_SITE_ID: ${SITE_ID}
      CMK_PASSWORD: ${PASSWORD}
      CMK_EMAIL: ${EMAIL}

volumes:
  checkmk_data:
EOF

chmod 644 docker-compose.yml
cat docker-compose.yml

echo "Start Checkmk container..."
docker-compose up -d

echo "Check information account admin: docker logs -f checkmk"
echo "Login with Username: ${SITE_ID}admin"
