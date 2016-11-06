FROM php:7-fpm
MAINTAINER Kristoph Junge <kristoph.junge@gmail.com>

# Change UID and GID of www-data user to match host privileges
ARG MEDIAWIKI_USER_UID=999
ARG MEDIAWIKI_USER_GID=999
RUN usermod -u $MEDIAWIKI_USER_UID www-data && \
    groupmod -g $MEDIAWIKI_USER_GID www-data

# Utilities
RUN apt-get update && \
    apt-get -y install apt-transport-https git curl --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# MySQL PHP extension
RUN docker-php-ext-install mysqli

# Pear mail
RUN apt-get update && \
    apt-get install -y php-pear --no-install-recommends && \
    pear install mail Net_SMTP && \
    rm -r /var/lib/apt/lists/*

# Imagick with PHP extension
RUN apt-get update && apt-get install -y imagemagick libmagickwand-6.q16-dev --no-install-recommends && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ && \
    pecl install imagick-3.4.0RC6 && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini && \
    rm -rf /var/lib/apt/lists/*

# Intl PHP extension
RUN apt-get update && apt-get install -y libicu-dev g++ --no-install-recommends && \
    docker-php-ext-install intl && \
    apt-get install -y --auto-remove libicu52 g++ && \
    rm -rf /var/lib/apt/lists/*

# APC PHP extension
RUN pecl install apcu && \
    pecl install apcu_bc-1.0.3 && \
    docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini && \
    docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# Nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
ARG NGINX_VERSION=1.9.9-1~jessie
RUN apt-get update && \
    apt-get -y install ca-certificates nginx=${NGINX_VERSION} --no-install-recommends && \
    rm -r /var/lib/apt/lists/*
COPY config/nginx/* /etc/nginx/

# PHP-FPM
COPY config/php-fpm/php-fpm.conf /usr/local/etc/
COPY config/php-fpm/php.ini /usr/local/etc/php/
RUN mkdir -p /var/run/php7-fpm/ && \
    chown www-data:www-data /var/run/php7-fpm/

# Supervisor
RUN apt-get update && \
    apt-get install -y supervisor --no-install-recommends && \
    rm -r /var/lib/apt/lists/*
COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/
COPY config/supervisor/kill_supervisor.py /usr/bin/

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs --no-install-recommends

# Parsoid from apt repo. Installs older version 0.5.1 working with old js config file
RUN useradd parsoid --no-create-home --home-dir /usr/lib/parsoid/src --shell /usr/sbin/nologin
RUN apt-key advanced --keyserver pgp.mit.edu --recv-keys 90E9F83F22250DD7 && \
    echo "deb https://releases.wikimedia.org/debian jessie-mediawiki main" > /etc/apt/sources.list.d/parsoid.list && \
    apt-get update && \
    apt-get -y install parsoid --no-install-recommends
COPY config/parsoid/localsettings.js /usr/lib/parsoid/src/localsettings.js

# Parsoid from git repo. Installs version > 0.5.2 working with new yaml config file
#ARG PARSOID_GIT_BRANCH=master
#RUN mkdir -p /usr/lib/parsoid/src
#RUN useradd parsoid --no-create-home --home-dir /usr/lib/parsoid/src --shell /usr/sbin/nologin
#RUN git clone https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid /tmp/parsoid
#RUN git --git-dir=/tmp/parsoid/.git --work-tree=/tmp/parsoid archive --format=tar $PARSOID_GIT_BRANCH | tar -xf - -C /usr/lib/parsoid/src
#RUN rm -rf /tmp/parsoid
#RUN npm install --prefix /usr/lib/parsoid/src
#COPY config/parsoid/config.yaml /usr/lib/parsoid/src/config.yaml

# MediaWiki
ARG MEDIAWIKI_VERSION_MAJOR=1.27
ARG MEDIAWIKI_VERSION=1.27.1
ADD https://releases.wikimedia.org/mediawiki/$MEDIAWIKI_VERSION_MAJOR/mediawiki-$MEDIAWIKI_VERSION.tar.gz /tmp/mediawiki.tar.gz
RUN mkdir -p /var/www/mediawiki /data && \
    tar -xzf /tmp/mediawiki.tar.gz -C /tmp && \
    mv /tmp/mediawiki-$MEDIAWIKI_VERSION/* /var/www/mediawiki && \
    rm -rf /tmp/mediawiki.tar.gz /tmp/mediawiki-$MEDIAWIKI_VERSION/ && \
    chown -R www-data:www-data /var/www/mediawiki/images /data
COPY config/mediawiki/* /var/www/mediawiki/

# VisualEditor extension
ARG EXTENSION_VISUALEDITOR_VERSION=REL1_27-9da5996
ADD https://extdist.wmflabs.org/dist/extensions/VisualEditor-$EXTENSION_VISUALEDITOR_VERSION.tar.gz /tmp/extension-visualeditor.tar.gz
RUN tar -xzf /tmp/extension-visualeditor.tar.gz -C /var/www/mediawiki/extensions && \
    rm /tmp/extension-visualeditor.tar.gz

# Set work dir
WORKDIR /var/www/mediawiki

# Copy install and update script
RUN mkdir /script
COPY script/* /script/

# General setup
VOLUME ["/var/cache/nginx", "/var/www/mediawiki/images", "/data"]
EXPOSE 80 443
CMD ["/script/docker-entry.sh"]
