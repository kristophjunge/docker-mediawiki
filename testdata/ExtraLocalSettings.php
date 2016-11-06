<?php

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
    exit;
}

$wgSitename = "MyWikiOverride";

$wgEnotifUserTalk = false;
$wgEnotifWatchlist = false;
$wgEmailAuthentication = true;

$wgUseInstantCommons = false;

$wgAuthenticationTokenVersion = "1";

$wgGroupPermissions['*']['createaccount'] = false;
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['read'] = false;
