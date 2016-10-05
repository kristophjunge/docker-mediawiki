#!/bin/bash

cd /var/www/mediawiki

php maintenance/update.php --quick
