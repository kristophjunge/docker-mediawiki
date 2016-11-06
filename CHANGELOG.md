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
