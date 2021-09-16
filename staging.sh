#!/bin/bash

#styles
VP_NONE='\033[00m'
VP_RED='\033[01;31m'
VP_GREEN='\033[01;32m'
VP_YELLOW='\033[01;33m'
VP_PURPLE='\033[01;35m'
VP_CYAN='\033[01;36m'
VP_WHITE='\033[01;37m'
VP_BOLD='\033[1m'
VP_UNDERLINE='\033[4m'

echo "${VP_BOLD}Enter Staging site url:${VP_NONE}"
read staging_url

# apt upgrade
echo "Apt upgrade"
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove

# Install webinoly
echo "Install webinoly"
wget -qO weby qrok.es/wy && sudo bash weby 3

# Save password
echo "Save password"
webinoly -dbpass > /root/password
chmod 400 /root/password

# Set timezone
echo "Set timezone"
sudo timedatectl set-timezone Asia/Taipei
webinoly -timezone=Asia/Taipei

# Install WP-CLI
echo "Install WP-CLI"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Install Git
echo "Install Git"
sudo apt-get install git-all

# Install Composer
echo "Install Composer"
sudo apt install composer

# Install Node.js
echo "Install Node.js"
sudo apt install nodejs npm

# Build staging site
echo "Build staging site"
sudo site "$staging_url" -wp -cache=off
sudo site "$staging_url" -ssl=on

wp language core install zh_TW
wp language core activate zh_TW
wp option update timezone_string "Asia/Taipei"
wp site switch-language 
wp plugin install woocommerce
wp language plugin install woocommerce zh_TW
wp theme install storefront
wp language theme install storefront zh_TW
wp theme activate storefront

# Open firewall ports
#ufw allow http
#ufw allow https
#ufw allow 25
#ufw allow 587
#ufw allow 110

echo "Staging Completed"
