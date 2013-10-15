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

my $current = "2.2";
my $beta = "2.3";
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
	} elsif ( $version eq $cool ) {
		$data = [ "OK", "You are using the first non-beta version of Seccubus 2.0 released at the Alt-S conference on 22-1-2013",""];
	} elsif ( $version eq $current ) {
		$data = [ "OK", "Your version $r_version is up to date",""];
	} elsif ( $minor lt $two || ($minor eq $two && $revision lt $three) ) {
		$data = [ "Error","Version $current is available, please upgrade..." . '

Release notes:

Seccubus V2 Change Log
======================
Seccubus automates regular vulnerability scans with vrious tools and aids
security people in the fast analysis of its output, both on the first scan and
on repeated scans.

On repeated scan delta reporting ensures that findings only need to be judged
when they first appear in the scan results or when their output changes.

Seccubus 2.0 is marks the end of the beta phase for the 2.0 branch.
This code is the only actively developed and maintained branch and all support
for Seccubus V1 has officially been dropped.

Seccubus V2 works with the following scanners:
* Nessus 4.x and 5.x (professional and home feed)
* OpenVAS
* Nikto
* NMap
* SSLyze

For more information visit [www.seccubus.com]

15-10-2013 - 2.2 - Nessus 5.2.1, unicode and performance
========================================================

Key new features / issues resolved
----------------------------------
* Major performance increase by moving processing of sttus buttons and filters to backend
* Resolved an issue that cause incomptibility with Nessus API version 5.2.1 (Thanks Trelor)
* Resolved an issue around encoding of Unicode chracters in Nessus output
* Added shell script to execute crontab job only on a certain day
* Added shell script to execute crontab job only on a weeknumber that can be devided by a certain number
* Correct application of Apache license is now part of the unit tests
* Resolved some caching issues with IE

Bigs fixed (tickets closed):
----------------------------
* Issue #48 - Filters need to be processed in backend, not front end
* Issue #50 - Notification table not displayed on edit scan
* Issue #56 - IVIL conversion shell call needs qoutes around filename
* Issue #64 - New scan dialog shows \'new workspace\' in title
* Issue #65 - Each CGI response header now invalidates caching
* Issue #66 - Username field too small
* Issue #72 - Apache license isn\'t applied correctly
* Issue #75 - Typo: datatbase in ConfigTest.pl
* Issue #77 - Seccubus incompatible with Nessus API 5.2.1
* Issue #78 - Unicode in nessus file breaks ivil import
* Issue #86 - getFilters API
* Updated dependancies in RPM
* Fixed some minor DB error scripts
',
"http://seccubus.com/seccubus/download/146-seccubus-21-bugfix-release",""];
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

