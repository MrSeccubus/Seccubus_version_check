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

my $current = "2.16";
my $beta = "2.17";
my $cool = "-2.0";
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
		$data = [ "OK", "You are using the first non-beta version of Seccubus 2.0 released at the Alt-S conference on 22-1-2013",""];
	} elsif ( $version == $current ) {
		$data = [ "OK", "Your version $r_version is up to date",""];
	} elsif ( $minor < $two || ($minor == $two && $revision < $three) ) {
		$data = [ "Error","Version $current is available, please upgrade..." . q{

Release notes
17-09-2015 - 2.17 - GNU Terry Pratchett (Fixed!)
================================================
The bonanza of after summer fixes and small enhancements continues
Our dear contributor @Ar0xa notified us of a bug in v2.16 which has been fixed in this release
See bug #260

Enhancements
------------
* #185 - GNU Terry Pratchett
* #214 - NMap, include port status in port number
* #223 - Make the Bulk Update feature much faster in the GUI
* #228 - SSL Labs: Warn if MaxAge is below the recommended 180 days
* #226 - Create Travis Unit tests for DB upgrade
* #241 - Unit tests for delta engine
* Moved to new Travis build infra. See: http://docs.travis-ci.com/user/migrating-from-legacy/

Bug Fixes
---------
* #180 - NMAP script output ignored
* #186 - Custom SQL table is missing from DB init scripts
* #198 - Unable to add more then 1 asset
* #199 - asset_host broken in v6 and upgrade problems
* #200: Error using ZAP remote
* Fixed ZAP file handling issue
* Fixed a new found bug in ivil2zap, more output now in findings
* Fixed SSLlabs error exception
* #213 - .spec file still references v4 data structures instead of v6
* #222 - SSL Labs: hasSct and sessionTickets findings not saved in IVIL file
* #224 - Bulk Update controller not updated after update of remark only
* #236 - Database upgrades inconsistent
* #243 - do-scan -q is not very quiet
* #247 - SSLLabs: certain values for PoodleTLS not handled
* #248 - SSLLabs Reneg finding empty is reneg is not supported 
* Copyright related unit tests now work on Travis CI too
* #252 - scannerparam column in scans table too small
* #255 - Incorrect use of CGI.pm may cause parameter injection vulnerability
* #260 - Runs not showing in Seccubus v2.16
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

