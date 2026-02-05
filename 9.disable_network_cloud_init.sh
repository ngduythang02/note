#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg > /dev/null <<'EOF'
network: {config: disabled}
EOF

cloud-init clean
netplan apply
