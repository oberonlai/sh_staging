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

# Install WordOps
wget -qO wo wops.cc && sudo bash wo --force
wo stack upgrade --nginx
wo site create "$staging_url" --wp --user="$staging_user" --pass="$staging_pass" --email="$staging_email" --letsencrypt
cd /var/www/"$staging_url"/htdocs

# Install plugins and themes
wp language core install zh_TW --allow-root
wp language core activate zh_TW --allow-root
wp option update timezone_string "Asia/Taipei" --allow-root
wp site switch-language zh_TW --allow-root
wp plugin install woocommerce --allow-root
wp language plugin install woocommerce zh_TW --allow-root
wp plugin activate woocommerce zh_TW --allow-root
wp theme install storefront --allow-root
wp language theme install storefront zh_TW --allow-root
wp theme activate storefront --allow-root

# Install Tool
sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y install git-all
sudo apt -y install nodejs npm
sudo apt -y install composer

cd wp-content/plugins
git clone "$repo"
cd "$plugin_name"
composer install
npm install
usermod --shell /bin/bash www-data
echo "Staging build successfully!"