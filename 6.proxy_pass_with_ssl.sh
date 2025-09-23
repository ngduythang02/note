#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

apt update -y && apt install nginx -y

tee /etc/nginx/sites-available/proxy_pass.conf > /dev/null <<'EOF'
server {
    listen 80;
    server_name jenkins.thangnd.cloud;

    # redirect from HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name jenkins.thangnd.cloud;

    ssl_certificate /etc/letsencrypt/live/jenkins.thangnd.cloud/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/jenkins.thangnd.cloud/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/jenkins.thangnd.cloud/chain.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers off;
    client_max_body_size 100M;

    location / {
        proxy_pass http://192.168.1.102:8080;  # GitLab server B
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Support websocket
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

ln -sf /etc/nginx/sites-available/proxy_pass.conf /etc/nginx/sites-enabled/proxy_pass.conf
rm -rf /etc/nginx/sites-enabled/default

if nginx -t; then
    systemctl reload nginx
    systemctl enable nginx
    echo "Nginx reload successful!"
else
    echo "Nginx configuration error"
    exit 1
fi
