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

my $current = "2.0";
my $beta = "2.1.rc1";
my $cool = "2.0.99";
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
		$data = [ "Error","Version $current is available, please upgrade...

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

22-01-2012 - 2.0 - The Alt-S version
====================================

Key new features / issues resolved
----------------------------------
* Email notifications when a scan starts and a scan ends
* Scan create and edit dialog now display default parameters
* do-scan now has a --no-delete option to preserve temporary files
* SSLyze support

Bigs fixed (tickets closed):
----------------------------
* Issue #9 - Missing Hosts File in Nmap Scan
* Issue #14 - Permit --nodelete option on do-scan
* issue #26 - Update installation instructions
* Issue #27 - Email Reporting
* Issue #32 - RPM: Files in /opt/Seccubus/www/seccubus/json have no exec permissions
* Issue #33 - User permission issues not reported correctly
* Issue #34 - $HOSTS vs @HOSTS confusion
* Issue #35 - -p vs --pw (OpenVAS)
* Issue #39 - SeccubusScans exports uninitilized VERSION
* Issue #42 - Nessus help (and scan?) not consistent with regards to the use of -p
* Issue #43 - Sudo option missing from NMAP scanner help (web)
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

