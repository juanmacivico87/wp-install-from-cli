#!/usr/bin/env bash
echo -e '\033[1;34m ##################################################### \033[0m'
echo -e '\033[1;34m # WordPress Installer from WP-CLI                   # \033[0m'
echo -e '\033[1;34m #                                                   # \033[0m'
echo -e '\033[1;34m # Author:   juanmacivico87                          # \033[0m'
echo -e '\033[1;34m # Website:  https://www.juanmacivico87.com          # \033[0m'
echo -e '\033[1;34m # GitHub:   https://www.github.com/juanmacivico87   # \033[0m'
echo -e '\033[1;34m ##################################################### \033[0m'
echo ''

echo 'Please, select your environment:'
echo ''
echo '[1] LOCAL'
echo '[2] PRODUCTION'
read WP_ENVIRONMENT_TYPE_OPTION

case $WP_ENVIRONMENT_TYPE_OPTION in
    1)
        WP_ENVIRONMENT_TYPE='local'
        ;;
    2)
        WP_ENVIRONMENT_TYPE='production'
        ;;
    *)
        echo ''
        echo -e '\033[1;31m Sorry, that is not a valid option \033[0m'
        echo ''
        echo 'Please, press ENTER to exit . . .'
        read CLOSE
        exit
esac

cd "$(dirname "$0")"
source "$WP_ENVIRONMENT_TYPE.config"
cd ..

# Create database
echo -e '\033[1;35m Step 1: Create database \033[0m'
mysql --user="$DB_USER" --password="$DB_PASSWORD" --execute="create database if not exists $DB_NAME character set $DB_CHARSET collate $DB_COLLATE;";

# Download WordPress
echo -e '\033[1;35m Step 2: Download WordPress \033[0m'
wp core download --locale=es_ES

# Create wp-config file'
echo -e '\033[1;35m Step 3: Create wp-config file \033[0m'
wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST:$DB_PORT" --dbcharset="$DB_CHARSET" --dbcollate="$DB_COLLATE" --dbprefix="$DB_PREFIX" --extra-php <<PHP
error_reporting( $PHP_ERROR_REPORTING );
ini_set( 'display_errors', $PHP_DISPLAY_ERRORS );
PHP

# Set constants and variables of wp-config file
echo -e '\033[1;35m Step 4: Set constants and variables of wp-config file \033[0m'
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
echo -e '\033[1;35m Step 5: Install WordPress \033[0m'
wp core install --url="$WP_HOME" --title="$TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"

# Remove «Hello World» post and «Example» page
echo -e '\033[1;35m Step 6: Remove «Hello World» post and «Example» page \033[0m'
wp post delete 1 --force
wp post delete 2 --force

# Set options
echo -e '\033[1;35m Step 7: Set options \033[0m'
wp option update blogdescription "$BLOG_DESCRIPTION"
wp option update start_of_week $START_OF_WEEK
wp option update default_role "$DEFAULT_ROLE"
wp option update WPLANG "$WPLANG"
wp option update timezone_string "$TIMEZONE_STRING"
wp option update date_format "$DATE_FORMAT"
wp option update time_format "$TIME_FORMAT"

wp option update show_on_front "$SHOW_ON_FRONT"

if [ $SHOW_ON_FRONT = 'page' ]
then
    wp option update page_on_front "$(wp post create --post_type=page --post_title='Home' --post_status='publish' --porcelain)"
    wp option update page_for_posts "$(wp post create --post_type=page --post_title='Blog' --post_status='publish' --porcelain)"
fi

wp option update posts_per_page $POSTS_PER_PAGE

if [ $WP_ENVIRONMENT_TYPE = 'local' ]
then
    wp option update blog_public false
else
    wp option update blog_public true
fi

wp option update default_pingback_flag $DEFAULT_PINGBACK_FLAG
wp option update default_ping_status "$DEFAULT_PING_STATUS"
wp option update default_comment_status "$DEFAULT_COMMENT_STATUS"
wp option update require_name_email $REQUIRE_NAME_EMAIL
wp option update comment_registration $COMMENT_REGISTRATION
wp option update close_comments_for_old_posts $CLOSE_COMMENTS_FOR_OLD_POSTS
wp option update show_comments_cookies_opt_in $SHOW_COMMENTS_COOKIES_OPT_IN
wp option update thread_comments $THREAD_COMMENTS
wp option update thread_comments_depth $THREAD_COMMENTS_DEPTH
wp option update page_comments $PAGE_COMMENTS
wp option update comments_notify $COMMENTS_NOTIFY
wp option update moderation_notify $MODERATION_NOTIFY
wp option update comment_moderation $COMMENT_MODERATION
wp option update comment_previously_approved $COMMENT_PREVIOUSLY_APPROVED
wp option update show_avatars $SHOW_AVATARS

wp option update thumbnail_size_w $THUMBNAIL_SIZE_W
wp option update thumbnail_size_h $THUMBNAIL_SIZE_H
wp option update medium_size_w $MEDIUM_SIZE_W
wp option update medium_size_h $MEDIUM_SIZE_H
wp option update large_size_w $LARGE_SIZE_W
wp option update large_size_h $LARGE_SIZE_H
wp option update thumbnail_crop $THUMBNAIL_CROP
wp option update uploads_use_yearmonth_folders $UPLOADS_USE_YEARMONTH_FOLDERS

wp option update permalink_structure "$PERMALINK_STRUCTURE"

# Remove «Hello Dolly» plugin
echo -e '\033[1;35m Step 8: Remove «Hello Dolly» plugin \033[0m'
wp plugin deactivate hello
wp plugin delete hello

# Download and install required plugins
echo -e '\033[1;35m Step 9: Download and install required plugins \033[0m'
wp plugin install query-monitor --activate
echo ''

if [ $WP_ENVIRONMENT_TYPE = 'local' ]
then
    wp plugin install stream
    echo ''
    wp plugin install simply-show-hooks --activate
else
    wp plugin install stream --activate
fi

if [ $ACF_PRO_KEY != false ]
then
    echo ''
    wp plugin install "http://connect.advancedcustomfields.com/index.php?p=pro&a=download&k=$ACF_PRO_KEY" --activate
    wp eval "acf_pro_update_license( '$ACF_PRO_KEY' );"
fi

# Remove inactive themes
echo -e '\033[1;35m Step 10: Remove inactive themes \033[0m'
wp theme delete --all

# Download and rename wptheme-sample theme
echo -e '\033[1;35m Step 11: Download and rename wptheme-sample theme \033[0m'
cd $(wp theme path)
git clone https://github.com/juanmacivico87/wptheme-sample.git
mv wptheme-sample $THEME_SLUG
cd $THEME_SLUG

rm -r -f .git
rm -f readme.md

grep -rl "{{ theme_name }}" | xargs sed -i "s/{{ theme_name }}/$THEME_NAME/g"
grep -rl "{{ theme_description }}" | xargs sed -i "s/{{ theme_description }}/$THEME_DESCRIPTION/g"
grep -rl "{{ theme_uri }}" | xargs sed -i "s/{{ theme_uri }}/$THEME_URI/g"
grep -rl "{{ theme_author }}" | xargs sed -i "s/{{ theme_author }}/$THEME_AUTHOR/g"
grep -rl "{{ theme_author_uri }}" | xargs sed -i "s/{{ theme_author_uri }}/$THEME_AUTHOR_URI/g"
grep -rl "wptheme-sample" | xargs sed -i "s/wptheme-sample/$THEME_SLUG/g"
grep -rl "wptheme/sample" | xargs sed -i "s/wptheme\/sample/$COMPOSER_VENDOR_NAME\/$THEME_SLUG/g"
grep -rl "PrefixConfig" | xargs sed -i "s/PrefixConfig/$THEME_CONFIG_NAMESPACE/g"
grep -rl "PrefixSource" | xargs sed -i "s/PrefixSource/$THEME_SOURCE_NAMESPACE/g"
grep -rl "\$prefix_" | xargs sed -i "s/\$prefix_/\$$THEME_VARS_PREFIX/g"
grep -rl "PREFIX_" | xargs sed -i "s/PREFIX_/$THEME_CONSTANTS_PREFIX/g"

cd "$(wp eval 'echo get_home_path();')"

echo ''
echo -e '\033[1;32m WordPress installed successfully!!! \033[0m'
echo ''
echo 'Please, press ENTER to exit . . .'
read CLOSE
