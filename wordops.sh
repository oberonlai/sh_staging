# Get information
echo "Staging site url:"
read staging_url
echo "Plugin name:"
read plugin_name
echo "Git clone url:"
read repo

# Set timezone
sudo timedatectl set-timezone Asia/Taipei

# Install Tool
sudo apt -y install git-all
sudo apt -y install nodejs npm
sudo apt -y install composer

# Install WordOps
wget -qO wo wops.cc && sudo bash wo --force
wo site create "$staging_url" --wp --user=oberon --pass=oberon615926 --email=m615926@gmail.com --letsencrypt
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

