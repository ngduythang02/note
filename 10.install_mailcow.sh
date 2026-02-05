#!/bin/bash

if [ "$(whoami)" = "root" ]; then
    echo "You need to run this script with USER NORMAL"
    exit 1
fi

sudo apt update
sudo apt install -y jq curl git ca-certificates gnupg lsb-release
cd
git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo apt install -y jq curl git ca-certificates gnupg lsb-release
./generate_config.sh

read -rp "Start 'docker compose pull'? (Y/n): " answer
case "$answer" in
  [Yy]|"")
    echo "→ Running docker compose pull..."
    docker compose pull
    ;;
  [Nn])
    echo "→ The script has stopped as requested."
    exit 0
    ;;
  *)
    echo "→ Invalid selection. Stop script."
    exit 1
    ;;
esac

read -rp "Start 'docker compose pull'? (Y/n): " answer
case "$answer" in
  [Yy]|"")
    echo "→ Running docker compose pull..."
    docker compose up -d
    ;;
  [Nn])
    echo "→ The script has stopped as requested."
    exit 0
    ;;
  *)
    echo "→ Invalid selection. Stop script."
    exit 1
    ;;
esac
echo ""
echo ""
echo ""
echo "Access https://mail.thangnd.cloud"
echo "Login admin: (admin/moohoo)"
