#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk, gtencate, blabla1337 - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.42";
my $beta = "2.43";
my $cool = "2.44";
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

20-10-2017 - v2.42 - Kali, Certificate validation and State Engine
==================================================================
Three major improvements in this release:

* It fixes a big issue with the validation of SSL certificates. Certificate validation was cot correctly turned off in the Nessus scanner when an internal scanner is used
* Debian packages now work on Debian, Ubuntu and Kali
* The state engine still had a bug when findings needed to recover from the Gone status


Enhancements
------------
* Unit testing moved from Circle CI v1.0 to CircleCI v2.0 to increase testing speed
* Now also building .deb file on Circle CI and testing them against debian v8 and v9, Ubuntu and Kali Linux


Bug Fixes
---------
* #580 - --cdn option did not add IPs to finding if findings were not consitent across endpoints
* #572 - Issues with disabling SSL verification in Nessus
* #571 - @SHoekstra fixed: testssl scan fails on docker because hexdump is not installed
* #563 - Fixed an issue with picking the wrong color for notes (Severity 4)
* #533 - Installation of .deb package on Kali failed (Thanks @rhertzog)
* #509 - Fixed a bug in the state engine, causing incorrect recovery from gone when an issue was previously closed
* Fixed an issue where duplicate asset_hosts were created on certain platforms (e.g. docker)
* Fixed an issue in how filters were composed if
* Removed debug output from entrypoint.sh
* Fixed git complaining about unrelated histories

15-9-2017 - v2.40 - Fixes and improvements
==========================================

This release mainly fixes installation issues on Debian and issue in docker that are due to the PERL5LIB path
that doesn't include the current directory anymore.
It also fixes the issue where people were unable to connect to a Nessus instance with a self signed certificate
that was trigged by altered behaviour of a perl library.
I've also fixed and tweaked the user interface a bit.
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

