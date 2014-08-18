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

my $current = "2.9";
my $beta = "2.10";
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
		$data = [ "Error","Version $current is available, please upgrade..." . qq{

Release notes:

Seccubus V2 Read Me
===================
Seccubus automates regular vulnerability scans with vrious tools and aids 
security people in the fast analysis of its output, both on the first scan and 
on repeated scans.

On repeated scan delta reporting ensures that findings only need to be judged 
when they first appear in the scan results or when their output changes.

Seccubus 2.x is the only actively developed and maintained branch and all support 
for Seccubus V1 has officially been dropped. 

Seccubus V2 works with the following scanners:
* Nessus 4.x and 5.x (professional and home feed)
* Skipfish
* OpenVAS
* Medusa (local and remote)
* Nikto (local and remote)
* NMap (local and remote)
* SSLyze

For more information visit [www.seccubus.com]

18-08-2014 - 2.9 - Qualys SSLlabs integration
=============================================
Seccubus can now fetch the results of www.ssllabs.com automatic scanner and monitor for deltas

Bug Fixes
============================================
* #122 - SSLlabs integration
* #120 - SELinux problem on RHEL6
* #99 - The ability to remote is not reflected in the scanner help text
* #67 - -o usage needs to be more specific for e.g. nikto and nmap scanner
* #63 - Scan table does not display scanner correctly
* #59 - Explanation of \$ATTACH: in notifications is not very clear


},
"https://www.seccubus.com/seccubus-v2-8/",""];
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

