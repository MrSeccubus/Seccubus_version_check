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

my $current = "2.12";
my $beta = "2.13";
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

Release notes:
==============
Thanks for this release goes to Alexey Smirnoff (@Arkanoi) and his employer Parallels Inc.

Alexey whipped together the Nessus 6 compatibility, fixed issues with the Qualys SSLlabs scanner.
Further more his employer Parallels Inc. sponsored the development of the asset management and custom
SQL feature.

28-12-2014 - 2.11 - Nessus 6 compatibility, assets, custom SQL and more
06-01-2015 - 2.12 - Fixes database error in 2.11
======================================
* Nessus 6 compatibility release. Tennable decided to change the Nessus API between
versions 5 and 6, therefore the Nessus plugin did not work correctly with version 6
anymore. Alexey Smirnoff was kind enough to provide a new Nessus6 scanner plugin that
supports the new Nessus API.
* Added asset management and the ability to execute custom SQL to Seccubus
* Added indexes to findings (host,port,plugin) to speed up large DB queries

Bug Fixes
============================================
* #140 - Nessus 6 integration
* #141 - Multiple issues with Qualys SSLlabs scanner
* #144 - Perl-CGI is bundled with perl 5.8 rpm's so no need to bundle it
* #152 - Pull request for Asset management
* #159 - It was impossible to launch scan with policy that lacks template UUID
* #165 - Field password is missing from table scans
},
"https://www.seccubus.com/seccubus-v2-12/",""];
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

