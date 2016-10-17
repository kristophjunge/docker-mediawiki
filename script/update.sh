#!/bin/bash

cd /var/www/mediawiki

# Run updater
php maintenance/update.php --quick

# Fix SQLite data folder permissions
chown -R www-data:www-data /data
