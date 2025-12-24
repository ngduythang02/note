#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

apt update -y && apt install samba -y
samba --version

mkdir -p /srv/samba/public
mkdir -p /srv/samba/private
chmod -R 777 /srv/samba/public
chown -R nobody:nogroup /srv/samba/public
chmod -R 755 /srv/samba/private
chown -R root:root /srv/samba/private

echo >> /etc/samba/smb.conf
tee -a /etc/samba/smb.conf <<'EOF'
[public]
   path = /srv/samba/public
   browsable = yes
   writable = yes
   guest ok = yes
   read only = no

[private]
   path = /srv/samba/private
   browsable = yes
   writable = yes
   guest ok = no
   read only = no
   valid users = user1 user2 user3

EOF

systemctl restart smbd
systemctl enable smbd
systemctl status smbd
