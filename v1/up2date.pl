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

my $current = "2.x.x";
my $beta = "xxxxx";
my $cool = "xxxxx";
my ( $one, $two, $three) = split /\./, $current;


#my (
   #);

my $query = CGI::new();

print $query->header("text/plain");

#my $version = $query->param("version") or die "No version specified";
#
#my ($major, $minor, $revision) = split /\./, $version;
#
#if ($major < $one ) {
	#print "This check only supports version 1.x.x";
#} elsif ( $version eq $current ) {
	#print "Your version $version is up to date";
#} elsif ( $version eq $cool ) {
	#print '';
#} elsif ( $minor < $two || ($minor == $two && $revision < $three) ) {
	print "<b>Version $current is available, please upgrade...</b><br>
		<a href=https://sourceforge.net/projects/seccubus/files/>
		Download it from SourceForge</a>
<p>Seccubus V2 is the active branch:<p>
<p>You are running a V1 version of Seccubus. The latest verison in this branch is verison 1.5.5, however on the 22th of Januari 2012 Seccubus V2.0 was released.</p>
<p>Seccubus V2 is the acively maintained and developed version of Seccubus.</p>
<p>Seccubus V1 is <u><b>no longer supported</b></u></p>
";
#} elsif ( $version eq $beta ) {
	#print "Thanks for beta testing version $version";
#} else {
	#print "Unrecognized version: $version, current is $current";
#}
