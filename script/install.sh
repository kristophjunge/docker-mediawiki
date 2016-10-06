#!/bin/bash

cd /var/www/mediawiki

mv ./LocalSettings.php /tmp/LocalSettings.php

php maintenance/install.php Wiki $1 --pass=$2 \
 --dbport=$MEDIAWIKI_DB_PORT \
 --dbserver=$MEDIAWIKI_DB_HOST \
 --installdbuser=$MEDIAWIKI_DB_USER \
 --installdbpass=$MEDIAWIKI_DB_PASSWORD \
 --dbname=$MEDIAWIKI_DB_NAME

echo ""
grep '$wgSecret' LocalSettings.php

rm -rf ./LocalSettings.php

mv /tmp/LocalSettings.php ./LocalSettings.php
