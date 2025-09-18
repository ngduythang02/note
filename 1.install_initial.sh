#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install net-tools -y
sudo apt install vim -y
echo 'export HISTTIMEFORMAT="%F %T "' | sudo tee -a /etc/bash.bashrc
source /etc/bash.bashrc
