# Docker MediaWiki

[![DockerHub Pulls](https://img.shields.io/docker/pulls/kristophjunge/mediawiki.svg)](https://hub.docker.com/r/kristophjunge/mediawiki/) [![DockerHub Stars](https://img.shields.io/docker/stars/kristophjunge/mediawiki.svg)](https://hub.docker.com/r/kristophjunge/mediawiki/) [![GitHub Stars](https://img.shields.io/github/stars/kristophjunge/docker-mediawiki.svg?label=github%20stars)](https://github.com/kristophjunge/docker-mediawiki) [![GitHub Forks](https://img.shields.io/github/forks/kristophjunge/docker-mediawiki.svg?label=github%20forks)](https://github.com/kristophjunge/docker-mediawiki) [![GitHub License](https://img.shields.io/github/license/kristophjunge/docker-mediawiki.svg)](https://github.com/kristophjunge/docker-mediawiki)

[![MediaWiki](https://raw.githubusercontent.com/kristophjunge/docker-mediawiki/master/mediawiki.png)](https://www.mediawiki.org)

Docker container for [MediaWiki](https://www.mediawiki.org) running under [Nginx](https://www.nginx.com) and [PHP-FPM](https://php-fpm.org/). Based on the official PHP7 [images](https://hub.docker.com/_/php/).

Packaged with the [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin and its dependant [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service.

This container is running 3 processes (Nginx, PHP-FPM, Parsoid) controlled by [supervisord](http://supervisord.org/).

For a basic understanding of docker please refer to the official [documentation](https://docs.docker.com/).

   * [Supported Tags](#supported-tags)
   * [Features](#features)
   * [Changelog](#changelog)
   * [Usage](#usage)
      * [With MySQL](#with-mysql)
      * [With SQLite](#with-sqlite)
   * [Configuration](#configuration)
      * [General](#general)
      * [Uploads](#uploads)
      * [E-Mail](#e-mail)
      * [Logo](#logo)
      * [Skins](#skins)
      * [Extensions](#extensions)
      * [HTTPS](#https)
      * [Additional configuration](#additional-configuration)
      * [Configuration file](#configuration-file)
      * [Performance](#performance)
   * [Configuration reference](#configuration-reference)
   * [Extending this image](#extending-this-image)
   * [Security](#security)
   * [Contributing](#contributing)
   * [License](#license)


## Supported Tags

- `1.30` [(Dockerfile)](https://github.com/kristophjunge/docker-mediawiki/blob/1.30/Dockerfile)
- `1.29` [(Dockerfile)](https://github.com/kristophjunge/docker-mediawiki/blob/1.29/Dockerfile)
- `1.28` [(Dockerfile)](https://github.com/kristophjunge/docker-mediawiki/blob/1.28/Dockerfile)
- `1.27` [(Dockerfile)](https://github.com/kristophjunge/docker-mediawiki/blob/1.27/Dockerfile)


## Features

- [MediaWiki](https://www.mediawiki.org) 1.30.0
- [Nginx](https://www.nginx.com)
- [PHP-FPM](https://php-fpm.org/) with [PHP7](https://www.mediawiki.org/wiki/Compatibility/de#PHP)
- [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin
- [UserMerge](https://www.mediawiki.org/wiki/Extension:UserMerge) plugin
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on NodeJS v4.6.x LTS
- Imagick for thumbnail generation
- Intl for Unicode normalization
- APC as in memory PHP object cache
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)


## Changelog

See [CHANGELOG.md](https://github.com/kristophjunge/docker-mediawiki/blob/master/docs/CHANGELOG.md) for information about the latest changes.


## Usage

### With MySQL

See Docker Compose [example](https://github.com/kristophjunge/docker-mediawiki/blob/master/example/docker-compose/mysql/docker-compose.yml).

Start a MySQL container.

```
docker run --name=mediawiki_mysql \
-e MYSQL_DATABASE=wikidb \
-e MYSQL_USER=wikiuser \
-e MYSQL_PASSWORD=mysecret \
-e MYSQL_RANDOM_ROOT_PASSWORD=1 \
-v /var/mediawiki/mysql:/var/lib/mysql \
-d mysql:5.7
```

Start MediaWiki container.

```
docker run --name mediawiki_wiki \
--link mediawiki_mysql:mediawiki_mysql \
-p 8080:8080 \
-e MEDIAWIKI_SERVER=http://localhost:8080 \
-e MEDIAWIKI_SITENAME=MyWiki \
-e MEDIAWIKI_LANGUAGE_CODE=en \
-e MEDIAWIKI_DB_TYPE=mysql \
-e MEDIAWIKI_DB_HOST=mediawiki_mysql \
-e MEDIAWIKI_DB_PORT=3306 \
-e MEDIAWIKI_DB_NAME=wikidb \
-e MEDIAWIKI_DB_USER=wikiuser \
-e MEDIAWIKI_DB_PASSWORD=mysecret \
-e MEDIAWIKI_ENABLE_UPLOADS=1 \
-v /var/mediawiki/images:/images \
-d kristophjunge/mediawiki
```

Create a new database with the install script. Insert username and password for your admin account.

```
docker exec -it mediawiki_wiki /script/install.sh <username> <password>
```

If you are using an existing database run the update script instead.

```
docker exec -it mediawiki_wiki /script/update.sh
```

Copy the secret key that the install script dumps or find the variable `$wgSecretKey` in your previous `LocalSettings.php` file and put it into an environment variable.

```
-e MEDIAWIKI_SECRET_KEY=secretkey
```

If you are using an existing database find the variable `$wgDBTableOptions` in your previous `LocalSettings.php` file and put it into an environment variable.

```
-e MEDIAWIKI_DB_TABLE_OPTIONS=ENGINE=InnoDB, DEFAULT CHARSET=binary
```

You should be able to browse your wiki at [http://localhost:8080](http://localhost:8080).


### With SQLite

See Docker Compose [example](https://github.com/kristophjunge/docker-mediawiki/blob/master/example/docker-compose/sqlite/docker-compose.yml).

Start MediaWiki container.

```
docker run --name=mediawiki_wiki \
-p 8080:8080 \
-e MEDIAWIKI_SERVER=http://localhost:8080 \
-e MEDIAWIKI_SITENAME=MyWiki \
-e MEDIAWIKI_LANGUAGE_CODE=en \
-e MEDIAWIKI_DB_TYPE=sqlite \
-e MEDIAWIKI_DB_NAME=wikidb \
-e MEDIAWIKI_ENABLE_UPLOADS=1 \
-v /var/mediawiki/images:/images \
-v /var/mediawiki/data:/data \
-d kristophjunge/mediawiki
```

Create a new database with the install script. Insert username and password for your admin account.

```
docker exec -it mediawiki_wiki /script/install.sh <username> <password>
```

If you are using an existing database run the update script instead.

```
docker exec -it mediawiki_wiki /script/update.sh
```

Copy the secret key that the install script dumps or find the variable `$wgSecretKey` in your previous `LocalSettings.php` file and put it into an environment variable.

```
-e MEDIAWIKI_SECRET_KEY=secretkey
```

You should be able to browse your wiki at [http://localhost:8080](http://localhost:8080).


## Configuration


### General

Set the mandatory environment variables:
* Set `MEDIAWIKI_SERVER` to your wiki's primary domain, prefixed with the primary protocol.
* Set `MEDIAWIKI_SITENAME` to your wiki's name.
* Set `MEDIAWIKI_LANGUAGE_CODE` to a language code of this [list](https://doc.wikimedia.org/mediawiki-core/master/php/Names_8php_source.html).

```
-e MEDIAWIKI_SERVER=http://wiki.example.com \
-e MEDIAWIKI_SITENAME=MyWiki \
-e MEDIAWIKI_LANGUAGE_CODE=en
```


### Uploads

To enable file uploads set the environment variable `MEDIAWIKI_ENABLE_UPLOADS` to 1.

```
-e MEDIAWIKI_ENABLE_UPLOADS=1
```

Mount a writable volume to the images folder.

```
-v /var/mediawiki/images:/images
```

Which file extensions are allowed for uploading can be controlled with the environment variable `MEDIAWIKI_FILE_EXTENSIONS`.

```
-e MEDIAWIKI_FILE_EXTENSIONS=png,gif,jpg,jpeg,webp,pdf
```

The maximum size for file uploads can be controlled with the environment variable `MEDIAWIKI_MAX_UPLOAD_SIZE`.

```
-e MEDIAWIKI_MAX_UPLOAD_SIZE=100M
```


### E-Mail

SMTP E-Mail can be enabled by setting `MEDIAWIKI_SMTP` to 1. TLS auth will be used by default.

```
-e MEDIAWIKI_SMTP=1
-e MEDIAWIKI_SMTP_HOST=smtp.example.com
-e MEDIAWIKI_SMTP_IDHOST=example.com
-e MEDIAWIKI_SMTP_PORT=587
-e MEDIAWIKI_SMTP_AUTH=1
-e MEDIAWIKI_SMTP_USERNAME=mail@example.com
-e MEDIAWIKI_SMTP_PASSWORD=secret
```

Using a self-signed certificate will not work because of failing peer verification.
If you know the security implications you can disable peer verification by setting `MEDIAWIKI_SMTP_SSL_VERIFY_PEER` to 0.


### Logo

You can setup your own logo by mounting a PNG file.

```
-v ./var/mediawiki/logo.png:/var/www/mediawiki/resources/assets/wiki.png:ro
```


### Skins

You can change the default skin by setting the environment variable `MEDIAWIKI_DEFAULT_SKIN`.

```
-e MEDIAWIKI_DEFAULT_SKIN=vector
```

The default skins are packaged with the container:

* cologneblue
* modern
* monobook
* vector

You can add more skins by mounting them.

```
-v ./var/mediawiki/skins/MyOtherSkin:/var/www/mediawiki/skins/MyOtherSkin:ro
```


### HTTPS

HTTPS is not longer supported by the container itself. Its recommended to use a proxy container for HTTPS setups. 

Make sure that you set the `MEDIAWIKI_SERVER` environment variable to the outside URL of your wiki and to apply the `https` prefix.

```
-e MEDIAWIKI_SERVER=https://localhost
```


### Extensions

You can add more extensions by mounting them.

```
-v ./var/mediawiki/extensions/MyOtherExtension:/var/www/mediawiki/extensions/MyOtherExtension:ro
```


### Additional configuration

You can add own PHP configuration values by mounting an additional configuration file that is loaded at the end of the generic configuration file.

```
-v /var/mediawiki/ExtraLocalSettings.php:/var/www/mediawiki/ExtraLocalSettings.php:ro
```

A good starting point is to copy the file that's inside the container. You can display its content with the following command.

```
docker exec -it some-wiki cat /var/www/mediawiki/ExtraLocalSettings.php
```


### Configuration file

Beside the docker like configuration with environment variables you still can use your own full `LocalSettings.php` file.

However this will make all environment variables unusable except `MEDIAWIKI_HTTPS` and `MEDIAWIKI_SMTP_SSL_VERIFY_PEER`.

```
-v /var/mediawiki/LocalSettings.php:/var/www/mediawiki/LocalSettings.php:ro
```


### Performance

The container has some performance related configuration options. If you have more advanced needs you can override the configuration inside the container by mounting configuration files.

The number of PHP-FPM worker processes can be configured with the environment variables `PHPFPM_WORKERS_START`, `PHPFPM_WORKERS_MIN` and `PHPFPM_WORKERS_MAX`.

```
-e PHPFPM_WORKERS_START=10
-e PHPFPM_WORKERS_MIN=10
-e PHPFPM_WORKERS_MAX=20
```

Default for start and min is `1`. Default for max is `20`, so up to `20` worker processes will be spawned dynamically when needed. 

For a more advanced configuration of PHP-FPM mount a configuration file to `/usr/local/etc/php-fpm.conf`. 

```
-v /var/mediawiki/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro
```

The number of Parsoid worker processes can be configured with the environment variable `PARSOID_WORKERS`.

```
-e PARSOID_WORKERS=10
```

Default is `1`. Please note that the number of Parsoid workers is not managed dynamically. Make sure that you spawn enough workers for your requirements.

For a more advanced configuration of Parsoid mount a configuration file to `/usr/lib/parsoid/src/config.yaml`.

```
-v /var/mediawiki/config.yaml:/usr/lib/parsoid/src/config.yaml:ro
```


## Configuration reference

Below is a list of all environment variables supported by the container.

When using an own `LocalSettings.php` file according to the section "Configuration file" most variables be unusable.

To modify configuration values that are not listed below read the section "Additional configuration".

More information about the configuration values can be found at MediaWiki's [documentation](https://www.mediawiki.org/wiki/Manual:Configuration_settings).

| Environment Variable | MediaWiki Config | Description |
|---|---|---|
| MEDIAWIKI_SMTP | - | Enable SMTP mailing, Default 0 |
| MEDIAWIKI_SMTP_SSL_VERIFY_PEER | - | Disable SMTP auth SSL peer verification, Default 0 |
| MEDIAWIKI_DEBUG | - | Enable mediawiki's debug log, Logged to /tmp/wiki-debug.log |
| MEDIAWIKI_SERVER | $wgServer | The primary URL of the server prefixed with protocol |
| MEDIAWIKI_SITENAME | $wgSitename | Name of the wiki |
| MEDIAWIKI_LANGUAGE_CODE | $wgLanguageCode | Language code for wiki language |
| MEDIAWIKI_META_NAMESPACE | $wgMetaNamespace | Namespace, Defaults to MEDIAWIKI_SITENAME |
| MEDIAWIKI_SECRET_KEY | $wgSecretKey | Secret key |
| MEDIAWIKI_UPGRADE_KEY | $wgUpgradeKey | Upgrade key |
| MEDIAWIKI_DB_TYPE | $wgDBtype | Database type |
| MEDIAWIKI_DB_HOST | $wgDBserver | Database host |
| MEDIAWIKI_DB_PORT | $wgDBserver | Database port |
| MEDIAWIKI_DB_NAME | $wgDBname | Database name |
| MEDIAWIKI_DB_USER | $wgDBuser | Database user |
| MEDIAWIKI_DB_PASSWORD | $wgDBpassword | Database password |
| MEDIAWIKI_DB_PREFIX | $wgDBprefix | Database table name prefix |
| MEDIAWIKI_DB_TABLE_OPTIONS | $wgDBTableOptions | Table options |
| MEDIAWIKI_ENABLE_UPLOADS | $wgEnableUploads | Enable file uploads, Default 0 |
| MEDIAWIKI_MAX_UPLOAD_SIZE | $wgMaxUploadSize | Max file upload size, Default 100M |
| MEDIAWIKI_EXTENSION_VISUAL_EDITOR_ENABLED | - | Enable the VisualEditor plugin, Default 1 |
| MEDIAWIKI_EXTENSION_USER_MERGE_ENABLED | - | Enable the UserMerge plugin, Default 1 |
| MEDIAWIKI_FILE_EXTENSIONS | $wgFileExtensions | Allowed file extensions, comma separated |
| MEDIAWIKI_DEFAULT_SKIN | $wgDefaultSkin | Default skin, Default "vector" |
| MEDIAWIKI_SMTP_HOST | $wgSMTP | SMTP Host, like smtp.example.com |
| MEDIAWIKI_SMTP_IDHOST | $wgSMTP | Domain name, like example.com |
| MEDIAWIKI_SMTP_PORT | $wgSMTP | SMTP Port |
| MEDIAWIKI_SMTP_AUTH | $wgSMTP | Enable SMTP auth, Default 0 |
| MEDIAWIKI_SMTP_USERNAME | $wgSMTP | SMTP auth username |
| MEDIAWIKI_SMTP_PASSWORD | $wgSMTP | SMTP auth password |
| MEDIAWIKI_EMERGENCY_CONTACT | $wgEmergencyContact | Admin contact E-Mail |
| MEDIAWIKI_PASSWORD_SENDER | $wgPasswordSender | E-Mail sender for password forgot mails |
| PHPFPM_WORKERS_START | - | Number of PHP-FPM worker processes to be started initially, Default 1 |
| PHPFPM_WORKERS_MIN | - | Minimum number of PHP-FPM worker processes, Default 1 |
| PHPFPM_WORKERS_MAX | - | Maximum number of PHP-FPM worker processes, Default 20 |
| PARSOID_WORKERS | - | Static number of Parsoid worker processes, Default 1 |

## Extending this image

If you need to create your own Dockerfile you can extend this image.

```
FROM kristophjunge/mediawiki:latest

COPY ./LocalSettings.php /var/www/mediawiki/LocalSettings.php

# ...
```


## Security

* Nginx and PHP-FPM worker processes run under the `www-data` user with UID 999 and GID 999.
* Parsoid runs under the `parsoid` user.
* Parsoid runs only inside the container. There is no port exposed.
* The MediaWiki files are owned by `root`. Only the `images` folder is owned by `www-data`.
* The Parsoid files are all owned by `root`.
* During container build signatures and keys of installed software is verified where possible.


## Contributing

See [CONTRIBUTION.md](https://github.com/kristophjunge/docker-mediawiki/blob/master/CONTRIBUTION.md) for information on how to contribute to the project.

See [CONTRIBUTORS.md](https://github.com/kristophjunge/docker-mediawiki/blob/master/CONTRIBUTORS.md) for the list of contributors.


## License

This project is licensed under the MIT license by Kristoph Junge.
