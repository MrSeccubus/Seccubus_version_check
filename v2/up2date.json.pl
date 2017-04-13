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

my $current = "2.30";
my $beta = "2.31";
my $cool = "2.32";
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

One of the things that has been lacking for a while were proper workspace export and import tools. This release adds them and fixes another issue that has been on our whishlist for long, better handling of gone findings reappearing.

Now when a finding that was previously marked as gone reappears in a scan the 'status before gone' is taken into account.

When the 'status before gone' was:
* New - The finding will reappear as new
* Changed - The finding will reappear as changed
* Open - The finding will reappear as open, unless the finding text has changed, then it will reappear as changed
* No issue - The finding wil reappear as no issue, unless the finding text has changed, then it will reappear as changed
* MASKED - The finding will stay MASKED

Enhancements
------------
* #126 - Delta engine improved: Beter recovery from GONE findings
* #257 - Import/export tools added
* #408 - Seccubus now refuses to load an ivil file with 0 findings
* #412 - Disabled tofu to enhance Docker support
* #419 - Enable crontab support in docker images
* #423 - Show futureGrade in SSLlabs scan results

Bug Fixes
---------
* #403 - SSLlabs scanner help file was not up to date
* #414 - Mkdir error will no longer appear if entrypoint.sh is run twice
* #426 - Corrections to README.md from Karol Kozakowski merged
* #432 - StaticPkpPolicy not recognized
},
"https://github.com/schubergphilis/Seccubus_v2/releases",""];
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

