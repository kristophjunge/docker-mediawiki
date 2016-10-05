# Docker MediaWiki

Docker container for [MediaWiki](https://www.mediawiki.org) running under [Nginx](https://www.nginx.com) and [PHP-FPM](https://php-fpm.org/). Based on the official PHP7 [images](https://hub.docker.com/_/php/).

Packaged with the [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin and its dependant [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service.

This container is running 3 processes (Nginx, PHP-FPM, Parsoid) controlled by [supervisord](http://supervisord.org/).


## Features ##

- [Nginx](https://www.nginx.com)
- [PHP-FPM](https://php-fpm.org/) with [PHP7](https://www.mediawiki.org/wiki/Compatibility/de#PHP)
- [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on NodeJS v4.6.x LTS
- Imagick for thumbnail generation
- Intl for Unicode normalization
- APC as in memory PHP object cache
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)
- SMTP E-Mail with workaround for self-signed certificates
- Packed with 4 common skins (CologneBlue, Modern, MonoBook, Vector)

## Configuration

All configuration examples are given in docker-compose YAML version 2 format.

### General

Set the mandatory environment variables:
* Set `WIKI_SERVER` to your wiki's primary domain, prefixed with the primary protocol.
* Set `WIKI_SITENAME` to your wiki's name.
* Set `WIKI_LANGUAGE_CODE` to a language code of this [list](https://doc.wikimedia.org/mediawiki-core/master/php/Names_8php_source.html).

```
environment:
  WIKI_SERVER: http://wiki.example.com
  WIKI_SITENAME: MyWiki
  WIKI_LANGUAGE_CODE: en
```

Open port for HTTP communication.

```
ports:
- "80:80"
```

### HTTPS

To enable HTTPS set the environment variable `WIKI_HTTPS` to 1. With HTTPS the server variable `WIKI_SERVER` should start with `https://`.

```
environment:
  WIKI_HTTPS: 1
  WIKI_SERVER: https://wiki.example.com
```

Open port for HTTPS communication.

```
ports:
- "443:443"
```

Mount your SSL certificate and private key into the container.

```
volumes:
- /srv/mediawiki/ssl/cert.crt:/etc/ssl/crt/cert.crt:ro
- /srv/mediawiki/ssl/private.key:/etc/ssl/crt/private.key:ro
```


When `WIKI_HTTPS` is set to 1 all requests to HTTP URLs will be redirected to HTTPS to enforce a secure connection.


### Database

The container does not include a database server. You have to configure an external database.


#### MySQL

Setup the MySQL configuration environment variables.

```
environment:
  WIKI_DB_TYPE: mysql
  WIKI_DB_HOST: db
  WIKI_DB_PORT: 3306
  WIKI_DB_NAME: wikidb
  WIKI_DB_USER: wikiuser
  WIKI_DB_PASSWORD: mysecret
```

### Uploads

To enable file uploads set the environment variable `WIKI_ENABLE_UPLOADS` to 1.

```
environment:
  WIKI_ENABLE_UPLOADS: 1
```

Create a folder on your host system and set correct owner.

```
$ mkdir -p /srv/mediawiki/images
$ chown -R 999:999 /srv/mediawiki/images
```

Mount that folder as writable volume.

```
volumes:
- /srv/mediawiki/images:/var/www/mediawiki/images
```


### E-Mail

SMTP E-Mail can be enabled by setting `WIKI_SMTP` to 1. TLS auth will be used by default.


```
environment:
  WIKI_SMTP: 1
  WIKI_SMTP_HOST: smtp.example.com
  WIKI_SMTP_IDHOST: example.com
  WIKI_SMTP_PORT: 587
  WIKI_SMTP_AUTH: 1
  WIKI_SMTP_USERNAME: mail@example.com
  WIKI_SMTP_PASSWORD: secret
```

Using a self-signed certificate will not work because of failing peer verification.
If you know the security implications you can disable peer verification by setting `WIKI_SMTP_SSL_VERIFY_PEER` to 0.


### Logo

You can setup your own logo by mounting a PNG file.

```
volumes:
- ./srv/mediawiki/logo.png:/var/www/mediawiki/resources/assets/wiki.png:ro
```

### Skins

You can change the default skin by setting the environment variable `WIKI_DEFAULT_SKIN`.

```
environment:
  WIKI_DEFAULT_SKIN: vector
```

These 4 common skins are packaged with the container:

* CologneBlue
* Modern
* MonoBook
* Vector

You can add more skins by mounting them.

```
volumes:
- ./srv/mediawiki/skins/MyOtherSkin:/var/www/mediawiki/skins/MyOtherSkin:ro
```

### Extensions

You can add more extensions by mounting them.

```
volumes:
- ./srv/mediawiki/extensions/MyOtherExtension:/var/www/mediawiki/extensions/MyOtherExtension:ro
```

### Additional configuration

You can add own PHP configuration values by mounting an additional configuration file that is loaded at the end of the generic configuration file.

```
volumes:
- /srv/mediawiki/ExtraLocalSettings.php:/var/www/mediawiki/ExtraLocalSettings.php:ro
```

A good starting point is to copy the file that's inside the container. You can display its content with the following command.

```
$ docker exec -i -t dockermediawiki_wiki_1 cat /var/www/mediawiki/ExtraLocalSettings.php
```


### Configuration file

Beside the docker like configuration with environment variables you still can use your own full `LocalSettings.php` file.

However this will make all environment variables unusable except `WIKI_HTTPS` and `WIKI_SMTP_SSL_VERIFY_PEER`.

```
volumes:
- /srv/mediawiki/LocalSettings.php:/var/www/mediawiki/LocalSettings.php:ro
```


## Installation

If you are upgrading from a previous installation watch the section below "Upgrade from an existing installation".

Start the container and run the following script which is a wrapper for the MediaWiki installer.
Insert username and password for your admin account.

```
$ docker exec -i -t dockermediawiki_wiki_1 /script/install.sh <username> <password>
```

Copy the secret key that the script dumps and put it into an environment variable.

```
environment:
  WIKI_SECRET_KEY: secretkey
```

You should be able to browse your wiki at this point.


## Upgrade from an existing installation

Copy the contents of the `images` folder of your old media wiki installation into the `images` mount source.

Find the secret key variable `$wgSecretKey` in the `LocalSettings.php` file of your old installation and place its value into an environment variable.

```
environment:
  WIKI_SECRET_KEY: secretkey
```

If you are using MySQL find the variable `$wgDBTableOptions` in the `LocalSettings.php` file of your old installation and place its value into an environment variable.

```
environment:
  WIKI_DB_TABLE_OPTIONS: ENGINE=InnoDB, DEFAULT CHARSET=binary
```

Start the container and run the following script which is a wrapper for the MediaWiki updater.

```
$ docker exec -i -t dockermediawiki_wiki_1 /script/update.sh
```

You should be able to browse your wiki at this point.


## Full configuration example

A full docker-compose configuration with MySQL can be found [here](https://github.com/kristophjunge/docker-mediawiki/blob/master/docker-compose.yml).


## Configuration reference

Below is a list of all environment variables supported by the container.

When using an own `LocalSettings.php` file according to the section "Configuration file" most variables be unusable.

To modify configuration values that are not listed below read the section "Additional configuration".

More information about the configuration values can be found at MediaWiki's [documentation](https://www.mediawiki.org/wiki/Manual:Configuration_settings).

| Environment Variable | MediaWiki Config | Description |
|---|---|---|
| WIKI_HTTPS | - | Enable HTTP, Default 0 |
| WIKI_SMTP | - | Enable SMTP mailing, Default 0 |
| WIKI_SMTP_SSL_VERIFY_PEER | - | Disable SMTP auth SSL peer verification, Default 0 |
| WIKI_DEBUG | - | Enable mediawiki's debug log, Logged to /tmp/wiki-debug.log |
| WIKI_SERVER | $wgServer | The primary URL of the server prefixed with protocol |
| WIKI_SITENAME | $wgSitename | Name of the wiki |
| WIKI_LANGUAGE_CODE | $wgLanguageCode | Language code for wiki language |
| WIKI_META_NAMESPACE | $wgMetaNamespace | Namespace, Defaults to WIKI_SITENAME |
| WIKI_SECRET_KEY | $wgSecretKey | Secret key |
| WIKI_UPGRADE_KEY | $wgUpgradeKey | Upgrade key |
| WIKI_DB_TYPE | $wgDBtype | Database type, Default is "mysql" |
| WIKI_DB_HOST | $wgDBserver | Database host, Default is "127.0.0.1" |
| WIKI_DB_PORT | $wgDBserver | Database port, Default is "3306" |
| WIKI_DB_NAME | $wgDBname | Database name, Default is "wikidb" |
| WIKI_DB_USER | $wgDBuser | Database user, Default is "wikiuser" |
| WIKI_DB_PASSWORD | $wgDBpassword | Database password |
| WIKI_DB_PREFIX | $wgDBprefix | Database table name prefix |
| WIKI_DB_TABLE_OPTIONS | $wgDBTableOptions | Table options |
| WIKI_ENABLE_UPLOADS | $wgEnableUploads | Enable file uploads, Default 0 |
| WIKI_FILE_EXTENSIONS | $wgFileExtensions | Allowed file extensions, comma separated |
| WIKI_DEFAULT_SKIN | $wgDefaultSkin | Default skin, Default "vector" |
| WIKI_SMTP_HOST | $wgSMTP | SMTP Host, like smtp.example.com |
| WIKI_SMTP_IDHOST | $wgSMTP | Domain name, like example.com |
| WIKI_SMTP_PORT | $wgSMTP | SMTP Port |
| WIKI_SMTP_AUTH | $wgSMTP | Enable SMTP auth, Default 0 |
| WIKI_SMTP_USERNAME | $wgSMTP | SMTP auth username |
| WIKI_SMTP_PASSWORD | $wgSMTP | SMTP auth password |
| WIKI_EMERGENCY_CONTACT | $wgEmergencyContact | Admin contact E-Mail |
| WIKI_PASSWORD_SENDER | $wgPasswordSender | E-Mail sender for password forgot mails |


## Security

* Nginx and PHP-FPM worker processes run under the `www-data` user with UID 999 and GID 999.
* Parsoid runs under the `parsoid` user.
* Parsoid runs only inside the container. There is no port exposed.
* The MediaWiki files are owned by `root`. Only the `images` folder is owned by `www-data`.
* The Parsoid files are all owned by `root`.


## Known issues

* Sessions are stored in memory via APC and will be lost after container stop.
