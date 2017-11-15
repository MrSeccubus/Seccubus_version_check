#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk, gtencate, blabla1337 - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.44";
my $beta = "2.45";
my $cool = "2.46";
my ( $one, $two, $three) = split /\./, $current;
$three = 'ZZZ' unless $three;
my $data = [];
my $json = JSON->new();

my $query = CGI::new();

print $query->header("application/json");

my $version = $query->param("version");
$version = $ARGV[0] unless $version;
my $r_version = $version;
$version =~ s/\.B\d+//;

if ( ! $version ) {
	$data = [ "Error","No version specified", "http://seccubus.com"];
} else {

	my ($major, $minor, $revision) = split /\./, $version;

	if ($major < $one ) {
		$data = [ "Error", "This check only supports version 2.x.x","" ] ;
	} elsif ( $version == $cool ) {
		$data = [ "OK", "You are using the newest version of Seccubus. This version check will be updated soon",""];
	} elsif ( $version == $current ) {
		$data = [ "OK", "Your version $r_version is up to date",""];
	} elsif ( $minor < $two || ($minor == $two && $revision < $three) ) {
		$data = [ "Error","Version $current is available, please upgrade..." . q{

Release notes

15-11-2017 - v2.44 - PackageCloud release
=========================================
This release cleans up technical debt. Package building has been moved from OpenSuse Build Services to CicleCI
and packages now automatically are uploade to [our PackageCloud repositories](https://packagecloud.io/seccubus/).
Here you will find two repositories:
* [Latest](https://packagecloud.io/seccubus/latest) - Follows the latest code that gets merged into the master branch
* [Releases](https://packagecloud.io/seccubus/releases) - Follows the regular releases

You can configure these repositories on your operating system to include Seccubus upgrades in your regular package updates.

Enhancements
------------
* #597 - do-scan and import ivil now log to syslog
* #605 - Container scan command allows scans to only starts on a certain weekday
* Fedora, Ubuntu and Debian package building has been moved to CircleCI
* Packages are automatically uploaded to [packagecloud.io](https://packagecloud.io/seccubus/)


Bug Fixes
---------
* #593 - Fixed incorrect parsing of the values for poodleTls finding in SSLlabs.
* #595 - Fixed incorrect parsing of the values for Ticketbleed finding in SSLlabs.

},
"https://github.com/schubergphilis/Seccubus/releases/latest",""];
	} elsif ( $version eq $beta ) {
		$data = ["OK", "Your version ($r_version) is the active development version ($version) of Seccubus, it includes the latest features but may include the latest artifacts as well ;)",""];
	} else {
		$data = ["Error","Unrecognized version: $version, current is $current","http://seccubus.com"];
	}
}

print $json->pretty->encode( [ {
	'status'	=> $$data[0],
	'message'	=> $$data[1],
	'link'		=> $$data[2],
} ] );

