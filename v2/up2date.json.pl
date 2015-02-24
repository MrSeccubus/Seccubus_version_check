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

my $current = "2.14";
my $beta = "2.15";
my $cool = "2.none";
my ( $one, $two, $three) = split /\./, $current;
$three = 'ZZZ' unless $three;
my $data = [];
my $json = JSON->new();

my $query = CGI::new();

print $query->header("application/json");

my $version = $query->param("version");
my $r_version = $version;
$version =~ s/\.B\d+//;

if ( ! $version ) {
	$data = [ "Error","No version specified", "http://seccubus.com"];
} else {

	my ($major, $minor, $revision) = split /\./, $version;

	if ($major < $one ) {
		$data = [ "Error", "This check only supports version 2.x.x","" ] ;
	} elsif ( $version == $cool ) {
		$data = [ "OK", "You are using the first non-beta version of Seccubus 2.0 released at the Alt-S conference on 22-1-2013",""];
	} elsif ( $version == $current ) {
		$data = [ "OK", "Your version $r_version is up to date",""];
	} elsif ( $minor < $two || ($minor == $two && $revision < $three) ) {
		$data = [ "Error","Version $current is available, please upgrade..." . qq{

Release notes
=============

24-02-2015 - 2.14 - SSL labs API
================================
The SSL labs scanner now uses the SSL labs API (see https://github.com/ssllabs/ssllabs-scan/blob/master/ssllabs-api-docs.md) to check the SSL configuration of your website in stead of scraping the site.

Bug Fixes
=========
* No additional bugfixes
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

