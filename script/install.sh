#!/bin/bash

cd /var/www/mediawiki

mv ./LocalSettings.php /tmp/LocalSettings.php

php maintenance/install.php Wiki $1 --pass=$2 \
 --dbport=$WIKI_DB_PORT \
 --dbserver=$WIKI_DB_HOST \
 --installdbuser=$WIKI_DB_USER \
 --installdbpass=$WIKI_DB_PASSWORD \
 --dbname=$WIKI_DB_NAME

echo ""
grep '$wgSecret' LocalSettings.php

rm -rf ./LocalSettings.php

mv /tmp/LocalSettings.php ./LocalSettings.php
