#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

tee /etc/sysctl.d/99-disable-ipv6.conf > /dev/null <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

sysctl --system
