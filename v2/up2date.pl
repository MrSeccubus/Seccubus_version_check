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

my $query = CGI::new();

print $query->header("text/xml");

print "
<seccubusAPI name='up2date.pl'>
	<result>1</result>
	<message>This version of Seccubus has been abandoned. Donwload the latest version please</message>
	<data>
		<version>Outdated</version>
	</data>
</seccubusAPI>";
exit;
