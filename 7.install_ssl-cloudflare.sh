#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

sudo apt update -y
sudo apt install python3-certbot-dns-cloudflare -y
sudo mkdir -p /etc/letsencrypt

tee /etc/letsencrypt/cloudflare.ini > /dev/null <<'EOF'
#dns_cloudflare_email = nichphu2k2@gmail.com
#dns_cloudflare_api_key = 49c99dac39e696e804db5b30367b5214a5da9
dns_cloudflare_api_token = 1QCP_qCJObTfU-mJHJfM2VbwZrDVorRsTkMC8G6C
EOF

sudo chmod 600 /etc/letsencrypt/cloudflare.ini
echo "nichphu2k2@gmail.com"
echo "A"
echo "N"

read -p "Enter domain (EX: gitlab.thangnd.cloud): " DOMAIN
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60 -d "$DOMAIN"
