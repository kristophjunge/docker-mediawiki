#!/bin/bash

MEDIAWIKI_DB_NAME=${MEDIAWIKI_DB_NAME:=wikidb}
MEDIAWIKI_DB_TYPE=${MEDIAWIKI_DB_TYPE:=sqlite}

cd /var/www/mediawiki

mv ./LocalSettings.php /tmp/LocalSettings.php

php maintenance/install.php Wiki $1 --pass=$2 \
 --dbport=${MEDIAWIKI_DB_PORT} \
 --dbserver=${MEDIAWIKI_DB_HOST} \
 --dbtype=${MEDIAWIKI_DB_TYPE} \
 --dbname=${MEDIAWIKI_DB_NAME} \
 --installdbuser=${MEDIAWIKI_DB_USER} \
 --installdbpass=${MEDIAWIKI_DB_PASSWORD} \
 --scriptpath=/

echo ""
grep '$wgSecret' LocalSettings.php

rm -rf ./LocalSettings.php

mv /tmp/LocalSettings.php ./LocalSettings.php
