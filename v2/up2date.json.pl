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

my $current = "2.36";
my $beta = "2.37";
my $cool = "2.38";
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

29-6-2017 - v2.36 - TestSSL.sh release
======================================

This release has been in the making for a long time. In fact the first pull
request for it's main feature was back in June 2016 by our friend and then
colleague Glenn ten Cate.

This release marks the integration of Dirk Wetter's excellent tool testssl.sh
into Seccubus. With testssl.sh you can get a detailed overview of how well
your TLS enabled service is set up. Not just for websites, but for any TCP
service, even those that use STARTTLS.

In addition we introduced the --cdn switch for ssllabs, to reduce noise for
CDN enabled sites, we the ability to dynamically create users via JIT
provisionsing and we added CSRF protection for enhanced security.

To boost future code quality, Perl::Critic testing has been integrated in the
unit testing process.

Besides that we squased some bugs, five of which got introduced in the previous release :(

Enhancements
------------
#302 - Testssl.sh support for Seccubus
#401 - JIT provisioning of users
#442 - Add --cdn option to ssllabs
* Perl Critic is now part of unit testing. All critique was handled

Bug Fixes
---------
* #132 - We have CSRF protection now. Non-get requests should have content-type application/json.
* #461 - Update button on finding edit screen isn't working properly
* #474 - Some typo/style fixes by Jericho (attrition.org)
* #478 - Conralive should check if cron isn't ignored
* #480 - Editing/showing notifications broken
* #483 - add_user broken
* #484 - Failure to update 1+n scan configuration in Manage Scans (And all other update funtions)
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

