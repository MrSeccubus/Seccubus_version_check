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

my $current = "2.28";
my $beta = "2.29";
my $cool = "2.30";
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

For my work at Schuberg Philis we wanted to run Seccubus in Docker 
containers. This and inspiration from Karl Newell (see https://hub.docker.com/r/karlnewell/seccubus/) 
caused me to add a Dockerfile (and some other files) to Seccubus so that Seccubus can now be 
run in a docker container. 

In addition I fixed a couple of bugs and changed the ssllabs scanner so it now uses the v3 API endpoint.

Enhancements
------------
* #361 - arkenoi created a netsparker2ivil tool that allows you to manually import Netsparker scans
* #331 - Now using SSLLabs API v3
* #386 - New SSL labs API output featues incorporporated
* #389 - API endpoint URL has moved to a single function so it can be patched if deployed in a 
         three tier architecture
* #392 - Alternative handling of the updateFIndings.pl API
* #397 - Allow seccubus to authenticate via an http request header
* #399 - Create a Docker container for Seccubus

Bug Fixes
---------
* #364 - auto_gen column was missing from asset_host table
* #358 - Could not get findings when an asset was used for the query
* #360 - Not able to export report in PDF format - This breaks the scan
* #336 - Non-critical RPM errors on CentOS 5
* #376 - Removed 50 host limit in filters as it was counterproductive
* #374 - Fixed Nikto path detection code
* #377 - Hostname filter wasn't working correctly, typed Hostname iso HostName
* #385 - SSLlabs failed because cypher preference order was split out per protocol by SSLlabs now.
* #394 - SSLlabs scanner failed if all enpoints fail and --gradeonly was used
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

