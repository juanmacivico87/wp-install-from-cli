#!/usr/bin/env bash
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
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST:$DB_PORT" --dbcharset="$DB_CHARSET" --dbcollate="$DB_COLLATE" --dbprefix="$DB_PREFIX" --extra-php <<PHP
error_reporting( $PHP_ERROR_REPORTING );
ini_set( 'display_errors', $PHP_DISPLAY_ERRORS );
PHP

wp config set WP_ENVIRONMENT_TYPE $WP_ENVIRONMENT_TYPE
wp config set WP_HOME $WP_HOME
wp config set WP_SITEURL $WP_SITEURL

wp config set WP_DEBUG $WP_DEBUG --raw
wp config set WP_DEBUG_DISPLAY $WP_DEBUG_DISPLAY --raw
wp config set WP_DEBUG_LOG $WP_DEBUG_LOG --raw
wp config set SCRIPT_DEBUG $SCRIPT_DEBUG --raw
wp config set WP_DISABLE_FATAL_ERROR_HANDLER $WP_DISABLE_FATAL_ERROR_HANDLER --raw
wp config set IMPORT_DEBUG $IMPORT_DEBUG --raw

if [ $WP_CACHE = false ]
then
    wp config set DISABLE_CACHE true --raw
else
    wp config set ENABLE_CACHE true --raw
fi

wp config set WP_CACHE $WP_CACHE --raw
wp config set CONCATENATE_SCRIPTS $CONCATENATE_SCRIPTS --raw
wp config set COMPRESS_CSS $COMPRESS_CSS --raw
wp config set COMPRESS_SCRIPTS $COMPRESS_SCRIPTS --raw
wp config set ENFORCE_GZIP $ENFORCE_GZIP --raw

if [ $WP_ENVIRONMENT_TYPE != 'local' ]
then
    wp config set FORCE_SSL_LOGIN true
    wp config set FORCE_SSL_ADMIN true
fi

wp config set AUTOMATIC_UPDATER_DISABLED $AUTOMATIC_UPDATER_DISABLED --raw
wp config set DISALLOW_FILE_EDIT $DISALLOW_FILE_EDIT --raw
wp config set WP_POST_REVISIONS $WP_POST_REVISIONS --raw
wp config set EMPTY_TRASH_DAYS $EMPTY_TRASH_DAYS --raw
wp config set DISABLE_WP_CRON $DISABLE_WP_CRON --raw
wp config set WP_MEMORY_LIMIT $WP_MEMORY_LIMIT
wp config set WP_MAX_MEMORY_LIMIT $WP_MAX_MEMORY_LIMIT
wp config set IMAGE_EDIT_OVERWRITE $IMAGE_EDIT_OVERWRITE --raw

wp config set WP_ALLOW_REPAIR $WP_ALLOW_REPAIR --raw
wp config set DISABLE_NAG_NOTICES $DISABLE_NAG_NOTICES --raw
# Install WordPress
wp core install --url="$WP_HOME" --title="$TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"

sleep 5
