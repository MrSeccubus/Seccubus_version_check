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

my $current = "2.26";
my $beta = "2.27";
my $cool = "2.28";
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

12-7-2016 - 2.26 - Speed improvements and a whole log of bugfixes
=================================================================
This release is especially interesting for those of you that are working with large result sets.
The number of findigns that is returned is now limited to 200 results by default and can be adjusted
up or down.
A lot of the filter logic has been moved from the Perl backend to more intelligent database queries 
where caching and other optimalisations techniques prevent timeouts when working with larger result
sets.

Additional improvements are done the rpm packaging and the Nessus6 scanner wich now no longer depends
on certain excotic perl modules.

The number of change records that is created and displayed has been reduced and some other more minor 
have been fixed too.

Enhancements
------------
* #128 - Limit the amount of findings that is returned from the back end 
* #312 - SSLLabs and Nessus6 scanner no longer depend on perl-REST-Client
* #319 - RPM now builds and installs under CentOs/RHEL 5 too
* #320 - Nessus6 scanner now downloads PDF and HTML version of report too
* #322 - Removed old scanners: Nessus v5 and earlier, OpenVAS v5 and earlier
* Improved exit codes for the onlyonxday.sh utility

Bug Fixes
---------
* #344 - Nessus6 scanner script using LWP::UserAgent is too brittle
* #330 - Add perl-LWP-Protocol-https as RPM dependency
* #328 - CopyRight year unit test appears to be broken on Travis
* #327 - OpenVAS target is always created with the default portlist
* #323 - Non-critical warnings in unit tests fixed
* #333 - LWP::UserAgent is missing method delete on RH5 and RH6
* #305 - Finding change records are generated even if a finding did not actually change
* #300 - Editing an issue and updating the severity doesn't work
* #295 - Trigger in notification edit will fall back to previous on re-edit
* #277 - Remove redundant documentation from source tree
* #183 - SSL validation ingore not corretly implemented
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

