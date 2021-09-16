#!/bin/bash

echo "Enter Staging site url:"
read staging_url

# apt upgrade
sudo apt update
apt list --upgradeable
sudo apt -y upgrade
sudo apt -y autoremove

# Install webinoly
wget -qO weby qrok.es/wy && sudo bash weby 3

# Save password
webinoly -dbpass > /root/password
chmod 400 /root/password

# Set timezone
timedatectl set-timezone Asia/Taipei
webinoly -timezone=Asia/Taipei

# [Optional] Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Install Git
sudo apt-get install git-all

# Install Composer
sudo apt install composer

# Install Node.js
sudo apt install nodejs npm

# Build staging site
sudo site "$staging_url" -wp -cache=off
sudo site "$staging_url" -ssl=on

# apt update again
sudo apt upgrade
sudo apt -y upgrade
sudo apt -y autoremove

# Open firewall ports
#ufw allow http
#ufw allow https
#ufw allow 25
#ufw allow 587
#ufw allow 110

# Cleanup
stackscript_cleanup

echo "StackScript Completed" > /root/DONE
