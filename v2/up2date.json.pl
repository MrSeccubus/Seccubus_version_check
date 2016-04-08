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

my $current = "2.22";
my $beta = "2.23";
my $cool = "2.24";
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

8-4-2016 - Seccubus v2.22 - OpenVAS integration fixed
=====================================================

OpenVAS integration has been a freebee for a while, until OpenVAS and Nessus split their respective interfaces.
Seccubus' OpenVAS OMP integration has never been super stable, but it is now, and it doesn't depend on the omp 
command line utility anymore.
Furthermore two critical bug where fixed and the release process got a major overhaul.

As usual you can download it [here](https://github.com/schubergphilis/Seccubus_v2/releases)

Enhancements
------------
* Improved the release process (see [https://www.seccubus.com/documentation/22-releasing/])
* #308 - Rewrote the OpenVAS scan script with the following objectives:

  - Remove dependancy on the omp utility (because I don't have it on my Mac for starters)
  - XML parsing is now done with XML::Simple in stead of manually (which is fragile)
  - Better error handling


Bug Fixes
---------
* #289 - Online version test needs a unit test
* #269 - Correct handling of multiple address nodes in NMap XML
* #298 - OpenVAS6: fix scan and import to ivil 
* #297 - Port field abused to store port state
* #307 - OpenVAS integration was broken
},
"https://github.com/schubergphilis/Seccubus_v2/releases",""];
	} elsif ( $version eq $beta ) {
		$data = ["OK", "Your version ($r_version) is the trunk version ($version) of Seccubus, proceed at your own risk",""];
	} else {
		$data = ["Error","Unrecognized version: $version, current is $current","http://seccubus.com"];
	}
}

print $json->pretty->encode( [ {
	'status'	=> $$data[0],
	'message'	=> $$data[1],
	'link'		=> $$data[2],
} ] );

