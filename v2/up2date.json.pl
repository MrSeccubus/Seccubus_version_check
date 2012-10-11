#!/usr/bin/perl
# ------------------------------------------------------------------------------
# $Id: getHelp.pl,v 1.4 2009/12/17 15:04:30 frank_breedijk Exp $
# ------------------------------------------------------------------------------
# List the scans
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.0.beta6";
my $beta = "2.0.rc1";
my $cool = "2.0.beta4";
my ( $one, $two, $three) = split /\./, $current;
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
	} elsif ( $version eq $cool ) {
		$data = [ "NOK", "THIS VERSION IS BROKEN, download a newer version!",""];
	} elsif ( $version eq $current ) {
		$data = [ "OK", "Your version $r_version is up to date",""];
	} elsif ( $minor lt $two || ($minor eq $two && $revision lt $three) ) {
		$data = [ "Error","Version $current is available, please upgrade...

Release notes:

11-10-2012 - 2.0.beta6 - The final Beta
=======================================

New features / Issues resolved
------------------------------
* Sourcecode repository is now
[GitHub] (https://github.com/schubergphilis/Seccubus_v2/issues/6) in stead of
SourceForge
* Build is now automated using a Jenkins server at Schuberg Philis including
  the creation of RPMs and Debian packages via OpenSuse build services
* Fixed a few bugs

Bigs fixed (tickets closed):
----------------------------
* #7  - Import error on scan results from OpenVAS 3.0.1
* #7  - Error converting OpenVAS .nbe to IVIL
* #11 - ConfigTest is more verbose when it fails due to a missing config file
* #12 - Installation error with tarball
* #15 - Ungroup Compliance Scans
* #16 - More gracefull error handling when Nikto doesn't find a config
* #17 - File ~/scanners/Nikto/scan has no execute permission
* ##  - Fixed a broken symlink in the development environment
* #23 - Nessus xmlRPC port can now be selected
* #25 - Fixed tarball installation error
* #29 - JMVC framework updated to version 3.2.2

",
"https://github.com/schubergphilis/Seccubus_v2/downloads",""];
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

