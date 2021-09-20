# Get information
echo "1.Staging site url:"
read staging_url
echo "2.Staging admin user:"
read staging_user
echo "3.Staging admin password:"
read staging_pass
echo "4.Staging admin email:"
read staging_email
echo "5.Plugin name:"
read plugin_name
echo "6.Git clone url:"
read repo

# Set timezone
sudo timedatectl set-timezone Asia/Taipei

# Install Tool
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove

sudo apt -y install git-all
sudo apt -y install nodejs npm
sudo apt -y install composer

# Install WordOps
wget -qO wo wops.cc && sudo bash wo --force
wo site create "$staging_url" --wp --user="$staging_user" --pass="$staging_pass" --email="$staging_email" --letsencrypt --php74
wo site cd "$staging_url"
cd htdocs

# Install plugins and themes
usermod --shell /bin/bash www-data
su www-data
wp language core install zh_TW
wp language core activate zh_TW
wp option update timezone_string "Asia/Taipei"
wp site switch-language zh_TW
wp plugin install woocommerce
wp language plugin install woocommerce zh_TW
wp theme install storefront
wp language theme install storefront zh_TW
wp theme activate storefront
cd wp-content/plugins
git clone "$repo"
cd "$plugin_name"
composer install
npm install
echo "Staging build successfully!"

