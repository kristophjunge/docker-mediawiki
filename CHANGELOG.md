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
