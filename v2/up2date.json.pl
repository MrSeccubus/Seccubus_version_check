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

my $current = "2.3";
my $beta = "2.4";
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

Seccubus V2 Read Me
===================
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
* Nikto (local and remote)
* NMap (local and remote)
* SSLyze

For more information visit [www.seccubus.com]

18-10-2013 - 2.3 - Improved stability, Nmap and Nikto on remote hosts
=====================================================================

Key new features / issues resolved
----------------------------------
Seccubus now checks the state of the DBI handle before performing queries
Improved handling of Nessus 5.2 file format
Fixed some issues related to the new backend filters

Bugs fixed (tickets closed):
----------------------------
* #62 - Would like to be able to run Nmap/Nikto/SSLyze scans on a remote host
* #84 - Nessus critical findings got severity 0
* #87 - Hostname ordering was weird because of wildards for hostnames
* #88 - "*" is not selected in filters when no filter is given
* #89 - Scans fail to import due to database timeouts
* #90 - Hostnames are not sorted in filters, IP addresses are
* OBS build script now echos link to OBS project
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

