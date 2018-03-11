#!/usr/bin/env bash
# Provision WordPress Stable

# Configuration
CONFIG_ACF_PRO_KEY=`get_config_value 'acf_pro_key'`

# Make a database, if we don't already have one
echo -e "\nCreating database 'sitename' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS sitename"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON sitename.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then

  echo "Downloading WordPress Stable, see http://wordpress.org/"
  cd ${VVV_PATH_TO_SITE}
  curl -L -O "https://wordpress.org/latest.tar.gz"
  noroot tar -xvf latest.tar.gz
  mv wordpress public_html
  rm latest.tar.gz
  cd ${VVV_PATH_TO_SITE}/public_html

  echo "Configuring WordPress Stable..."
  noroot wp core config --dbname=sitename --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP

  echo "Installing WordPress Stable..."
  noroot wp core install --url=sitename.test --quiet --title="Site name" --admin_name=admin --admin_email="admin@local.test" --admin_password="password"
  echo "Creating cache folder for composer..."
  mkdir /home/vagrant/.composer
  echo "Setting up composer cache permissions..."
  chown -R www-data:www-data /home/vagrant/.composer
  echo "Installing project composer dependencies..."
  cd ${VVV_PATH_TO_SITE}/site
  noroot sudo -u www-data ACF_PRO_KEY=${CONFIG_ACF_PRO_KEY} /usr/local/bin/composer install
  echo "Symlinking wp-content..."
  # removing the vanilla wp-content folder installed with WP core
  rm -rf ${VVV_PATH_TO_SITE}/public_html/wp-content
  # symlinking wp-content from git repo to public_html dir from which VVV serves Wordpress
  ln -s ${VVV_PATH_TO_SITE}/site/wp-content ${VVV_PATH_TO_SITE}/public_html/wp-content
  echo "Activating plugins..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp plugin activate --all
  # installing plugins first, theme second to avoid plugin-related errors on activation
  echo "Installing the theme..."
  noroot wp theme install https://github.com/certainlyakey/timber-boilerplate/archive/master.zip --activate

else

  echo "Updating WordPress Stable..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp core update
  echo "Setting up composer cache permissions..."
  chown -R www-data:www-data /home/vagrant/.composer
  echo "Installing project composer dependencies..."
  cd ${VVV_PATH_TO_SITE}/site
  noroot sudo -u www-data ACF_PRO_KEY=${CONFIG_ACF_PRO_KEY} /usr/local/bin/composer install
  echo "Removing themes installed during earlier provision..."
  rm -rf wp-content/themes
  echo "Activating plugins..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp plugin activate --all
  echo "Installing the theme..."
  noroot wp theme install https://github.com/certainlyakey/timber-boilerplate/archive/master.zip --activate

fi