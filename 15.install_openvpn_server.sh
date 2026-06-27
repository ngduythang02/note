#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi
###########
rm -rf /tools/openvpn/*
rm -rf /etc/openvpn/server/*

# Variable
NIC=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
# read -p "Enter Subnet Private (Recomment: 192.168.1.0/24): " SUBNET_PRIVATE

#Install-openvpn-server
apt update -y
apt install openvpn easy-rsa -y
mkdir -p /tools/openvpn/
chown -R root:root /tools/openvpn
make-cadir /tools/openvpn/openvpn-ca
cd /tools/openvpn/openvpn-ca

export EASYRSA_BATCH=1
./easyrsa init-pki
EASYRSA_REQ_CN="MyVPN-CA" \
./easyrsa build-ca nopass
EASYRSA_REQ_CN="server" \
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-dh
openvpn --genkey secret ta.key

mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/ccd
cp /tools/openvpn/openvpn-ca/pki/ca.crt /etc/openvpn/server/
cp /tools/openvpn/openvpn-ca/pki/private/server.key /etc/openvpn/server/
cp /tools/openvpn/openvpn-ca/pki/issued/server.crt /etc/openvpn/server/
cp /tools/openvpn/openvpn-ca/pki/dh.pem /etc/openvpn/server/
cp /tools/openvpn/openvpn-ca/ta.key /etc/openvpn/server/

tee /etc/openvpn/server/server.conf > /dev/null <<EOF
port 1194
proto udp
dev tun

ca ca.crt
cert server.crt
key server.key
dh dh.pem

client-config-dir /etc/openvpn/ccd
server 14.14.14.0 255.255.255.0
topology subnet

# Access internet by VPN
push "redirect-gateway def1 bypass-dhcp"

# Only LAN by VPN
# push "route 192.168.1.0 255.255.255.0"

push "dhcp-option DNS 8.8.8.8"
keepalive 10 120
tls-auth ta.key 0
cipher AES-256-GCM
user nobody
group nogroup
persist-key
persist-tun
verb 3

EOF
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-openvpn.conf
sysctl --system
apt install iptables-persistent -y
iptables -A FORWARD -i tun0 -o ${NIC} -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i ${NIC} -o tun0 -m state --state ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 14.14.14.0/24 -o ${NIC} -j MASQUERADE
systemctl start openvpn-server@server
systemctl enable openvpn-server@server
echo "********************"
echo ""
echo ""
echo ""
systemctl status openvpn-server@server
echo ""
echo ""
echo ""
echo "INSTALL openvpn SUCCESSFULL!"
echo "LET'S OPEN PORT-FORWARDING 1194"
echo ""
echo ""
echo ""
echo "********************"
