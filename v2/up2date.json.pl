#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk, gtencate, blabla1337 - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.48";
my $beta = "2.49";
my $cool = "2.50";
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

95-11-2018 - v2.50 - Seccubus Alpine
===================================
This release brings new Alpine based docker containers and fixes a compatibility issue with MySQL/MariaDB version 8 and above.

Differences with 2.48

Enhancements
------------
* Seccubus containers are now built based on Alpine
* Minimal specialized docker containers available for front end, api, front end+api, perl and cron

Bug Fixes
---------
* Seccubus rpm's are now also being built for Fedora version 27 and 28
* RPMs for Fedora version 25 depricated
* Fixed building of supporting Centos v7 rpms
* #585 - Added default credentials to the readme file
* #660 - Sudo added to docker images
* #655 - Shell set to /bin/bash for user seccubus
* #662 - Fixing documentation typos
* #673 - PERL5LIB set to /opt/seccubus for seccubus user via debian package

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

