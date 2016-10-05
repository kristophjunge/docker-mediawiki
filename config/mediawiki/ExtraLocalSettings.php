<?php

// @see https://www.mediawiki.org/wiki/Manual:Configuration_settings

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
    exit;
}

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
#$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
#$wgRightsUrl = "";
#$wgRightsText = "";
#$wgRightsIcon = "";

## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

// OPTIONAL: Enable VisualEditor's experimental code features
#$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;
