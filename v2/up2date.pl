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

my $current = "2.0.beta1 or higher";
my $beta = "xxxxx";
my $cool = "xxxxx";
my ( $one, $two, $three) = split /\./, $current;


#my (
   #);

my $query = CGI::new();

print $query->header("text/xml");

my $version = $query->param("version") or result(1,"No version specified", "unknown");
my $reported_version = $version;
$version =~ s/\.B\d+//;


my ($major, $minor, $revision) = split /\./, $version;

if ($major < $one ) {
	result(1,"This check only supports version 2.x.x",$version);
} elsif ( $version eq $current ) {
	result(0,"Your version $reported_version is up to date",$version);
} elsif ( $version eq $cool ) {
	result(0,"",$version);
} elsif ( $minor lt $two || ($minor eq $two && $revision lt $three) ) {
	result(1,"<b>Version $current is available, please upgrade...</b><br>
		<a href=https://github.com/schubergphilis/Seccubus_v2/downloads>
		Download it from GitHub</a>
",$version);
} elsif ( $version eq $beta ) {
	result(0,"Your version ($reported_version) is the trunk version ($version) of Seccubus",$version);
} else {
	result(1,"Unrecognized version: $version, current is $current",$version);
}

exit;

sub result($$$;) {
	my $iserror = shift;
	my $message = shift;
	my $version = shift;

	my $status = "OK";
	if ( $iserror ) { 
		$status = "NOK";
	}
		

	print "
<seccubusAPI name='up2date.pl'>
	<result>$status</result>
	<message>$message</message>
	<data>
		<version>$version</version>
	</data>
</seccubusAPI>";
	exit;
}
