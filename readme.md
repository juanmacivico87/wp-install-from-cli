# WP Install from CLI

This repository contains a bash script to run a WordPress installation, with the help of the Command Line Interface.

The script, in addition to installing WordPress, applies the desired configuration.

## Requirements

In order to run this script, you need to have the following requirements installed on your server.

- [WP CLI](https://make.wordpress.org/cli/handbook/guides/installing/)
- [MySQL](https://dev.mysql.com/doc/mysql-shell/8.0/en/)
- [Git](https://git-scm.com/downloads)
- [Composer](https://getcomposer.org/download/)

## What can I do with this script?

1. Create the database in which WordPress will be installed.
2. Download the latest version of WordPress.
3. Create the wp-config.php file and add the constants you want, setting their corresponding values.
4. Install WordPress.
5. Remove "Hello World" post and sample page.
6. Set the settings for your WordPress installation.
7. Create and set the home page and posts page (if you wish).
8. Deactivate and remove the "Hello Dolly" plugin.
9. Install the plugins I use most frequently.
10. Remove inactive themes.
11. Clone my base theme, rename it and activate it.

## Steps for the installation

1. Go to the [URL of this repository](https://github.com/juanmacivico87/wp-install-from-cli). If you are reading this document, is possible that you are there.
2. Go to the directory in witch you want to install WordPress.
3. Open the Unix shell and run "git clone https://github.com/juanmacivico87/wp-install-from-cli.git"
4. Go to "wp-install-from-cli" directory.
5. Duplicate sample.config file and rename it as "local.config" (if your web is in a local environment) or "production.config" (if your web is in a production environment).
6. If you want to have another environment (stagging, pre-production, test, ...) add the option after "[2] PRODUCTION" (line 14), as well as in the command "case ... in" (line 17 ). You will also need to create a .config file for this environment.
7. Configure the different variables with the values you want. It is very important that you keep the same format. Otherwise the script will return an error.
8. Run "./wp-cli.sh" from Unix shell.

And voilà, your WordPress website is ready for begin to be developed.

## Disclaimer

This script is developed to install WordPress with the configuration, plugins and theme that I usually use in my projects. Please, feel free to adapt it to your needs if you think it is convenient.
