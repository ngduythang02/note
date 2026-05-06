#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi
# Variable
SERVER_PRIVATE_KEY=$(tr -d '\n' < /tools/wireguard/server_private.key)
NIC=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
read -p "Enter Subnet Private (Recomment: 192.168.1.0/24): " SUBNET_PRIVATE

#Install-wireguard-server
apt update -y
apt install wireguard -y
mkdir /tools/wireguard/
chown -R root:root /tools/wireguard
cd /tools/wireguard/
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee client_private.key | wg pubkey > client_public.key

tee /etc/wireguard/wg0.conf > /dev/null <<EOF
[Interface]
Address = 14.14.14.1/24
PrivateKey = ${SERVER_PRIVATE_KEY}
ListenPort = 51820

# NAT client ra Internet
PostUp = iptables -t nat -A POSTROUTING -o ${NIC} -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o ${NIC} -j MASQUERADE

[Peer]
PublicKey = <client_public_key_windowns>
AllowedIPs = 14.14.14.2/32
EOF
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-wireguard.conf
sysctl --system
wg-quick down wg0
wg-quick up wg0
systemctl enable wg-quick@wg0
iptables -A FORWARD -i wg0 -o ${NIC} -j ACCEPT
iptables -A FORWARD -i ${NIC} -o wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 14.14.14.0/24 -d ${SUBNET_PRIVATE} -j MASQUERADE
echo -e "\n\n\n"
wg show
echo -e "\n\n\n"
echo -e "INSTALL WireGuard SUCCESSFULL!"
echo -e "\n\n\n"
