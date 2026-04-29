#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

read -p "Enter the required additional SWAP capacity (Gb) (EX: 4): " swap

if ! [[ "$swap" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number."
    exit 1
fi

swap_old=$(swapon --show | awk 'NR==2 {print $3}')
swap_old=${swap_old:-0G}
swapoff -a
rm -f /swap.img
fallocate -l ${swap}G /swap.img
chmod 600 /swap.img
mkswap /swap.img
swapon /swap.img
sed -i '/swap.img/d' /etc/fstab
echo '/swap.img none swap sw 0 0' >> /etc/fstab
swap_new=$(swapon --show | awk 'NR==2 {print $3}')

echo ""
echo ""
echo ""
free -h
echo ""
echo ""
echo ""
echo ""
echo "✅ SWAP upgrade from ${swap_old} to ${swap_new} "
echo ""
echo ""
echo ""
