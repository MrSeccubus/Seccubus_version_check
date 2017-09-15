#!/usr/bin/perl
# ------------------------------------------------------------------------------
# $Id: getHelp.pl,v 1.4 2009/12/17 15:04:30 frank_breedijk Exp $
# ------------------------------------------------------------------------------
# List the scans
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk, gtencate, blabla1337 - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.40";
my $beta = "2.41";
my $cool = "2.42";
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

15-9-2017 - v2.40 - Fixes and improvements
==========================================

This release mainly fixes installation issues on Debian and issue in docker that are due to the PERL5LIB path
that doesn't include the current directory anymore.
It also fixes the issue where people were unable to connect to a Nessus instance with a self signed certificate
that was trigged by altered behaviour of a perl library.
I've also fixed and tweaked the user interface a bit.


Enhancements
------------
# #539 - Status tab will become the default instead of the login tab if there is a config issue


Bug Fixes
---------
* #499 - Status change buttons in findings grid not working
* #529 - No all buttons were working correctly when working with linked issues
* #536 - Seccubus did not install on debian because openssl passphrase was too short (also effected docker container)
* #534 - Fixed an error that prevented connections to a Nessus instance with a self signed certificate on certain OSes
* #542 - Docker broken
* #548 - Notifications editor did not work correctly
* #549 - Deleting notifications did not work correctly
* #559 - PERL5LIB path was not set in cron container
* #563 - Removed some dedug output
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

