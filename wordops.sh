# Get information
echo "Staging site url:"
read staging_url
echo "Staging site email:"
read staging_email
echo "Staging site username:"
read staging_username
echo "Staging site password:"
read staging_password
echo "Plugin name:"
read plugin_name
echo "Git clone url:"
read repo

# Set timezone
sudo timedatectl set-timezone Asia/Taipei

# Install Tool
sudo apt-get install git-all
sudo apt install nodejs npm

# Install WordOps
wget -qO wo wops.cc && sudo bash wo --force
wo stack install --wpcli
wo stack install --composer
wo site create "$staging_url" --wp --user="$staging_username" --pass="$staging_password" --email=
wo site cd "$staging_url" --letsencrypt

# Install plugins and themes
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
cd htdoc/wp-content/plugins
git clone "$repo"
cd "$plugin_name"
composer install
npm install
echo "Staging build successfully!"

