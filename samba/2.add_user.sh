#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

read -p "Enter username: " user
adduser "$user"
smbpasswd -a "$user"
mkdir -p "/srv/samba/private/$user"
chown -R "$user:$user" "/srv/samba/private/$user"
chmod -R 700 "/srv/samba/private/$user"
sed -i "/^ *valid users *=/ s/\$/ $user/" /etc/samba/smb.conf
systemctl restart smbd

echo "User $user has been added successfully"
