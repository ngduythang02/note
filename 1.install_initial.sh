#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install net-tools -y
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo apt install vim -y
echo 'export HISTTIMEFORMAT="%F %T "' | sudo tee -a /etc/bash.bashrc
echo -e "\n"
echo -e "source /etc/bash.bashrc"
