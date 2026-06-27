#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi
# Variable
PORT="1194"
PROTO="udp"
IP_PUBLIC=$(curl -s https://api.ipify.org || curl -s https://ifconfig.me)
#######################################################
read -p "Enter user local: " user
read -p "Name's client (Recomment: DNG-TECHNICAL): " CLIENT
read -p "Enter static IP, default DHCP (Recomment: 14.14.14.0): " ipstatic
if [ -z "$CLIENT" ]; then
    echo "Client name cannot be empty."
    exit 1
fi

if [ -f /tools/openvpn/openvpn-ca/pki/issued/${CLIENT}.crt ]; then
    echo "Client '${CLIENT}' already exists!"
    exit 1
fi


#Install-openvpn-client
cd /tools/openvpn/openvpn-ca

export EASYRSA_BATCH=1
EASYRSA_REQ_CN="$CLIENT" \
./easyrsa gen-req "$CLIENT" nopass
./easyrsa sign-req client "$CLIENT"

mkdir -p /tools/openvpn/clients/$CLIENT
cp pki/ca.crt /tools/openvpn/clients/$CLIENT/
cp pki/issued/${CLIENT}.crt /tools/openvpn/clients/$CLIENT/
cp pki/private/${CLIENT}.key /tools/openvpn/clients/$CLIENT/
cp ta.key /tools/openvpn/clients/$CLIENT/

cat > /tools/openvpn/clients/$CLIENT/${CLIENT}.ovpn <<EOF
client
dev tun
proto $PROTO

remote $IP_PUBLIC $PORT

resolv-retry infinite
nobind

persist-key
persist-tun

remote-cert-tls server

cipher AES-256-GCM

verb 3

<ca>
$(cat /tools/openvpn/clients/$CLIENT/ca.crt)
</ca>

<cert>
$(awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' /tools/openvpn/clients/$CLIENT/${CLIENT}.crt)
</cert>

<key>
$(cat /tools/openvpn/clients/$CLIENT/${CLIENT}.key)
</key>

<tls-auth>
$(cat /tools/openvpn/clients/$CLIENT/ta.key)
</tls-auth>

key-direction 1
EOF

if [ -z "$ipstatic" ]; then
    exit 1
else
    tee /etc/openvpn/ccd/${CLIENT} > /dev/null <<EOF
    ifconfig-push ${ipstatic} 255.255.255.0

EOF
fi

if [ -z "$user" ]; then
    exit 1
else
    cp /tools/openvpn/clients/$CLIENT/${CLIENT}.ovpn /home/${user}/
    chown ${user}:${user} /home/${user}/${CLIENT}.ovpn
    echo "Coped ${CLIENT}.ovpn to /home/${user}/"
    echo ""
    echo ""
fi

echo "********************"
echo ""
echo ""
echo ""
echo "Done!"
echo ""
echo ""
echo ""
echo "********************"
echo ""
echo ""
echo ""
echo "Paste the following content into the Windows client openvpn - ${CLIENT}.ovpn."
echo ""
echo ""
cat /tools/openvpn/clients/$CLIENT/${CLIENT}.ovpn
echo ""
echo ""
echo ""
echo "********************"
echo ""
echo ""
echo ""
echo "Access Micosoft Store to download the Windows client openVPN."
echo ""
echo ""
echo ""
