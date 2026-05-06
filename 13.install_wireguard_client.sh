#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi
# Variable
SERVER_PUBLIC_KEY=$(tr -d '\n' < /tools/wireguard/server_public.key)
IP_PUBLIC=$(curl -s https://api.ipify.org || curl -s https://ifconfig.me)
read -p "Name's client (Recomment: DNG-TECHNICAL): " name
read -p "Input windows client public key (Recomment: aNw9opON6ARPD0wN3tzcgLxO+OiV9Ybb0l4hE8CKsmY=): " CLIENT_PUBLIC_KEY
read -p "Enter Subnet Private (Recomment: 192.168.1.0/24): " SUBNET_PRIVATE
echo ""
echo ""
echo ""
echo "IP VPN already used:"
grep -oE '14\.14\.14\.[0-9]+' /etc/wireguard/wg0.conf
echo ""
echo ""
echo ""
read -p "IP VPN new (Recomment: 14.14.14.x): " IP_VPN_NEW

#Install-wireguard-client
tee -a /etc/wireguard/wg0.conf > /dev/null <<EOF
# ${name}
[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = ${IP_VPN_NEW}/32
EOF

wg-quick down wg0
wg-quick up wg0

echo "********************"
echo ""
echo ""
echo ""
wg show
echo ""
echo ""
echo ""
echo "********************"
echo ""
echo ""
echo ""
cat > /tools/wireguard/client.conf <<EOF
[Interface]
PrivateKey = <private_key_windows>
Address = ${IP_VPN_NEW}/24
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
AllowedIPs = 14.14.14.0/24, ${SUBNET_PRIVATE}
Endpoint = ${IP_PUBLIC}:51820
PersistentKeepalive = 25
EOF
echo "Paste the following content into the Windows client WireGuard."
cat /tools/wireguard/client.conf
echo ""
echo ""
echo ""
echo "********************"
echo ""
echo ""
echo ""
echo "https://drive.google.com/file/d/1wZOKzRix4edICuLQqaynDc5KD1G2L40M/view?usp=sharing"
echo "Access the link to download the Windows client WireGuard."
echo ""
echo ""
echo ""
