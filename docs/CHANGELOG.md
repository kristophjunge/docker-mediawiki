## 2018-02-01 1.29.0-2

* Introduced dynamic detection of media wiki extension release file names. Removed build arguments MEDIAWIKI_VERSION, EXTENSION_VISUALEDITOR_VERSION, EXTENSION_USERMERGE_VERSION. Added build arguments MEDIAWIKI_VERSION_MINOR, MEDIAWIKI_VERSION_BUGFIX. 
* Fixed PEAR and nginx installation after PHP base image changes. Removed build argument NGINX_VERSION.
* \#7 Added a link to the official docker documentation.
* Removed remaining occurrences of known issue that VisualEditor is not working with SQLite.
* Added environment variables PHPFPM_WORKERS_START, PHPFPM_WORKERS_MIN, PHPFPM_WORKERS_MAX, PARSOID_WORKERS. Default number of Parsoid and PHP-FPM workers is now 1.
* Added security info that signatures are checked during installation.
* \#9 Fixed usage of MEDIAWIKI_DB_PREFIX. Removed invalid information from README.md about default values of MEDIAWIKI_DB_* environment variables.
* Added .env file to .dockerignore to exclude it from local builds.
* Updated development environment docker-compose.yml with opened MySQL port and all ports opened only on local interface.
* \#10 Fixed privileges of images folder.
* Removed unused old Parsoid installation routine
* \#14 Included mime types in nginx configs.
* \#18 Made parsing of MEDIAWIKI_FILE_EXTENSIONS independent of spaces. Added more documentation regarding uploads.
* Moved CHANGELOG.md and CONTRIBUTORS.md to docs folder. Created CONTRIBUTING.md. Added links to README.md.
* Added ToC to README.md.

## 2017-08-13 1.29.0-1

* Updated to MediaWiki 1.29.0.
* Switched downloads to CURL instead of Docker ADD since it now extracts downloaded archives.
* Added container_name property to docker-compose example files.
* Switched docker-compose example port from 8080 to 80.
* Removed known issue that VisualEditor is not working with SQLite.

## 2017-06-17 1.28.2-1

* Updated to MediaWiki 1.28.2.
* Added GPG signature check of downloaded MediaWiki release.
* Moved docker entry point from /script/docker-entry.sh to /docker-entrypoint.sh to be more convenient.
* Configured docker entry point with ENTRYPOINT instead of CMD to cleanly override the parent image.

## 2017-02-06 1.28.0-7

* Changed default session storage to database instead of in-memory when using mysql.

## 2016-12-17 1.28.0-6

* Added dbuser and dbpass arguments to install script.

## 2016-12-17 1.28.0-5

* Set PHP base image version to 7.0 instead of 7 since used imagick version is not compatible with PHP 7.1.
* Introduced new naming convention for plugin related variables MEDIAWIKI_EXTENSION_*.
* Added UserMerge plugin, configurable via MEDIAWIKI_EXTENSION_USER_MERGE_ENABLED.

## 2016-12-10 1.28.0-4

* Updated logic for MEDIAWIKI_SMTP_SSL_VERIFY_PEER workaround since MediaWiki 1.28 now uses different PEAR mail code.

## 2016-12-10 1.28.0-3

* Updated VisualEditor to the latest version (REL1_28-93528b7)
* Updated Parsoid installation routine to match the latest version (0.6.1)

## 2016-12-09 1.28.0-2

* Updated to MediaWiki 1.28.0 stable (rc.0 before)
* Added missing environment variable (MEDIAWIKI_SMTP) forward to PHP-FPM config

## 2016-11-06 1.28.0-1

* Updated to MediaWiki 1.28.0

## 2016-11-06 1.27.1-3

* Moved images mount point to /images
* Created global docker entry script
* Added support for max upload file size configuration
* Fixed docker-compose examples
* Added readme section 'Extending this image'

## 2016-10-23 1.27.1-2

* Changed environment variable prefix `WIKI_` to `MEDIAWIKI_`.
* Removed all custom configuration defaults. All MediaWiki default values will be used.
* Added SQLite support
* Changed usage information to plain docker commands and added docker-compose example files.
* Added a configuration variable to enable/disable the VisualEditor plugin.
* Removed skin download from `Dockerfile` since the skins are already contained in MediaWiki releases.

## 2016-10-05 1.27.1-1

* Initial version
