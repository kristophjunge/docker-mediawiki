## 0.1.0 (2016-10-05)

* Initial version

## 0.2.0 (2016-10-06)

* Changed environment variable prefix `WIKI_` to `MEDIAWIKI_`.
* Removed all custom configuration defaults. All MediaWiki default values will be used.
* Added SQLite support
* Changed usage information to plain docker commands and added docker-compose example files.
* Added a configuration variable to enable/disable the VisualEditor plugin.
* Removed skin download from `Dockerfile` since the skins are already contained in MediaWiki releases.
