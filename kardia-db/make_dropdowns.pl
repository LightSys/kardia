#!/usr/bin/perl
use Text::CSV;
use File::Slurp;
#################################
# We have a number of dropdowns (code tables / validation tables)
# Because we may need to have different sql
# syntax for different databases (mysql, etc)
# We might as well have a script to generate
# sql.
#
# A part of the Kardia software project.
# Copyright (C) 2006-2013 LightSys Technology Services, Inc.
# Provided under the GNU GPL, version 2 (or a later version of the GNU GPL
# at your option)

# Run this file as:
#
#     ./make_dropdowns.pl -b {backend}
#
# where {backend} is either "sybase" or "mysql", depending on what database
# server you want to generate the DDL for.

#################################
# The default users we will add to the sql
$userlist=read_file("kardia_users.txt");

$infile="../dropdowns.csv";
$createout="dropdowns_create.sql";
$deleteout="dropdowns_drop.sql";
my $csv = Text::CSV->new();

# Backend
$backend = "sybase";
if ($ARGV[0] eq "-b") {
    shift;
    $backend = $ARGV[0];
    shift;
}
if ($backend eq "sybase") {
    $cmd_terminator = "\ngo\n";
} elsif ($backend eq "mysql") {
    $cmd_terminator = ";\n";
}

open (INFILE,$infile);
$lasttable="";

open (OUTD,">$deleteout");
open (OUTC,">$createout");
print OUTC "use Kardia_DB$cmd_terminator\n";
print OUTD "use Kardia_DB$cmd_terminator\n";
while (<INFILE>) 
    {
    $line=$_;
    $status = $csv->parse($line);
    ($table,$key,$value,$explanation,$extra) = $csv->fields();
    $keylen = length($key);
    #print "Table: $table Key: $key Value: $value EXP: $explanation Extra: $Extra\n";
    if ( $table ne "table" ) {
	if ( $lasttable ne $table ) {
	    $lasttable=$table;
	    if ($backend eq "sybase") {
		print OUTC "\nprint 'adding table $table'\n";
	    }
	    print OUTD "drop table $table$cmd_terminator";
	    print OUTC "create table $table (\n";
	    print OUTC "  tag	char($keylen) not null,\n";
	#    if ( $table=~ /_partner_class/ ) {
	#	print OUTC "char(3) not null,\n";
	#    } else {
	#	if ( $table=~ /_s_process/ ) {
	#	    print OUTC "char(2) not null,\n";
	#	} elsif ($table =~ /_p_bulk_postal_code/ ) {
	#	    print OUTC "char(4) not null,\n";
	#	} else {
	#	    print OUTC "char(1) not null,\n";
	#	}
	#    }
	    print OUTC "  text	varchar(60) not null,\n";
	    print OUTC "  description varchar(255) null,\n";
	    print OUTC "  inverse char(1) null,\n" if ( $table =~/relationship/ );
	    print OUTC "  __cx_osml_control varchar(255) null";
	    print OUTC ")$cmd_terminator";
	    if ($backend eq "sybase") {
		foreach $user (split(/,/, $userlist)) {
		    print OUTC "grant all on $table to $user$cmd_terminator";
		}
	    }
	    # GRB - add a primary key
	    $clustered = "";
	    if ($backend eq "sybase") {
		$clustered = "clustered";
	    }
	    print OUTC "alter table $table add constraint pk_$table primary key $clustered (tag)$cmd_terminator";
	    #print OUTC "create unique index pki_$table on $table (tag)$cmd_terminator";
	}
	print OUTC "insert $table values('$key','$value','$explanation'";
	print OUTC ",'$extra'" if ($table=~/relationship/);
	print OUTC ",'')$cmd_terminator";
    }
}
close (OUTD);
close (OUTD);
