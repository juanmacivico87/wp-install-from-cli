#!/bin/bash
echo 'WordPress Installer from WP-CLI by juanmacivico87'

echo 'This is a local development or a production environment??'
echo '1. LOCAL'
echo '2. PRODUCTION'
read WP_ENVIRONMENT_TYPE_OPTION

case $WP_ENVIRONMENT_TYPE_OPTION in
    1)
        WP_ENVIRONMENT_TYPE='local'
        ;;
    2)
        WP_ENVIRONMENT_TYPE='production'
        ;;
    *)
        echo 'Sorry, that is not a valid option'
        sleep 5
        exit
esac

cd "$(dirname "$0")"
source "$WP_ENVIRONMENT_TYPE.config"
cd ..

# Create database
mysql --user="$DB_USER" --password="$DB_PASSWORD" --execute="create database if not exists $DB_NAME character set $DB_CHARSET collate $DB_COLLATE;";
echo 'Database has been created'

# Download WordPress
wp core download --locale=es_ES
# Create wp-config.php
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST:$DB_PORT" --dbcharset="$DB_CHARSET" --dbcollate="$DB_COLLATE" --dbprefix="$DB_PREFIX"
wp config set WP_ENVIRONMENT_TYPE $WP_ENVIRONMENT_TYPE
wp config set WP_DEBUG $WP_DEBUG --raw
wp config set WP_DEBUG_DISPLAY $WP_DEBUG_DISPLAY --raw
wp config set WP_HOME $WP_HOME
wp config set WP_SITEURL $WP_SITEURL
# Install WordPress
wp core install --url="$WP_HOME" --title="$TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"

sleep 5