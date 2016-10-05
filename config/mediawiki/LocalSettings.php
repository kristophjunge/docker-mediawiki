<?php

// @see https://www.mediawiki.org/wiki/Manual:Configuration_settings

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
    exit;
}

if (getenv('WIKI_SITENAME') == '') {
    throw new Exception('Missing environment variable WIKI_SITENAME');
} else {
    $wgSitename = getenv('WIKI_SITENAME');
}

if (getenv('WIKI_META_NAMESPACE') != '') {
    $wgMetaNamespace = getenv('WIKI_META_NAMESPACE');
}

# Short URLs
$wgScriptPath = "";
$wgArticlePath = "/$1";
$wgUsePathInfo = true;
$wgScriptExtension = ".php";

if (getenv('WIKI_SERVER') == '') {
    throw new Exception('Missing environment variable WIKI_SERVER');
} else {
    $wgServer = getenv('WIKI_SERVER');
}

$wgResourceBasePath = $wgScriptPath;

$wgLogo = "$wgResourceBasePath/resources/assets/wiki.png";

if (getenv('WIKI_EMERGENCY_CONTACT') != '') {
    $wgEmergencyContact = getenv('WIKI_EMERGENCY_CONTACT');
}

if (getenv('WIKI_PASSWORD_SENDER') != '') {
    $wgPasswordSender = getenv('WIKI_PASSWORD_SENDER');
}

$wgEnotifUserTalk = false;
$wgEnotifWatchlist = false;
$wgEmailAuthentication = true;

$wgDBtype = "mysql";
if (getenv('WIKI_DB_TYPE') != '') {
    $wgDBtype = getenv('WIKI_DB_TYPE');
}

$hostname = ((getenv('WIKI_DB_HOST') != '') ? getenv('WIKI_DB_HOST') : '127.0.0.1');
$port = ((getenv('WIKI_DB_PORT') != '') ? getenv('WIKI_DB_PORT') : '3306');
$wgDBserver = $hostname.':'.$port;

unset($hostname, $port);

$wgDBname = "wikidb";
if (getenv('WIKI_DB_NAME') != '') {
    $wgDBname = getenv('WIKI_DB_NAME');
}

$wgDBuser = "wikiuser";
if (getenv('WIKI_DB_USER') != '') {
    $wgDBuser = getenv('WIKI_DB_USER');
}

if (getenv('WIKI_DB_PASSWORD') != '') {
    $wgDBpassword = getenv('WIKI_DB_PASSWORD');
}

# MySQL specific settings
if (getenv('WIKI_DB_PREFIX') != '') {
    $wgDBprefix = getenv('WIKI_DB_PREFIX');
}

if (getenv('WIKI_DB_TABLE_OPTIONS') != '') {
    $wgDBTableOptions = getenv('WIKI_DB_TABLE_OPTIONS');
}

$wgDBmysql5 = false;

$wgMainCacheType = CACHE_ACCEL;
$wgMemCachedServers = [];

$wgEnableUploads = false;
if (getenv('WIKI_ENABLE_UPLOADS') == '1') {
    $wgEnableUploads = true;
}

if (getenv('WIKI_FILE_EXTENSIONS') != '') {
    foreach (explode(', ', getenv('WIKI_FILE_EXTENSIONS')) as $extension) {
        $wgFileExtensions[] = trim($extension);
    }
}

$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";
$wgUseInstantCommons = false;
$wgShellLocale = "C.UTF-8";

if (getenv('WIKI_LANGUAGE_CODE') != '') {
    $wgLanguageCode = getenv('WIKI_LANGUAGE_CODE');
}

if (getenv('WIKI_SECRET_KEY') == '') {
    throw new Exception('Missing environment variable WIKI_SECRET_KEY');
} else {
    $wgSecretKey = getenv('WIKI_SECRET_KEY');
}

if (getenv('WIKI_UPGRADE_KEY') != '') {
    $wgUpgradeKey = getenv('WIKI_UPGRADE_KEY');
}

$wgAuthenticationTokenVersion = "1";

$wgDiff3 = "/usr/bin/diff3";

$wgGroupPermissions['*']['createaccount'] = false;
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['read'] = false;

$wgDefaultSkin = "vector";
if (getenv('WIKI_DEFAULT_SKIN') != '') {
    $wgDefaultSkin = getenv('WIKI_DEFAULT_SKIN');
}

# Enabled skins
wfLoadSkin( 'CologneBlue' );
wfLoadSkin( 'Modern' );
wfLoadSkin( 'MonoBook' );
wfLoadSkin( 'Vector' );

# Debug
if (getenv('WIKI_DEBUG') == '1') {
    $wgShowExceptionDetails = true;
    $wgShowSQLErrors = true;
    $wgDebugDumpSql = true;
    $wgDebugLogFile = "/tmp/wiki-debug.log";
}

# SMTP E-Mail
if (getenv('WIKI_SMTP') == '1') {
    $wgEnableEmail = true;
    $wgEnableUserEmail = true;
    $wgSMTP = array(
        'host'     => getenv('WIKI_SMTP_HOST'), // could also be an IP address. Where the SMTP server is located
        'IDHost'   => getenv('WIKI_SMTP_IDHOST'), // Generally this will be the domain name of your website (aka mywiki.org)
        'port'     => getenv('WIKI_SMTP_PORT'), // Port to use when connecting to the SMTP server
        'auth'     => (getenv('WIKI_SMTP_AUTH') == '1'), // Should we use SMTP authentication (true or false)
        'username' => getenv('WIKI_SMTP_USERNAME'), // Username to use for SMTP authentication (if being used)
        'password' => getenv('WIKI_SMTP_PASSWORD') // Password to use for SMTP authentication (if being used)
    );
}

# VisualEditor
wfLoadExtension( 'VisualEditor' );
$wgDefaultUserOptions['visualeditor-enable'] = 1;
$wgVirtualRestConfig['modules']['parsoid'] = array(
  'url' => 'http://localhost:8142',
  'domain' => 'localhost',
  'prefix' => ''
);
$wgSessionsInObjectCache = true;
$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;

# Load extra settings
require 'ExtraLocalSettings.php';
