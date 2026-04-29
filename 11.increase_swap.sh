#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You need to run this script with root privileges"
    exit 1
fi

##########################################################
RAM=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
DISK=$(df / | awk 'NR==2 {print int($4/1024)}')

# calculate (MB)
recomment_A=$((RAM / 2))
recomment_B=$((DISK / 3))

if [ "$recomment_A" -gt "$recomment_B" ]; then
    recomment_MB=$recomment_B
else
    recomment_MB=$recomment_A
fi

recomment=$(awk -v v="$recomment_MB" 'BEGIN {print int(v/1024)}')

##########################################################

read -p "Enter the required additional SWAP capacity (Gb) (Recomment: ${recomment}): " swap

if ! echo "$swap" | grep -qE '^[0-9]+$'; then
    echo "Invalid input. Please enter a number."
    exit 1
fi

swap_old=$(swapon --show | awk 'NR==2 {print $3}')
swap_old=${swap_old:-0G}

read -p "Do you want SWAP to change from ${swap_old} to ${swap}Gb? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Exit..."
    exit 0
fi

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
echo "✅ SWAP to change from ${swap_old} to ${swap_new} "
echo ""
echo ""
echo ""
