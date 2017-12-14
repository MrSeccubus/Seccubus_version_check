#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Copyright (C) 2008  Schuberg Philis, Frank Breedijk, gtencate, blabla1337 - Under GPLv3
# ------------------------------------------------------------------------------

use strict;
use CGI;
use JSON;

my $current = "2.46";
my $beta = "2.47";
my $cool = "2.48";
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

14-12-2017 - v2.46 - RedHat 7 / Centos 7 packages
=================================================
This release adds RPM support for RedHat 7 and CentOS 7. Because Mojolicious and some of its dependancies were not available
as RPM on any of the standard repos for el7 we are also buildign these RPMs as part of our el7 build street now and are
pushing these packages to our [packagecloud.io](https://packagecloud.io/seccubus) repository. This makes tweaks like [this one](https://t.co/svO7z1RiRb) by @Ar0xA unneccasary.

Enhancements
------------
* Added support for RedHat 7 / CentOS 7 RPM packages. With the extra needed packages being added to packagecloud.io

Bug Fixes
---------
* #588 - Fix Nmap Plugin ID leak (Thanks @alirezakv)
* #589 - Fix OpenVAS scan execution bug with only 1 target defined (Thanks @alirezakv)
* #603 - Nessus scan fails when pdf files cannot be exported (Thanks @Ar0xA)
* #615 - Docker: when the database was on the data volume the database failed to start
* #617 - Nikto scanner gives unintended error output
* Theodoor Scholte fixed some typos in the scanner scripts (Thanks!)
* Streamlined CircleCI unit testing


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

