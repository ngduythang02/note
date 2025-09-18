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

    location / {
        #proxy_pass http://jenkins.thangnd.cloud:8080;
        proxy_pass http://192.168.14.110:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/proxy_pass.conf /etc/nginx/sites-enabled/proxy_pass.conf

if nginx -t; then
    systemctl reload nginx
    systemctl enable nginx
    echo "Nginx reload successful!"
else
    echo "Nginx configuration error"
    exit 1
fi
