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

####Get the day we were run so we can make a unique ID for the JSON
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year+=1900;
$mon+=1; #For some reason, month is one less than actual
$jsonRun=sprintf("%04d%02d%02d%02d%02d",$year,$mon,$mday,$hour,$min); 
$jsonID=1;

$infile="./dropdowns.csv";
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

# The default users we will add to the sql
$userlist=read_file("ddl-${backend}/kardia_users.txt");

open (INFILE,$infile);
$lasttable="";
$jsonout="./ddl-$backend/dropdownChangeLog.json";

open (OUTD,">$deleteout");
open (OUTC,">$createout");
open (JSON,">$jsonout") or die;
print OUTC "use Kardia_DB$cmd_terminator\n";
print OUTD "use Kardia_DB$cmd_terminator\n";
 
print JSON "{ \"databaseChangeLog\": ["; #start the change log
$notFirst = 0;

while (<INFILE>) 
    {
    $line=$_;
    $status = $csv->parse($line);
    ($table,$key,$value,$explanation,$extra) = $csv->fields();
    $keylen = length($key);
    #print "Table: $table Key: $key Value: $value EXP: $explanation Extra: $Extra\n";
    if ( $table ne "table" ) {
	if($notFirst)
	    {
	    print JSON "    },\n";
	    }
	else
	    {
	    $notFirst = 1;
	    }

	if ( $lasttable ne $table ) {
	    $lasttable=$table;
	    if ($backend eq "sybase") {
		print OUTC "\nprint 'adding table $table'\n";
	    }
	    print OUTD "drop table $table$cmd_terminator";
	    print OUTC "create table $table (\n";
	    print JSON "    {\n    \"changeSet\": {\n";					
	    print JSON "        \"id\": \"$jsonRun-$jsonID\",\n";			
	    $jsonID++;									
	    print JSON "        \"author\": \"devel (generated)\",\n";
	    print JSON "        \"changes\": [\n        {\n";				
	    print JSON "          \"createTable\": {\n";				
	    print JSON "              \"columns\": [\n";				
	    print JSON "                {\n";						
	    print JSON "                  \"column\": {\n";				
	    print JSON "                    \"constraints\": {\n";			
	    print JSON "                      \"nullable\": false,\n";			
	    print JSON "                      \"primaryKey\": true\n";			
	    print JSON "                    },\n";					
	    print JSON "                    \"name\": \"tag\",\n";			
	    if ($key =~ /^(\-|\+)?\d+?$/) {
		print OUTC "  tag	integer not null,\n";
		print JSON "                  \"type\": \"integer\"\n";
		$isinteger = 1;
	    } else {
		print OUTC "  tag	char($keylen) not null,\n";
		print JSON "                  \"type\": \"char($keylen)\"\n";
		$isinteger = 0;
	    }
	    print JSON "                }\n              },\n";	

	    print OUTC "  text	varchar(60) not null,\n";
	    print JSON "                {\n";				
	    print JSON "                  \"column\": {\n";		
	    print JSON "                    \"constraints\": {\n";	
	    print JSON "                      \"nullable\": false\n";	
	    print JSON "                    },\n";			
	    print JSON "                    \"name\": \"text\",\n";	
	    print JSON "                    \"type\": \"VARCHAR(60)\"\n";
	    print JSON "                  }\n";				
	    print JSON "                },\n";				

	    print OUTC "  description varchar(255) null,\n";
	    print JSON "                {\n";				
	    print JSON "                  \"column\": {\n";		
	    print JSON "                    \"name\": \"description\",\n";
	    print JSON "                    \"type\": \"VARCHAR(255)\"\n";
	    print JSON "                  }\n";				
	    print JSON "                },\n";				

	    print OUTC "  inverse char(1) null,\n" if ( $table =~/relationship/ );
	    print JSON "                {\n" 				if( $table =~/relationship/ );
	    print JSON "                  \"column\": {\n"		if ( $table =~/relationship/ );
	    print JSON "                    \"name\": \"inverse\",\n"	if ( $table =~/relationship/ );
	    print JSON "                    \"type\": \"char(1)\"\n"	if ( $table =~/relationship/ );
	    print JSON "                  }\n"				if ( $table =~/relationship/ );
	    print JSON "                },\n"				if ( $table =~/relationship/ );

	    print OUTC "  __cx_osml_control varchar(255) null";
	    print JSON "                {\n";
	    print JSON "                  \"column\": {\n";			
	    print JSON "                    \"name\": \"__cx_osml_control\",\n";
	    print JSON "                    \"type\": \"VARCHAR(255)\"\n";	
	    print JSON "                  }\n";
	    print JSON "                }\n";

	    print OUTC ")$cmd_terminator";
	    print JSON "              ],\n";			
	    print JSON "              \"tableName\": \"$table\"\n";
	    print JSON "            }\n";			
	    print JSON "          }\n";				
	    print JSON "        ]\n";				
	    print JSON "        \n";				
	    print JSON "      }\n";				
	    print JSON "    },\n";				

	    if ($backend eq "sybase") {
		foreach $user (split(/\n/, $userlist)) {
		    print OUTC "grant all on $table to $user$cmd_terminator";
		    # TODO: come back and add grant commans 
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

	print JSON "    {\n";
	print JSON "      \"changeSet\": {\n";
	print JSON "        \"id\": \"$jsonRun-$jsonID\",\n";
	$jsonID++;
	print JSON "        \"author\": \"devel (generated)\",\n";
	print JSON "        \"changes\": [\n";
	print JSON "          {\n";
	print JSON "            \"insert\":{\n";
	print JSON "              \"columns\":[\n";
	print JSON "                {\n";
	print JSON "                  \"column\":{\n";
	print JSON "                    \"name\":\"tag\",\n";
	if ($isinteger) {
	    print OUTC "insert $table values($key,'$value','$explanation'";
	    print JSON "                    \"value\":$key\n";
	} else {
	    print OUTC "insert $table values('$key','$value','$explanation'";
	    print JSON "                    \"value\":\"$key\"\n";
	}
	print JSON "                  }\n";
	print JSON "                },\n";
	print JSON "                {\n";

	print OUTC ",'$extra'" if ($table=~/relationship/);
	print OUTC ",'')$cmd_terminator";
	print JSON "                  \"column\":{\n";		
	print JSON "                    \"name\":\"text\",\n";	
	print JSON "                    \"value\":\"$value\"\n";
	print JSON "                  }\n";
	print JSON "                },\n";

	print JSON "                {\n";
	print JSON "                  \"column\":{\n";
	print JSON "                    \"name\":\"description\",\n";
	print JSON "                    \"value\":\"$explanation\"\n";
	print JSON "                  }\n";
	print JSON "                }\n";
	print JSON "              ],\n";
	print JSON "              \"dbms\":\"mysql, sybase\",\n";
	print JSON "              \"tableName\":\"$table\"\n";
	print JSON "            }\n";	
	print JSON "          }\n";
	print JSON "        ]\n";
	print JSON "      }\n";	

    }
}
print JSON "    }\n";
print JSON "  ]}\n";
close (OUTD);
close (OUTD);
close (JSON);
