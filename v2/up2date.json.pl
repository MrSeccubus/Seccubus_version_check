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

my $current = "2.38";
my $beta = "2.39";
my $cool = "2.40";
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

2-8-2017 - v2.38 - Various fixes and improvements
=================================================

We've fixed various bug and implemented some enhancements in this version.

Enhancements
------------
* #421 - Implemented a scoring system for SSLlabs findings
* #464 - Scan objects in Nessus are now reused in stead of created from scratch
* #500 - Added --cdn switch to testssl.sh too
* #504 - Changed container crontab shell for sh to bash
* #506 - Allow cron email to be sent externally
* #512 - New ssllabs finding httpForwarding
* #522 - You can now configure which formats get exported from nessus

Bug Fixes
* #490 - --cdn switch doesn't work as expected
* #491 - Help message of load_ivil didn't align nicely
* #492 - Finding history wasn't showing in the GUI
* #494 - Prototype mismatch warning in Nessus scanner
* #502 - Incorrect path set when using CRON in a container
* #507 - It is not longer possible to add duplicate users
* #522 - Nessus scans now get correctly recycled or created
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

