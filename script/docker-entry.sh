#!/bin/bash

# Fix permissions of images folder
chown -R 999:999 /var/www/mediawiki/images

# Set upload size default to be used in PHP config
MEDIAWIKI_MAX_UPLOAD_SIZE=${MEDIAWIKI_MAX_UPLOAD_SIZE:="100M"}
export MEDIAWIKI_MAX_UPLOAD_SIZE

# Setup nginx configs
MEDIAWIKI_HTTPS=${MEDIAWIKI_HTTPS:=0}
MEDIAWIKI_SMTP_SSL_VERIFY_PEER=${MEDIAWIKI_SMTP_SSL_VERIFY_PEER:=0}

if [ ${MEDIAWIKI_HTTPS} == 1 ]; then
    # Use HTTPS config
    mv /etc/nginx/nginx-https.conf /etc/nginx/nginx.conf
else
    # Use HTTP config
    mv /etc/nginx/nginx-http.conf /etc/nginx/nginx.conf
fi

# Disable SSL peer verification in PEAR mail class to support self signed certs
if [ ${MEDIAWIKI_SMTP_SSL_VERIFY_PEER} == 0 ]; then
    sed -i "s/if (isset(\$params\['socket_options'\])) \$this->socket_options = \$params\['socket_options'\];/if (isset(\$params['socket_options'])) \$this->socket_options = \$params['socket_options'];\\n\$this->socket_options['ssl']['verify_peer'] = false;\\n\$this->socket_options['ssl']['verify_peer_name'] = false;/g" /usr/local/lib/php/Mail/smtp.php
fi

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
