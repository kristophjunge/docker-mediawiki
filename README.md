# Docker MediaWiki

Docker container for [MediaWiki](https://www.mediawiki.org) running under [Nginx](https://www.nginx.com) and [PHP-FPM](https://php-fpm.org/). Based on the official PHP7 [images](https://hub.docker.com/_/php/).

Packaged with the [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin and its dependant [Parsoid](https://www.mediawiki.org/wiki/Parsoid) service.

This container is running 3 processes (Nginx, PHP-FPM, Parsoid) controlled by [supervisord](http://supervisord.org/).


## Supported Tags

- `1.27` [(Dockerfile)](https://github.com/kristophjunge/docker-mediawiki/blob/1.27/Dockerfile)


## Features

- [MediaWiki](https://www.mediawiki.org) 1.27.1
- [Nginx](https://www.nginx.com)
- [PHP-FPM](https://php-fpm.org/) with [PHP7](https://www.mediawiki.org/wiki/Compatibility/de#PHP)
- [VisualEditor](https://www.mediawiki.org/wiki/VisualEditor) plugin
- [Parsoid](https://www.mediawiki.org/wiki/Parsoid) running on NodeJS v4.6.x LTS
- Imagick for thumbnail generation
- Intl for Unicode normalization
- APC as in memory PHP object cache
- Configured with [Short URLs](https://www.mediawiki.org/wiki/Manual:Short_URL)


## Usage

### With MySQL

See Docker Compose [example](https://github.com/kristophjunge/docker-mediawiki/blob/master/example/docker-compose/mysql/docker-compose.yml).

Start a MySQL container.

```
docker run --name=some-mysql \
-e MYSQL_DATABASE=wikidb \
-e MYSQL_USER=wikiuser \
-e MYSQL_PASSWORD=mysecret \
-e MYSQL_RANDOM_ROOT_PASSWORD=1 \
-v /srv/mediawiki/mysql:/var/lib/mysql \
-d mysql:5.7
```

Start MediaWiki container.

```
docker run --name some-wiki \
--link some-mysql:mysql \
-p 8080:80 \
-e MEDIAWIKI_SERVER=http://localhost:8080 \
-e MEDIAWIKI_SITENAME=MyWiki \
-e MEDIAWIKI_LANGUAGE_CODE=en \
-e MEDIAWIKI_DB_TYPE=mysql \
-e MEDIAWIKI_DB_HOST=some-mysql \
-e MEDIAWIKI_DB_PORT=3306 \
-e MEDIAWIKI_DB_NAME=wikidb \
-e MEDIAWIKI_DB_USER=wikiuser \
-e MEDIAWIKI_DB_PASSWORD=mysecret \
-e MEDIAWIKI_ENABLE_UPLOADS=1 \
-v /srv/mediawiki/images:/var/www/mediawiki/images \
-d kristophjunge/mediawiki
```

Create a new database with the install script. Insert username and password for your admin account.

```
$ docker exec -i -t some-wiki /script/install.sh <username> <password>
```

If you are using an existing database run the update script instead.

```
$ docker exec -i -t some-wiki /script/update.sh
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

**Warning**: There is a known issue that VisualEditor currently is not work when using SQLite.

Start MediaWiki container.

```
docker run --name=some-wiki \
-p 8080:80 \
-e MEDIAWIKI_SERVER=http://localhost:8080 \
-e MEDIAWIKI_SITENAME=MyWiki \
-e MEDIAWIKI_LANGUAGE_CODE=en
-e MEDIAWIKI_DB_TYPE=sqlite \
-e MEDIAWIKI_DB_NAME=wikidb \
-e MEDIAWIKI_ENABLE_UPLOADS=1 \
-e MEDIAWIKI_ENABLE_VISUAL_EDITOR=0 \
-v /srv/mediawiki/images:/var/www/mediawiki/images \
-v /srv/mediawiki/data:/data \
-d kristophjunge/mediawiki
```

Create a new database with the install script. Insert username and password for your admin account.

```
$ docker exec -i -t some-wiki /script/install.sh <username> <password>
```

If you are using an existing database run the update script instead.

```
$ docker exec -i -t some-wiki /script/update.sh
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


### HTTPS

To enable HTTPS set the environment variable `MEDIAWIKI_HTTPS` to 1.
When using HTTPS the value of `MEDIAWIKI_SERVER` should start with `https://`.
Don't forget to open a port for HTTPS communication.
Mount your SSL certificate and private key into the container.

```
-p 443:443 \
-e MEDIAWIKI_HTTPS=1 \
-e MEDIAWIKI_SERVER=https://localhost \
-v /srv/mediawiki/ssl/cert.crt:/etc/ssl/crt/cert.crt:ro \
-v /srv/mediawiki/ssl/private.key:/etc/ssl/crt/private.key:ro
```

When `MEDIAWIKI_HTTPS` is set to 1 all requests to HTTP URLs will be redirected to HTTPS to enforce a secure connection.


### Uploads

To enable file uploads set the environment variable `MEDIAWIKI_ENABLE_UPLOADS` to 1.

```
-e MEDIAWIKI_ENABLE_UPLOADS=1
```

Mount a writable volume to the images folder.

```
-v /srv/mediawiki/images:/var/www/mediawiki/images
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
-v ./srv/mediawiki/logo.png:/var/www/mediawiki/resources/assets/wiki.png:ro
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
-v ./srv/mediawiki/skins/MyOtherSkin:/var/www/mediawiki/skins/MyOtherSkin:ro
```


### Extensions

You can add more extensions by mounting them.

```
-v ./srv/mediawiki/extensions/MyOtherExtension:/var/www/mediawiki/extensions/MyOtherExtension:ro
```


### Additional configuration

You can add own PHP configuration values by mounting an additional configuration file that is loaded at the end of the generic configuration file.

```
-v /srv/mediawiki/ExtraLocalSettings.php:/var/www/mediawiki/ExtraLocalSettings.php:ro
```

A good starting point is to copy the file that's inside the container. You can display its content with the following command.

```
$ docker exec -i -t some-wiki cat /var/www/mediawiki/ExtraLocalSettings.php
```


### Configuration file

Beside the docker like configuration with environment variables you still can use your own full `LocalSettings.php` file.

However this will make all environment variables unusable except `MEDIAWIKI_HTTPS` and `MEDIAWIKI_SMTP_SSL_VERIFY_PEER`.

```
-v /srv/mediawiki/LocalSettings.php:/var/www/mediawiki/LocalSettings.php:ro
```


## Configuration reference

Below is a list of all environment variables supported by the container.

When using an own `LocalSettings.php` file according to the section "Configuration file" most variables be unusable.

To modify configuration values that are not listed below read the section "Additional configuration".

More information about the configuration values can be found at MediaWiki's [documentation](https://www.mediawiki.org/wiki/Manual:Configuration_settings).

| Environment Variable | MediaWiki Config | Description |
|---|---|---|
| MEDIAWIKI_HTTPS | - | Enable HTTP, Default 0 |
| MEDIAWIKI_SMTP | - | Enable SMTP mailing, Default 0 |
| MEDIAWIKI_SMTP_SSL_VERIFY_PEER | - | Disable SMTP auth SSL peer verification, Default 0 |
| MEDIAWIKI_DEBUG | - | Enable mediawiki's debug log, Logged to /tmp/wiki-debug.log |
| MEDIAWIKI_SERVER | $wgServer | The primary URL of the server prefixed with protocol |
| MEDIAWIKI_SITENAME | $wgSitename | Name of the wiki |
| MEDIAWIKI_LANGUAGE_CODE | $wgLanguageCode | Language code for wiki language |
| MEDIAWIKI_META_NAMESPACE | $wgMetaNamespace | Namespace, Defaults to MEDIAWIKI_SITENAME |
| MEDIAWIKI_SECRET_KEY | $wgSecretKey | Secret key |
| MEDIAWIKI_UPGRADE_KEY | $wgUpgradeKey | Upgrade key |
| MEDIAWIKI_DB_TYPE | $wgDBtype | Database type, Default is "mysql" |
| MEDIAWIKI_DB_HOST | $wgDBserver | Database host, Default is "127.0.0.1" |
| MEDIAWIKI_DB_PORT | $wgDBserver | Database port, Default is "3306" |
| MEDIAWIKI_DB_NAME | $wgDBname | Database name, Default is "wikidb" |
| MEDIAWIKI_DB_USER | $wgDBuser | Database user, Default is "wikiuser" |
| MEDIAWIKI_DB_PASSWORD | $wgDBpassword | Database password |
| MEDIAWIKI_DB_PREFIX | $wgDBprefix | Database table name prefix |
| MEDIAWIKI_DB_TABLE_OPTIONS | $wgDBTableOptions | Table options |
| MEDIAWIKI_ENABLE_UPLOADS | $wgEnableUploads | Enable file uploads, Default 0 |
| MEDIAWIKI_ENABLE_VISUAL_EDITOR | - | Enable the VisualEditor plugin, Default 1 |
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


## Security

* Nginx and PHP-FPM worker processes run under the `www-data` user with UID 999 and GID 999.
* Parsoid runs under the `parsoid` user.
* Parsoid runs only inside the container. There is no port exposed.
* The MediaWiki files are owned by `root`. Only the `images` folder is owned by `www-data`.
* The Parsoid files are all owned by `root`.


## Known issues

* VisualEditor is currently not working with SQLite (Error: 5 database is locked). However the default editor is working. You can use MEDIAWIKI_ENABLE_VISUAL_EDITOR to disable VisualEditor.
* Sessions are stored in memory via APC and will be lost after container stop.
