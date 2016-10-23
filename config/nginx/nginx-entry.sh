#!/bin/bash

# Fix permissions of images folder
chown -R 999:999 /var/www/mediawiki/images

MEDIAWIKI_HTTPS=${MEDIAWIKI_HTTPS:=0}
MEDIAWIKI_SMTP_SSL_VERIFY_PEER=${MEDIAWIKI_SMTP_SSL_VERIFY_PEER:=0}

if [ ${MEDIAWIKI_HTTPS} == 1 ]; then
    # Use HTTPS config
    mv /etc/nginx/nginx-https.conf /etc/nginx/nginx.conf
else
    # Use HTTP config
    mv /etc/nginx/nginx-http.conf /etc/nginx/nginx.conf
fi

if [ ${MEDIAWIKI_SMTP_SSL_VERIFY_PEER} == 0 ]; then
    # Disable SSL peer verification in PEAR mail class to support self signed certs
    sed -i "s/\$this->socket_options = \$socket_options;/\$this->socket_options = \$socket_options;\\n\$this->socket_options['ssl']['verify_peer'] = false;\\n\$this->socket_options['ssl']['verify_peer_name'] = false;/g" /usr/local/lib/php/Net/SMTP.php
fi

nginx
