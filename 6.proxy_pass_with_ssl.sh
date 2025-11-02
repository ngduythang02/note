#!/bin/bash

# domain="jenkins.thangnd.cloud"
# ip="192.168.1.5"
# port="8080"

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

read -p "Enter DOMAIN (EX: gitlab.thangnd.cloud): " domain
read -p "Enter IP (EX: 192.168.1.5): " ip
read -p "Enter PORT (EX: 8080): " port
name_server="${domain%%.*}"

apt update -y && apt install nginx -y

tee /etc/nginx/sites-available/${domain}.conf > /dev/null <<EOF
server {
    listen 80;
    server_name ${domain};

    # redirect from HTTP to HTTPS
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name ${domain};

    ssl_certificate /etc/letsencrypt/live/${domain}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/${domain}/chain.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers off;
    client_max_body_size 100M;

    location / {
        proxy_pass http://${ip}:${port};  # ${name_server} server
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Support websocket
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

ln -sf /etc/nginx/sites-available/${domain}.conf /etc/nginx/sites-enabled/${domain}.conf
rm -rf /etc/nginx/sites-enabled/default

if nginx -t; then
    systemctl reload nginx
    systemctl enable nginx
    echo "✅ Nginx reload successful!"
else
    echo "❌ Nginx configuration error"
    exit 1
fi
