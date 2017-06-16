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

my $current = "2.34";
my $beta = "2.35";
my $cool = "2.36";
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

15-6-2017 - v2.34 - Backend rewritten in Mojolicious
=====================================================

The Seccubusd backend has been REST-ish ever since release v2.0. This web backend was implemented
via Perl CGI scripts (yes, using CGI.pm). Needless to say something needed to change.

This backend rewrite has been in the making for some time now and we are finally ready to release
it into the wild.

What are the major changes?
* Backend rewritten in [Mojolicious](http://mojolicious.org/)
* Backend API is now REST compliant and located at /api
* There is no need to run an external webserver for Seccubus, it is built into Mojolicious
* Seccubus now has built in user authentication (Defaqult admin password is 'GiveMeVulns!')
* Fixed a lot off old issues
* Unfortunately there is no solid Mojolicious v6/v7 rpms for RedHat/Centos, so we can no longer provide RPMs for those operating systems

Enhancements
------------
* #411 - Ported the backend to Mojolicious and pure REST
* #448 - Allow import and export utility to read config from specific file

Bug Fixes
---------
* Fixed a weird sorting bug when using Chrome
* #138 - Can't locate SeccubusV2.pm in @INC (you may need to install the SeccubusV2 module)
* #143 - Make RPM so that nginx is supported too
* #171 - column formatting in custom SQL is off
* #190 - XSS in custom SQL query
* #193 - RFE: please add a logout button for additional security
* #263 - SeccubusHelpers.pm contains two unused functions
* #363 - API calls for asset use workspace iso of workspaceId which is the standard
* #384 - Missing SMTP server config should be warning, not error
* #396 - ConfigTest should return non 200 if config is not ok
* #417 - Docker container is not https-enabled by default
* #418 - Docker images lacks proper data management
* #430 - Set correct paths for perl and nikto so that do-scan and nikto can now be run by any user
* #445 - RPM errors
* #457 - Mine attachment not sent correctly
* #465 - JSON::false returns "false" on certain platforms
* #466 - /api/version should not be an authenticated call
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

