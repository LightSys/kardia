#!/usr/bin/perl
# This will capture all the components of the DDL from the web
# and put them into various sql files
#
# Copyright (C) 2006-2013 LightSys Technology Services, Inc.
# A part of the Kardia software project.
# Provided under the GNU GPL, version 2 (or a later GNU GPL version, at your
# option)
#
# Run this file as:
#
#     parse_ddl.pl -b {backend} -n
#
# Where {backend} is either "sybase" or "mysql", depending on which database
# server you want to generate DDL (data definition language, in SQL) for.
#
require HTML::TokeParser;
use LWP::UserAgent;
use HTML::LinkExtor;
use HTML::TokeParser;
use Unicode::UTF8simple;
use URI::URL;
use Carp;
use LWP;
use File::Slurp;


#################################
# The default users we will add to the sql
$userlist=read_file("kardia_users.txt");

#################################
# Backend: sybase or mysql - can be specified with -b command line option
$glob_backend="sybase";

#################################
# Where we look for the html files to pull from
# This script retrieves from $uri when the -n (network) option is specified.
$path="/root/kardia/petradocs/tables";
$clustered="cluster";
$uri="http://sourceforge.net/apps/mediawiki/kardia/index.php?title=kardia:NewTableList";

#################################
# The default file names we will use.
# each of these will have a _create.sql or _drop.sql
# added for the creation or dtopping
$sql_out="tables";
$index_out="indexes";
$references_out="references";
$security_out="users";
$keys_out="keys";
$sec_keys_out="sec_keys";
$wiki_out="wiki";
$component_directory="components";
$order=0;

###############################
# Some info for programming
#
# There are a few main data structures
# $glob_keys       {table}{field} = keys    (the keys)
# $glob_indexes    {table}{index} = info    (the indexes)
#    The primary key goes into $glob_indexes for some reason.  The other keys do not
# $glob_field    
#    $glob_field{$table}{$field}{type};
#    $glob_field{$table}{$field}{comment};
#    $glob_field{$table}{$field}{links};
#    $glob_field{$table}{$field}{rest};
#    $glob_field{$table}{$field}{null};
#    $glob_field{$table}{$field}{default};
# $glob_nulls      {table}{field} = text    (where "not null" is kept
# $glob_clustered  () - If not specified, it is computed.  List one key per table to have clustered
###############################
$glob_datacount=0;
##################################################
# To grab the data sctucture off the web:
# Grab the links and images off a webpage.
# Prompt for new webpages to gulp
# with the -f flag, prompt to follow new URLS
# with the -nl flag, allow to follow non-local URLs


{
 package RequestAgent;
 our @ISA = qw(LWP::UserAgent);
#    sub get_basic_credentials
#    {
#        return ('user', 'pass');
#    }

}

{
package SmartTokeParser;
use base 'HTML::TokeParser';
sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $url = shift;
  my $self;
  if (-e $url) {
    # It's a file!
    $self = HTML::TokeParser->new($url);
  }
  elsif ($url =~ m/^https?|^ftp|^file/) {
    # It's a URL!
    my $browser = RequestAgent->new;
    my $req = $browser->request(HTTP::Request->new(GET=>$url));
    die "Unable to get webpage: $url ", $req->status_line unless $req->is_success;
    $self = HTML::TokeParser->new($req->content_ref);
  }
  elsif ($url =~ m/<[^>]+>/) {
    # It's HTML!
    $self = HTML::TokeParser->new(\$url);
  }

  else {
    die "'$url' is neither a valid URL, file, or HTML.";
  }
  bless ($self, $class);
  return $self;
}
}

####################################################
# connect to the web and pull down the infrastructure

sub pull_off_web() {
    $ua = RequestAgent -> new (keep_alive => 1);

    print "Pulling main list: $uri\n"; 
    my $response = $ua->get($uri);
     if ($response->is_success) {
         @lines=split /\n/,$response->content;  # or whatever
     }
     else {
         die $response->status_line;
     }
    foreach $line (@lines) {
#        if ($line =~ s/.*a href="(\/sw\/[Kk]ardia.*Tables[^"]*).*/$1/) {
#            $line=~s/".*//;
#            @URLS[$#URLS+1]="https://myserver$line";
#        }
	if ($line =~ s/.*a href="(\/apps\/mediawiki\/kardia\/index.php\?title=kardia:NewTables_[^"]*).*/$1/) {
	    $line=~s/".*//;
            @URLS[$#URLS+1]="http://sourceforge.net$line";
	}
    }
    $tablecount=0;
    $fieldcount=0;
    foreach $url (@URLS) { 
        print "$url\n"; 
	$glob_datacount=0;
        $p = SmartTokeParser->new( $url );
        my $count=0;
        my $small_count=0;
        my $last_tag="";
        my $flag=1;
        my $order=0;
        $table=$url;
        $table=~ s/[^ ]*Tables_//;
        $table=~ s/ .*//;
        $table=~ s/"//;
        $tablecount++;
        $glob_table_order{$table}=$tablecount;
        #print "downloading table: $table\n";    
        while ($flag == 1 ) {
            my @token = $p->get_tag("td","li");
            if ($token[0][0] ne "") {
		if ($token[0][3] =~ /.*sfh_n_li.*/) {
		    next;
		}
		#print $token[0][0] . ", " . $token[0][3] . "\n";
                if ($token[0][0] ne $last_tag) {
                    $count++;
                    $small_count=0;
                    $last_tag=$token[0][0];
                }
                my $text = $p->get_trimmed_text("/td","/li");
                if ($count == 3) {
                    #Grabbing fields
                    if ($small_count==0) {
                        $small_count++;
                        $field=$text;
                        $fieldcount++;
                        $glob_field{$table}{$field}{'order'}=$fieldcount;
                    } elsif ($small_count==1) {
                        $small_count++;
                        $type=$text;

			if ($glob_backend eq "mysql") {
			    if ($type eq "money") {
				$type = "decimal(14,4)";
			    }
			}
                    } elsif ($small_count==2) {
                        $small_count++;
                        $default=$text;
                        $nullinfo=$default;
                        $default=~ s/(default [^ ]*) (.*)/$1/;
                        $default="" if ($default !~ /default/);
                        $nullinfo=~ s/(default [^ ]*) (.*)/$2/;
                        $nullinfo="" if ($nullinfo !~ /null/);
                    } elsif ($small_count==3) {
                        $small_count++;
                        $comment=$text;
                    } elsif ($small_count==4) {
                        $order++;
                        $comment="$comment -- $text";
                        #$comment=s/--/ /;
                        #$comment=s/"/'/g;
                        $small_count=0;
                        #print "field: $field  type: $type  comment: $comment\n";
                        $glob_field{$table}{$field}{'type'} = $type;
                        $glob_field{$table}{$field}{'comment'} = $comment;
                        $glob_field{$table}{$field}{'order'} = $order;
                        $glob_field{$table}{$field}{'default'}=$default if($default ne "");
                        $glob_nulls{$table}{$field}=$nullinfo if($nullinfo ne "");
                    }
                }
                if ($count == 4) {
                    $order++;
                    #Indexes and keys
                    #print "$text\n";
                    if ($text =~ /primary key: ([^ ]*) (.*)/ ) {
                        #print "pkey - $1  rest $2\n";
                        $glob_indexes{$table}{$1}=$2;
                        $glob_index_order{$table}{$1}=$order;
                    }
                    if ($text =~ /unique key: ([^ ]*) (.*)/ ) {
                        #print "ukey - $1  rest $2\n";
                        $glob_indexes{$table}{$1}=$2;
                        $glob_index_order{$table}{$1}=$order;
                    }
                    if ($text =~ /([^ ]*) foreign key \((.*)\) => (.*)/ ) {
                        #print "index - $1 -- $2 => $3\n";
                        $glob_keys{$table}{$1}=$2;
                        $glob_index_order{$table}{$1}=$order;
                        $glob_keys{$table}{$1}{'target'}=$3;
                    }
                    if ($text =~ /([^ ]*) on $table (.*)/ ) {
                        #print "index - $1  which is $2\n";
                        $glob_indexes{$table}{$1}=$2;
                        $glob_index_order{$table}{$1}=$order;
                    }
                    if ($text =~ /=/ ) {
			# Need to convert to MySQL syntax?
			if ($glob_backend ne "sybase") {
			    $text =~ s/([a-zA-Z_][a-zA-Z0-9_]*)=([^,]*)/$2 as $1/g;
			}

                        #We found some data
			$glob_datacount++;
                        $glob_data{$table}{$glob_datacount}=$text;
                    }
                }
            } else {
                $flag=0;
            }
        }
    }
}


###############################
# Pull data from file
sub process_file()
{
    my ($localfile)=@_;
    my $tablename=$localfile;
    $tablename=~ s/.*\///;
    $tablename=~ s/.html//;
    my $indexcount=0;
    $indexes[$indexcount] = "";
    my $indexflag=0;
    my $count_num=0;
    my $primary_key="";
    my $fieldcount=0;
#    print DRP "drop table $tablename$cmd_terminator";
#    print SQL "\ncreate table $tablename (\n";
    $p = HTML::TokeParser->new($localfile);
    $token=$p->get_tag("table");
        $tempval = $token->[1]{class} || "NONE";
    $token=$p->get_tag("table");
        $tempval = $token->[1]{class} || "NONE";
       $loc_comment  = $p->get_trimmed_text("/table");
    #print "$tempval $loc_comment\n";

    $comments{$tablename}=$loc_comment;

    while (my $token = $p->get_tag("tr")) {
              my $mytype = $token->[1]{class} || "NONE";
        if ($mytype eq "field") { 
            #deal with printing commas after field-names
            if ( $count_num > 0) { print SQL ",\n"; }
            #Pull out the whole text
                  my $text = $p->get_trimmed_text("/td");
            $text =~ s/ \(/(/;
            #break the string into field, type, and the rest of it all
            ($field,$type,$rest) = split / /, $text, 3;

            #remove trailing characters _i, _c, etc.  depicting type
            $field=~ s/(_[a-z])$//;
            
            $glob_field{$tablename}{$field}{'order'}=$fieldcount;
            $fieldcount++;
            #Nulls
            if ($rest =~ /NULL/) {
        #print "Found a null -$tablename-  -$field-  -$rest--- ";
                if ($rest =~ /NOT NULL/) {
                    $glob_nulls{$tablename}{$field} = "not null";
                    $rest =~ s/NOT NULL//;
                    #print "not null\n";
                }
                if ($rest =~ /default: NULL/) {
                    #we have a "default: NULL" situation
                    $glob_field{$tablename}{$field}{default} = "null";
                    $rest =~ s/default: NULL//;
                    #print "default null\n";
                }
                if ($rest =~ /NULL/) {
                    #we have a "default: NULL" situation
                    $glob_nulls{$tablename}{$field} = "null";
                    $rest =~ s/NULL//;
                    #print "null\n";
                }
                    
            }
            #Assign is used for applets which are loaded in.  For now, drop them
            $rest =~ s/assign: [^ ]*//;
            $rest =~ s/SYSDATE/getdate()/;
            $rest =~ s/ *$//;
            #for now, get rid of defaults
            if ($rest =~ /default: (.*)/) {
                $glob_field{$tablename}{$field}{default}=$1;
                $rest =~ s/default: [^ ]*//;
                
            }
            #There is just one case where the above does not catch everything.  Catch that
            if ($rest =~ /Data Entered/) { 
                $rest =~ s/Data Entered//;
            }
            $rest =~ s/^ //;
        #print "Rest:  $rest\n" if ($rest ne "");
            #translate the type so it fits sybase
            $type=~s/bit/tinyint/;
            $type=~s/integer/int/;
            $type=~s/date/datetime/;
            $bots=0; $places=0;
            $type="char (10)" if ($field=~/ledger_number/);
            if ($type=~/number/) {
                $bits=32;$places=0;
                if ($type=~/\(([0-9][0-9]*)/){$bits=$1;}
                if ($type=~/\(([0-9][0-9]*),([0-9][0-9]*)\)/){$places=$2;}
            #print "orig type $type   $bits  $places\n";
                # We want rates to be double
                $type = "float" if ($field=~/rate/);
                # We want all money types to be money.
                # Luckily, Petra standardardized on number(24,10) for all money */
                $type = "money" if ($type=~/24,10/);
                # all the rest become doubles
                $type = "float" if ($type=~/number/);
                #except these two
                $type = "money" if ($field=~/cost/);
                $type = "money" if ($field=~/amount/);

            }
#            print "type float - $tablename $field $bits $places  " if ($type =~ /float/);
            if ($type =~ /float/) {
                #here we have some translations
                
                #this happens twice.  They reference p_partner, which is 10,0
                $bits=10 if ($bits == 15 and $places == 0);

                $keepfloat=0;
                $keepfloat=1 if ($field =~ /rate/);
                $keepfloat=1 if ($field =~ /percentage/);
                $keepfloat=1 if ($field =~ /pct/);
                $keepfloat=1 if ($bits==30 && $places==6);

                if ($keepfloat == 0) {
                    #we do not need to keep it a float
                    $type = "char ($bits)";
                    $type = "char (5)" if ($bits==6 and $places==2);

                    $type = "tinyint" if ($field =~/um_evaluator_age/);
                }
#                print "   --> $type\n";
                
            }
            $rest=~s/_. //g if ($rest=~/CHECK/);
            my $varsize=0;
            if ($type =~ /varchar ?\(([0-9][0-9]*)\)?/) {
                $varsize = $1;
                if ($varsize > 255 and $varsize < 400) {
                    $type =~ s/varchar ?\(([0-9][0-9]*)\)?/varchar(255)/;
                    #print " truncating $varsize to 255 - $type\n";
                }
                if ($varsize >= 400) {
                    #print "processing...  $tablename $field $varsize";
                    #default is to truncate it to 256
                    $type="varchar(255)";
                    $type="text" if ($field =~ /comment/);
                    $type="text" if ($field =~ /insert/);
                    $type="text" if ($field =~ /text/);
                    $type="text" if ($field =~ /description/);
                    $type="text" if ($field =~ /parameters/);
                    $type="text" if ($field =~ /data/);
                    $type="varchar(255)" if ($field =~ /p_finance_comment/);

                    #print "  - $type\n";
                }
                
            }

            #compute the number of tabs after the field-name
            $tabs = 5-int(length($field) / 8);
            if ($tabs < 1) { $tabs=1; }  
            $tabstop=substr("\t\t\t\t\t\t\t\t",0,$tabs);
            #compute the number of tabs after the type
            $tabs = 2-int(length($type) / 8);
            if ($tabs < 1) { $tabs=1; }  
            $tabstop2=substr("\t\t\t\t\t\t\t\t",0,$tabs);

            #Pull out any comment information
            $p->get_tag("td");
            #if ($field eq "" ) {
                  #    my $field = $p->get_trimmed_text("/td");
            #    $p->get_tag("td");
            #}
                  my $comment = $p->get_trimmed_text("/td");
            $comment=~ s/"/'/g;
            $p->get_tag("td");
                  my $links = $p->get_trimmed_text("/td");
        #print "Links:  $links\n";
#print "$tablename $field -> $links\n" if ($links =~ /ledger/);
            if ($count_num == 0) { $primary_key = "$field"}; 
            #Print out the field name and type
#                  print SQL "\t$field$tabstop$type";
            $glob_field{$tablename}{$field}{type}=$type if ($type ne "");
            $glob_field{$tablename}{$field}{rest}=$rest if ($rest ne "");
            $glob_field{$tablename}{$field}{links}=$links if ($links ne "");
            $glob_field{$tablename}{$field}{comment}=$comment if ($comment ne "");
#            if ($rest ne "") { print SQL "$tabstop2$rest"; }
            $count_num++;
        }
        else {
                  my $text = $p->get_trimmed_text("/tr");
            $cap=$text;
            $cap =~ tr/A-Z/a-z/;
            if ($cap ne $text and $text !~ /gtap_OnTableName/) {
            #print "$text\n";
                $indexflag = 0;
            }
            if ($text =~ s/FOREIGN KEY//) {
                $text=~s/ //;
        #print "======$text\n";
                while ($text =~ s/([^ ][^ ]*): ([^=]*) => ([^ ]*)//) {
                    my $my_fk=$1;
                    my $keys=$2;
                    my $target=$3;
                    $keys=~ s/_[a-z]([^a-z])/$1/g;
                    $keys=~ s/_[a-z]$//;
                    $glob_keys{$tablename}{$my_fk}=$keys;
                    $glob_keys{$tablename}{$my_fk}{target}=$target;
        #print "$tablename $my_fk $keys ==>> $target\n";
                }
        #print "\n";
            }
            if ($text eq "TRIGGERS") {
                $indexflag=0;
            }
            if ($indexflag) {
                $index=$text;
                $implicit="";
                #I do not think it is important to distinguish between implicit and explicit indexes
                #There are only 16 explicit indexes.  In Sybase, implicit indexes are created through
                #constraints added or dropped through the "alter table"
                $implicit="/* implicit */" if ($index =~ /\(implicit\)/ );
                $index=~ s/\(ascending\)/ asc/g;
                $index=~ s/\(descending\)/ desc/g;
                $index=~ s/\([^\)]*\)//g;
                $index=~ s/://g;
                ($indexfile,$rest)=split / /,$index,2;
                #in one case, a unique key is labeled as nk instead of uk
                $indexfile=~s/_nk/_uk/;
                $indexfile=~s/_uq/_uk/;
                $rest=~ s/ //;
                #remove _i, _c, _d, etc.
                $rest =~ s/_. / /g;
                
                $indexes[$indexcount]="$indexfile on $tablename ($rest)";
                if ($indexfile !~ /inx__valid_ledger_number_fk4_ref/ ) {
                    $glob_indexes{$tablename}{$indexfile}="($rest)";
                    $glob_index_order{$tablename}{$indexfile}=10;
                }
        #print "$tablename $indexfile indexlist = $rest\n";
                foreach $idx (split(/,/, $rest)) {
                    $idx =~ s/^ //;  #remove leading space
                    #get just the field name (remove a trailing asc or desc)
                    $idx =~ s/ asc//;
                    $idx =~ s/ desc//;
                    $idx =~ s/ $//g;
        #print "Tagging $tablename $idx as a key ";
                    $glob_field{$tablename}{$idx}{key} = "key" if ($indexfile =~ /_fk/);
                    $glob_field{$tablename}{$idx}{key} = "unique key" if ($indexfile =~ /_uk/);
                    $glob_field{$tablename}{$idx}{key} = "primary key" if ($indexfile =~ /_pk/);
        #print "$glob_field{$tablename}{$idx}{key}\n"
                }
                $indexcount++;
            }
            if ($text =~ /INDEXES/) {
                $indexflag=1;
        #print "    indexes tag = $text\n"
            }

        }
      }
    if ($primary_key ne "") {
#        print SQL ",\n\tPRIMARY KEY ($primary_key)\n"; 
    } else {
#        print SQL "\n";
    }
#    print SQL ")$cmd_terminator";
#        print SQL "grant all on $tablename to public$cmd_terminator";
    foreach $a (split /[,\s]+/,$userlist) {
        $a=~s/ //;
#        print SQL "grant all on $tablename to $a$cmd_terminator";
    }
#    if ($indexcount > 0) { print INX "\n/* INDEXES for $tablename */\n"; }
    for ($cnt=0; $cnt < $indexcount; $cnt++) {
#        print INX "create nonclustered index $indexes[$cnt]$cmd_terminator" if (indexcount ==0);
#        print INX "create index $indexes[$cnt]$cmd_terminator" if (indexcount >0);
    }
#    print SQL "\n";
}

sub make_sql_header()
{
#This will simply print out the SQL header for the file
print SQL_N '
/* Create the ' . $glob_table . ' database */

--set nocount on
if not exists (select * from master.dbo.sysdevices where name = "kardia_data")
    /* If the physical device does not exist, make it */
           begin
                  print \'Creating the Kardia DB device.\'
                   disk init name="kardia_data", physname="/usr/local/kardia/Kardia_DB.db",vdevno=4,size=262288
                   disk init name="kardia_log", physname="/usr/local/kardia/Kardia_DB.log",vdevno=5,size=262288
           end
go

if exists (select * from master.dbo.sysdatabases where name = "' . $glob_table . '")
           begin
        /* drop the existing database */
                   print \'Recreating the "' . $glob_table . '" database.\'
                   drop database ' . $glob_table . '
           end
else
           begin
                   print \'Creating the "' . $glob_table . '" database.\'
           end
go
    
/* create a new database */
create database ' . $glob_table . ' on kardia_data=1020 log on kardia_log=1020
go
';

if ($glob_backend eq "sybase") {
print SQL_C '
--set nocount on
use ' . $glob_table . '
go

set dateformat mdy
go
/* Table for Centrallix annotation expressions */
create table ra(
        a varchar(32),
        b text,
        c text,
        PRIMARY KEY (a)
        )
go
' ;
} elsif ($glob_backend eq "mysql") {
print SQL_C '
use ' . $glob_table . ';
/* Table for Centrallix annotations */
create table ra(
	a varchar(32),
	b text,
	c text,
	PRIMARY KEY (a)
	);
';
}
print SQL_C "
insert ra values('a_account','GL Accounts',':a_acct_desc')$cmd_terminator
insert ra values('a_account_category','Control Categories',':a_acct_cat_desc')$cmd_terminator
insert ra values('a_batch','Batches',':a_batch_desc')$cmd_terminator
insert ra values('a_cost_center','Cost Centers',':a_cc_desc')$cmd_terminator
insert ra values('a_cost_center_prefix','CostCtr Prefixes',':a_cc_prefix_desc')$cmd_terminator
insert ra values('a_period','Periods',':a_period_desc')$cmd_terminator
insert ra values('m_list','Mailing Lists',':m_list_description')$cmd_terminator
insert ra values('p_partner','Partners',':p_surname + \", \" + :p_given_name')$cmd_terminator
";
}

sub make_sql_footer() {
if ($glob_backend eq "sybase") {
print SQL_C '
/* clean out the log file since it can fill up */
dump tran master with no_log
go
'
}
}



###############################################################
#
###############################################################
sub compare_name() {
    my $count=0;
    my($field1, $field2) = @_;
    foreach $check (split(/_/,$field2)) {
        $check =~ s/ //g;
        if (length($check)>2) {
            $count++ if ( $field1 =~ /$check/ );
        }
    }
    return $count;
}

###############################################################
#
###############################################################
sub find_foreign_key() {
    #The problem is that the key does not have the name of the key in the
    #target table.  SO we need to guess what it is.  Usually it is the
    #primary key.  But it is not always.
    my ($table, $field, $link) = @_;
#    $count = 0;
#    foreach $test (keys %{$glob_field{$table}}) { $count++; }
#    print "table $table has $count fields  ";
#    $count = 0;
#    foreach $test (keys %{$glob_field{$link}}) { $count++; }
#    print "table $link has $count fields\n";
#print "Finding $table $field $link\n";
    #$link is the table which is being referenced.
    if ($glob_field{$link}{$field}{type} ne "") {
        #if the name is the same, use that 
        $glob_reference{$table}{$field}{$link} = $field;
        $glob_reference{$table}{$field}{$link}{comment} = "The same fieldname in both tables";
    } 
    if ($glob_reference{$table}{$field}{$link} eq "") {
        #See if only one key field (primary, unique, etc) matches
        my $count=0;
        my $tag="";
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
    #print "checking to see if -$glob_field{$link}{$check_field}{key}- ($link)($check_field) is a key\n"; 
    #print " and comparing types:  $glob_field{$link}{$check_field}{type} =  $glob_field{$table}{$field}{type}\n"; 
            if ($glob_field{$link}{$check_field}{type} eq
                $glob_field{$table}{$field}{type} and
                $glob_field{$link}{$check_field}{key} ne "") {
                #they are the same.
                $count++;
                $tag = $check_field;
    #print "  Found one($tag).  Now there are $count\n"
            }
        }
        if ($count == 1) {
            #there was only one match.  Use it
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Only one key field has same type as origin";
    #print "    Found unique key match $table $field $link  ($link $tag)\n";
        } 
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
    # see if only one primary key has the same type as what we are searching for
        my $max_num=0;
        my $tag="";
        my $max_equiv=0;
        my $check=0;
        my $test=0;
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
            $check=0;
            $test=0;
            $check=2 if (($glob_field{$link}{$check_field}{key}=~/primary key/) and (
               $glob_field{$table}{$field}{type} eq $glob_field{$link}{$check_field}{type}));
    #print "   numerically comparing primary keys ($table)($field)=$glob_field{$table}{$field}{type}  ($link)($check_field)=$glob_field{$link}{$check_field}{type}   = $check   $glob_field{$link}{$check_field}{key}\n" if ($check >= 1);
            if ($check > $max_num) {
    #print " Found one match\n";
                $tag = $check_field;
                $max_num = $check;
                $max_equiv=0;
            } else {
                if ($check == $max_num and $check != 0) {
     #print "Found another match\n";
                    $max_equiv ++;
                }
            }
        }
        if ($max_num > 0 and $max_equiv == 0) {
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Only one primary key has same type as origin";
#print "$tag compares to $field with certainty= $max_num (base $table, dest $link)\n";
        }
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
    # Now we need to do a comparison between similar names.
    # the hope is that we will find only one field name of the same type
    # which shares commonalities in naming. Look only at primary key fields.
        my $max_num=0;
        my $tag="";
        my $max_equiv=0;
        my $check=0;
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
            $check=0;
       #print " primary key  $link $check_field\n" if ($glob_field{$link}{$check_field}{key}=~/primary key/);
       #print " types equal $link $check_field  $table $field\n" if ($glob_field{$table}{$field}{type} eq $glob_field{$link}{$check_field}{type});
            $check=&compare_name($field, $check_field) if (
               $glob_field{$link}{$check_field}{key}=~/primary key/ and
               $glob_field{$table}{$field}{type} eq $glob_field{$link}{$check_field}{type});
    #print "   numerically comparing primary keys $field $check_field = $check\n" if ($check > 0);
            if ($check > $max_num) {
                $tag = $check_field;
                $max_num = $check;
                $max_equiv=0;
            } else {
                if ($check == $max_num) {
                    $max_equiv ++;
                }
            }
        }
        if ($max_num > 0 and $max_equiv == 0) {
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Multiple primary keys share same type, but name is similar ($max_num)";
#print "$tag compares to $field with certainty= $max_num (base $table, dest $link)\n";
        }
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
    # Now we need to do a comparison between similar names.
    # the hope is that we will find only one field name of the same type
    # which shares commonalities in naming. Look only at key fields.
        my $max_num=0;
        my $tag="";
        my $max_equiv=0;
        my $check=0;
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
            $check=0;
            $check=&compare_name($field, $check_field) if (
               $glob_field{$table}{$field}{type} eq $glob_field{$link}{$check_field}{type} and
               $glob_field{$link}{$check_field}{key}=~/key/ );
    #print "   numerically comparing keys $field $check_field = $check\n" if ($check > 0);
            if ($check > $max_num) {
                $tag = $check_field;
                $max_num = $check;
                $max_equiv=0;
            } else {
                if ($check == $max_num) {
                    $max_equiv ++;
                }
            }
        }
        if ($max_num > 0 and $max_equiv == 0) {
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Found similar named key field of same type ($max_num)";
#print "$tag compares to $field with certainty= $max_num (base $table, dest $link)\n";
        }
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
    # Now we need to do a comparison between similar names.
    # the hope is that we will find only one field name of the same type
    # which shares commonalities in naming.
        my $max_num=0;
        my $tag="";
        my $max_equiv=0;
        my $check=0;
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
            $check=0;
            $check=&compare_name($field, $check_field) if (
               $glob_field{$table}{$field}{type} eq $glob_field{$link}{$check_field}{type});
    #print "   numerically comparing names $field $check_field = $check\n";
            if ($check > $max_num) {
                $tag = $check_field;
                $max_num = $check;
                $max_equiv=0;
            } else {
                if ($check == $max_num) {
                    $max_equiv ++;
                }
            }
        }
        if ($max_num > 0 and $max_equiv == 0) {
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Found similar named field of same type ($max_num)";
#print "$tag compares to $field with certainty= $max_num (base $table, dest $link)\n";
        }
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
        #Compare comment fields
#print "    More than one match for $table $field $link\n";
        $count = 0;
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
#print "Comparing comment $glob_field{$link}{$check_field}{comment} vs $glob_field{$table}{$field}{comment}";
            if ($glob_field{$link}{$check_field}{type} eq
                $glob_field{$table}{$field}{type} and
                $glob_field{$link}{$check_field}{comment} eq
                $glob_field{$table}{$field}{comment}) {
                #they are the same.
                $count++;
                $tag = $check_field;
        #print " yes\n";
            } else {
        #print " no\n";
            }
        }
        if ($count == 1) {
            #there was only one match.  Use it
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "comment fields identical on both sides and same type";
    #print "    Found match $table $field $link  ($link $tag)\n";
        } 
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
        #if it is not the same in the destination, guess
        my $count=0;
        my $tag="";
        foreach $check_field (keys(%{$glob_field{$link}})) {
            #compare the type of each field in the target table
            if ($glob_field{$link}{$check_field}{type} eq
                $glob_field{$table}{$field}{type}) {
                #they are the same.
                $count++;
                $tag = $check_field;
            }
        }
        if ($count == 1) {
            #there was only one match.  Use it
            $glob_reference{$table}{$field}{$link} = $tag;
            $glob_reference{$table}{$field}{$link}{comment} = "Only one field of same type as origin in dest table";
    #print "    Found match $table $field $link  ($link $tag)\n";
        } 
    }
    if ($glob_reference{$table}{$field}{$link} eq "") {
        $glob_reference{$table}{$field}{$link}{comment} = "No match for reference";
#print "no match - $table $field  ->   $link\n";
    }
}


sub get_data_from_html() {
    $filelist=`ls ${path}/*.html`;
    $counter=0;

    #print out the sql header information

    foreach $file (split /\n/,$filelist) {
        chomp ($file);
        #$asterisks="************************************************************************************";
        #$asterisks=substr($asterisks,0,length($file)+13);
        #print SQL "\n\n/$asterisks/\n";
        #print SQL "/*****  ${file} *****/\n";
        #print SQL "/$asterisks/\n";
        &process_file($file);
    };
}

sub get_data_from_sql() {
# $glob_keys       {table}{field} = keys    (the keys)
# $glob_indexes    {table}{index} = info    (the indexes)
#    The primary key goes into $glob_indexes for some reason.  The other keys do not
# $glob_field      {table}{field} = type    (the field names)
#    $glob_field{$table}{$field}{type};
#    $glob_field{$table}{$field}{comment};
#    $glob_field{$table}{$field}{links};
#    $glob_field{$table}{$field}{rest};
#    $glob_field{$table}{$field}{null};
#    $glob_field{$table}{$field}{default};
# $glob_nulls      {table}{field} = text    (where "not null" is kept
# $glob_clustered  () - If not specified, it is computed.  List one key per table to have clustered
    my ($filename)=@_;
    open (INFILE, $filename);
    while (<INFILE>) {
        $order++;
        if ( /create table (.*)/) {$table = $1; $glob_table_order{$table}=$order;}
        elsif ( /PRIMARY KEY (.*)/) {
            $glob_indexes{$table}{"${table}_pk"}=$1;
        }
        elsif ( /^use ([^ ]+$)/) {
            $glob_table=$1;
            chomp($glob_table);
        }
        else {
            if ($table ne "ra"){
                my $line=$_;
                $line=~ s/\t/ /g;
                $line=~ s/ +/ /g;
                $line=~ s/ ,/,/;
                my $comment="";
                if ($line =~ s/--(.*)//) {
                    $comment=$1;
                }
                if ( $line=~/^ *([^ ]+) +([^ ]+),/) {
                    $field=$1;
                    $type=$2;
                    #print "$table: $field -> $type   --$comment\n";
                    $glob_field{$table}{$field}{type}=$type;
                    $glob_field{$table}{$field}{comment}=$comment if ($comment ne "");
                    $glob_field{$table}{$field}{'order'}=$order;
                }
                if ( $line=~/^ *([^ ]+) +([^ ]+) (.*),/) {
                    $field=$1;
                    $type=$2;
                    $defaults=$3;
                    $glob_field{$table}{$field}{type}=$type;
                    $glob_field{$table}{$field}{comment}=$comment if ($comment ne "");
                    #$glob_field{$table}{$field}{null}=$defaults;
                    $glob_nulls{$table}{$field}=$defaults;
                    $glob_field{$table}{$field}{'order'}=$order;
                    #print "$table: $field -> $type (defaults: $defaults) --$comment\n";
                }
            }
        }
    #print $_;
    }
}

sub rank_indexes() {
#We do not know which will be used more, foreign keys or unique/primary/key (non-foreign)
  #If primary key is multi-field, use that.
  #If another (non foreign) key is multi-key, use that
  #If foreign key is multi-key, use that
    #DO it by having a ranking sub which counts the number of keys, adding 1 per field in the key
       #Add 1 if is primary key
       #Add .5 if is unique/key
       #.1 if foreign key.
    #Sort by this number.  Have a cutoff that if the highest is not above that, return nothing.
    #Go through three times.  First, grepping out the _fk and requiring >2
    #Then, if no key is found, add FK into it.
    #Lastly, no limitation (>=1).
    my ($table, $mask, $cutoff)=@_;
    $cutoff=0 if ($cutoff < .5 );
    my $high=0;
    my $tag="";
    my $check;
    my $current=0;
    foreach $check (sort(grep(/$mask/,keys(%{$glob_indexes{$table}})))) {
        $current=0;
        for (split(/,/, $glob_indexes{$table}{$check})) {
            $current++;
        }
        $current+=.9 if ($check=~ /_pk/);
        $current+=.5 if ($check=~ /_k\$/);
        $current+=.5 if ($check=~ /_uk\$/);
        $current+=.1 if ($check=~ /_fk_/);
        if ($current > $high) {
            $high=$current;
            $tag = $check;
        }
    }
    
    #print "Found one ($table $tag [$glob_indexes{$table}{$tag}] $high) with rule $mask / $cutoff\n" if ($high > $cutoff);
    #print "Rejected ($table $tag $high) with rule $mask / $cutoff\n" if ($high <= $cutoff);
    return $tag if ($high > $cutoff);
}

sub find_links() {
    foreach $table (keys (%glob_indexes))  {
#        foreach $field (keys(%{$glob_field{$table}}))  {
#            if ($glob_field{$table}{$field}{links} ne "") {
#                $bad=0;
#                foreach $single (split( /,/ ,$glob_field{$table}{$field}{links} )) {
#                    $single =~ s/ //g;
#                    &find_foreign_key($table,$field,$single);
#                }
#            }
#        }
        my @b=keys(%{$glob_indexes{$table}});
#    print "Num indexes: $#b  $b\n";
#    print "$table  $#b \n" if ($#b == -1);
    $mable="a_recurring_batch";
        my $tag="";
        if ($glob_clustered{$table} eq "") {
            if ($#b == 0) {
                #there is just one index
                ($index)=keys(%{$glob_indexes{$table}});
                $glob_clustered{$table}=$index;
            } else {
                $tag = "";
                $tag = &rank_indexes($table, "_pk|_uk|_k\$", 2) if ($tag eq "");
                $tag = &rank_indexes($table, "_pk|_uk|_k\$|_fk_", 2) if ($tag eq "");
                $tag = &rank_indexes($table, "_pk|_uk|_k\$|_fk_", 1) if ($tag eq "");
                $tag = &rank_indexes($table, "_pk|_uk|_k\$|_fk_", 0) if ($tag eq "");
                if ($tag eq "" ) {
                    $tag = (sort(keys(%{$glob_indexes{$table}})))[0];
                }
                $glob_clustered{$table}=$tag;
            }
        }
    }
}

sub print_table() {
    my ($table)=@_;
    # We are going to print out one table
    
    # the easy one, USER PERMISSIONS #############################
    print SEC_C "\n\n/* $table */\n";                            #
    print SEC_D "\n\n/* $table */\n";                            #
    foreach $a (split /[,\s]+/,$userlist) {
        $a=~s/ //g;						 #
        print SEC_C "grant all on $table to $a$cmd_terminator";		 #
        print SEC_D "revoke all on $table to $a$cmd_terminator";		 #
    }                                                            #
    ##############################################################
    
    #Field-by-field
    $count_num=0;
    print SQL_C "\n\n/* $table */\n";
    if ($glob_backend eq "sybase") {
	print SQL_C "print \"Creating table $table\"\n";
    }
    print SQL_C "\ncreate table $table (\n";
    print WIKI "\n\n$table\n";
    print WIKI "==Description==\n$comments{$table}\n";
    $num_fields=0;
    print WIKI "==Tables==\n";
    print WIKI "{| border\n";
    print WIKI "|- bgcolor=grey\n";
    print WIKI "!FIELD!!TYPE!!Default/Null!!ORIGINAL COMMENT!!DISCUSSION\n";
    foreach $field (keys(%{$glob_field{$table}})) { $num_fields++; }
    foreach $field (sort { $glob_field{$table}{$a}{'order'} <=> $glob_field{$table}{$b}{'order'} } (keys(%{$glob_field{$table}}))) {
        my $type=$glob_field{$table}{$field}{type};
        if ($type ne "") {
            my $comment=$glob_field{$table}{$field}{comment};
            my $links=$glob_field{$table}{$field}{links};
            my $rest=$glob_field{$table}{$field}{rest};
            #my $null=$glob_nulls{$table}{$field};
            my $null="";
            my $default=$glob_field{$table}{$field}{default};
            
            #compute the number of tabs after the field-name
            $tabs = 38-int(length($field));
            if ($tabs < 1) { $tabs=1; }  
            $tabstop=substr("                                                   ",0,$tabs);
            #compute the number of tabs after the type
            $tabs = 16-int(length($type));
            if ($tabs < 1) { $tabs=1; }  
            $tabstop2=substr("                                                  ",0,$tabs);

            #Print out the field name and type
            my $string="";
            $string = "        $field$tabstop$type";
            $string = " $null" if ($null ne "");
	    $default =~ s/default//i;
	    $default =~ s/^ *//;
	    $default =~ s/ *$//;
            if ($default ne "" ) {
                if ( $default =~ / / or $default=~ /\>|\*|Posted|level|Gift|UNKNOWN|Local|Warning|P|All/i) {
                    $string = "$string  default \"$default\"";
                } else { 
                    $string = "$string  default $default";
                }
            }
            # add null/not null
            # NULL
            #print "checking -$table- -$field- for null\n";
            if ($glob_nulls{$table}{$field} ne "not null") {
		if ($type ne "bit") {
		    $glob_nulls{$table}{$field}="null";
		    }
	    }
            if (defined ($glob_nulls{$table}{$field})) {
                $string="$string  $glob_nulls{$table}{$field}";
                #print "-$table- -$field- found a null -$glob_nulls{$table}{$field}-\n";
            }
            # END add null/not null
            if ($rest ne "") { $string="$string  $rest"; }
            $count_num++;
            $string="$string," if ($count_num < $num_fields);
            if ($comment ne "") {
                $string=~ s/\t/        /g;
                $gap="                                                                                   ";
                $gap=substr($gap,0,71-length($string)) if (length($string) < 70);
                $gap=substr($gap,0,70) if (length($string) >= 70);
                $gap="\n$gap" if (length($string) >= 70);
                $string="$string$gap/* $comment */";
            }

            print SQL_C "$string\n";
            print WIKI "|- bgcolor=silver\n";
            print WIKI "|$field\n";
            print WIKI "|$type\n";
            print WIKI "|";
            print WIKI "default $default " if ($default ne ""); 
            print WIKI "$glob_nulls{$table}{$field} " if (defined ($glob_nulls{$table}{$field})); 
            print WIKI "\n";
            print WIKI "|$comment\n";
            print WIKI "|\n";
        }
    }
    #end the wiki table
    print WIKI "|}\n";

    my $count=0;
    my $pkcount=0;
    my $primarykey="";
    my $thisisunique="";
    print WIKI "==Keys==\n";
    foreach $index (sort { $glob_index_order{$table}{$a} <=> $glob_index_order{$table}{$b} }(keys(%{$glob_indexes{$table}}))) {
        if ($index =~ /clustered/) {
            $glob_clustered{$table}="$index";
        }
    }
    if ($glob_clustered{$table} eq "") {
	foreach $index (sort { $glob_index_order{$table}{$a} <=> $glob_index_order{$table}{$b} }(keys(%{$glob_indexes{$table}}))) {
	    if ($index =~ /_pk/) {
		$glob_clustered{$table}="$index";
	    }
	}
    }
    foreach $index (sort { $glob_index_order{$table}{$a} <=> $glob_index_order{$table}{$b} }(keys(%{$glob_indexes{$table}}))) {
        #print "comparing $primarykey and $glob_indexes{$table}{$index}\n";
        if ($primarykey ne "" and  $glob_indexes{$table}{$index} =~ /$primarykey/) {
            $thisisunique="yes";    
        } else {
            $thisisunique="no";    
        }
        #print "  thisisunique $thisisunique\n";
        if ($index =~ /_pk/) {
            $indexsp=$index;
	    my $clustered="";
	    if ($glob_backend eq "sybase") {
		if ($glob_clustered{$table} eq $index) {
		    $clustered="clustered";
		} else {
		    $clustered="nonclustered";
		}
	    }
            $indexsp=~ s/inx_//;
	    if ($glob_backend eq "sybase") {
		print KEY_C "\nprint \"working on table $table\"\n" if ($pkcount == 0);
	    }
            print KEY_C "\nalter table $table\n";
	    print KEY_C "\tadd constraint $indexsp primary key $clustered $glob_indexes{$table}{$index}$cmd_terminator";
            print KEY_D "\n\nalter table $table\n";
	    if ($glob_backend eq "sybase") {
		print KEY_D "\tdrop constraint $indexsp$cmd_terminator";
	    } else {
		print KEY_D "\tdrop primary key$cmd_terminator";
	    }
            print WIKI "* primary key: $indexsp $glob_indexes{$table}{$index}\n"; 
            $primarykey=$glob_indexes{$table}{$index};
            $primarykey=~s/\(//g;
            $primarykey=~s/\)//g;
            $pkcount++;
            $thisisunique="no";    #this would make a duplicate below
        }
        if ($index =~ /_uk/ or $thisisunique eq "yes") {
	    my $clustered="";
	    if ($glob_backend eq "sybase") {
		if ($glob_clustered{$table} eq $index) {
		    $clustered="clustered";
		} else {
		    $clustered="nonclustered";
		}
	    }
            $indexsp=$index;
            $indexsp=~ s/inx_//;
	    if ($glob_clustered{$table} eq $index) {
		if ($glob_backend eq "sybase") {
		    print KEY_C "\nprint \"working on table $table\"\n" if ($pkcount == 0);
		}
		print KEY_C "\nalter table $table\n";
		print KEY_C "\tadd constraint $indexsp unique $clustered $glob_indexes{$table}{$index}$cmd_terminator";
		print KEY_D "\n\nalter table $table\n";
		if ($glob_backend eq "sybase") {
		    print KEY_D "\tdrop constraint $indexsp$cmd_terminator";
		} else {
		    print KEY_D "\tdrop index $indexsp$cmd_terminator";
		}
		print WIKI "* unique key: $indexsp $glob_indexes{$table}{$index}\n"; 
		$pkcount++;
	    } else {
		if ($glob_backend eq "sybase") {
		    print SKEY_C "\nprint \"working on table $table\"\n" if ($pkcount == 0);
		}
		print SKEY_C "\nalter table $table\n";
		print SKEY_C "\tadd constraint $indexsp unique $clustered $glob_indexes{$table}{$index}$cmd_terminator";
		print KEY_D "\n\nalter table $table\n";
		if ($glob_backend eq "sybase") {
		    print KEY_D "\tdrop constraint $indexsp$cmd_terminator";
		} else {
		    print KEY_D "\tdrop index $indexsp$cmd_terminator";
		}
		print WIKI "* unique key: $indexsp $glob_indexes{$table}{$index}\n"; 
		$pkcount++;
	    }
        }
        $count++;
    }
    print SQL_C "\n)$cmd_terminator";
    print WIKI "==Indexes==\n";
    my $count=0;
    foreach $index (sort (keys(%{$glob_indexes{$table}}))) {
        print INX_C "\n\n/* $table */\n" if ($count ==0);
        print INX_D "\n\n/* $table */\n" if ($count ==0);
        #print "$table index $index equals $glob_indexes{$table}{$index}\n";
        my $idx_type="";
        #$idx_type="foreign key" if ($index=~ /_fk/); 
        $idx_type="unique" if ($index=~ /_uk/); 
        #$idx_type="primary key" if ($index=~ /_pk/); 
        if ($glob_clustered{$table} eq $index and $glob_backend eq "sybase") {
            $idx_type = "$idx_type clustered";
        }
        if ($index =~ /_pk$/ or $index =~ /_uk$/ or $glob_clustered{$table} eq $index) {
            print INX_C "/* create $idx_type index $index on $table $glob_indexes{$table}{$index}";
            print INX_C "*/ \n/* go */\n";
            print INX_D "/* drop index $table.$index */ \n/* go */\n";
        } else {
            print INX_C "create $idx_type index $index on $table $glob_indexes{$table}{$index}$cmd_terminator";
	    if ($glob_backend eq "sybase") {
		print INX_D "drop index $table.$index$cmd_terminator";
	    } else {
		print INX_D "alter table $table drop index $index$cmd_terminator";
	    }
            print WIKI "* $index ";
            print WIKI "($idx_type) " if ($idx_type ne "");
            print WIKI "on $table $glob_indexes{$table}{$index}\n";
        }
        $count++;
    }
    $count=0;
    print WIKI "==References==\n";
    foreach $key_name (sort (keys(%{$glob_keys{$table}}))){
        print REF_C "\n\n/* $table */\n" if ($count == 0);
        print REF_D "\n\n/* $table */\n" if ($count == 0);
	if ($glob_backend eq "sybase") {
	    print REF_C "print \"working on table $table\"\n" if ($count == 0);
	}
        print REF_C "alter table $table \n";
        print REF_D "alter table $table \n";
        if ($key_name =~ /_fk/) {
            print REF_C "\tadd constraint $key_name foreign key ($glob_keys{$table}{$key_name}) ";
            print REF_C "$cmd_terminator";
            print REF_C "references $glob_keys{$table}{$key_name}{target}\n";
            print WIKI "* $key_name foreign key ($glob_keys{$table}{$key_name}) ";
            print WIKI  "=> [[Kardia:Tables_$glob_keys{$table}{$key_name}{target}|";
            print WIKI  " $glob_keys{$table}{$key_name}{target}]]\n";
        }
        $count++;
    }
    if ($glob_data{$table}{1} ne "") {
	print WIKI "==Data==\n";
	print "  Data for $table\n";
	if ($glob_backend eq "sybase") {
	    print SQL_C "print \"Data for $table\"\n";
	}
	foreach $dataindex (sort(keys(%{$glob_data{$table}}))) {
	    if ($glob_backend eq "sybase") {
		print SQL_C "insert into $table select $glob_data{$table}{$dataindex}";
		print SQL_C ", s_date_created='3-14-08', s_created_by='IMPORT',";
		print SQL_C "s_date_modified='3-14-08',s_modified_by='IMPORT',__cx_osml_control=null$cmd_terminator";
	    } elsif ($glob_backend eq "mysql") {
		my $cols = $glob_data{$table}{$dataindex};
		$cols =~ s/[^,]* as ([a-zA-Z_][a-zA-Z0-9_]*)/$1/g;
		$cols .= ",s_date_created,s_created_by,s_date_modified,s_modified_by,__cx_osml_control";
		print SQL_C "insert into $table ($cols) select $glob_data{$table}{$dataindex}";
		print SQL_C ", '3-14-08' as s_date_created, 'IMPORT' as s_created_by,";
		print SQL_C "'3-14-08' as s_date_modified, 'IMPORT' as s_modified_by, null as __cx_osml_control$cmd_terminator";
	    }
	}
    }
    # Drop table ###########################
    print SQL_D "\n\n/* $table */\n";      # 
    print SQL_D "drop table $table$cmd_terminator"; #
    ########################################
     
    ####################################### 
    &make_kardia_component($table);    
}

#############
# adddeps()
#############
sub adddep(){
    my ($table)=@_;
    $dependencies=0 if ($table eq "-d");
    $dependencies=1 if ($table eq "+d");
    return if ($table =~ /\-d|\+d/);

    if (grep(/$table/,@tables_to_process)) {
        #It must already have been a dependency.  We got it already
    } else {
        #if it is not a dependency flag, process it
        push(@tables_to_look_at, ($table)) if ($table !~ /\-d|\+d/);
        while ($check_it_out = pop(@tables_to_look_at)) {
            if ($dependencies) {
                #Add this table to the list of ones we have looked at
                push(@tables_to_process, ($check_it_out)) if (not grep(/$check_it_out/,@tables_to_process));
                #add all the tables this is dependent on
                my $field="";
                foreach $field (keys(%{$glob_field{$check_it_out}})) {
                    foreach $link (split /,/, $glob_field{$check_it_out}{$field}{links}) {
                        $link=~s/ //g;
                        push(@tables_to_look_at, ($link));
                    }
                }
            } else {
                push(@tables_to_process, ($check_it_out)) if (not grep(/$check_it_out/,@tables_to_process));
                #just add this table
            }
        }
    }
}

sub processdeps(){
    my $table;
        #Now we process the tables from our list
        foreach $table (sort(@tables_to_process))  {
        print WIKI "[[Kardia:Tables_$table| $table]]\n";    
        }
        foreach $table (sort(@tables_to_process))  {
        print "processing table $table for SQL\n";
                &print_table($table);
        }
}

sub make_kardia_component()
{
    my ($table) = @_;
    $sp4="    ";
    $sp8="        ";
    $sp12="$sp8$sp4";
    $sp16="$sp8$sp8";
    if ( not -e "$component_directory" ) {
        #make the directory
        mkdir ("$component_directory") or die "could not make directory: $component_directory";
    }
    open (CMP, ">$component_directory/${table}.cmp");
    print CMP "\$Version=2\$\n";

    print CMP "${table}_component \"widget/component-decl\"\n    {\n";
    print CMP "${sp4}width=835;height=635;\n";
    print CMP "$sp4${table}_osrc \"widget/osrc\"\n        {\n";

    my $count=0;
    $sql="sql=\"SELECT";
    foreach $field (keys(%{$glob_field{$table}})) {
        $sql="$sql :$field" if ($count == 0);
        $sql="$sql, :$field" if ($count !=0);
        $count++;
    }
    $sql="$sql FROM /lightsys/partner_DB/$table/rows\";";
    #print "sql = $sql\n";
    
    print CMP "$sp8$sql\n";
    print CMP "${sp8}baseobj = \"/lightsys/partner_DB/$table/rows\";\n";
    print CMP "$sp4    replicasize=6;\n";
    print CMP "$sp4    readahead=6;\n";
    print CMP "$sp4    autoquery=onload;\n";
        print CMP "$sp4    ConfirmWindow \"widget/childwindow\"\n";
        print CMP "$sp4        {\n";
        print CMP "$sp4        title = \"Data Was Modified!\";\n";
        print CMP "$sp4        titlebar = yes;\n";
        print CMP "$sp4        hdr_bgcolor=\"#c00000\";\n";
        print CMP "$sp4        bgcolor= \"#e0e0e0\";\n";
        print CMP "$sp4        visible = false;\n";
        print CMP "$sp4        style = dialog;\n";
        print CMP "$sp4        x=200;y=200;width=300;height=140;\n";
        print CMP "\n";
        print CMP "$sp4        warninglabel \"widget/label\"\n";
        print CMP "$sp4            {\n";
        print CMP "$sp4            x=10;y=10;width=276;height=30;\n";
        print CMP "$sp4            text=\"Some data was modified.  Do you want to save it first, discard your modifications, or simply cancel the operation?\";\n";
        print CMP "$sp4            }\n";
        print CMP "\n";
        print CMP "$sp4        _3bConfirmSave \"widget/textbutton\"\n";
        print CMP "$sp4            {\n";
        print CMP "$sp4            x=10;y=75;width=80;height=30;\n";
        print CMP "$sp4            tristate=no;\n";
        print CMP "$sp4            background=\"/sys/images/grey_gradient.png\";\n";
        print CMP "$sp4            text = \"Save\";\n";
        print CMP "$sp4            fgcolor1=black;fgcolor2=white;\n";
        print CMP "$sp4            }\n";
        print CMP "$sp4        _3bConfirmDiscard \"widget/textbutton\"\n";
        print CMP "$sp4            {\n";
        print CMP "$sp4            x=110;y=75;width=80;height=30;\n";
        print CMP "$sp4            tristate=no;\n";
        print CMP "$sp4            background=\"/sys/images/grey_gradient.png\";\n";
        print CMP "$sp4            text = \"Discard\";\n";
        print CMP "$sp4            fgcolor1=black;fgcolor2=white;\n";
        print CMP "$sp4            }\n";
        print CMP "$sp4        _3bConfirmCancel \"widget/textbutton\"\n";
        print CMP "$sp4            {\n";
        print CMP "$sp4            x=210;y=75;width=80;height=30;\n";
        print CMP "$sp4            tristate=no;\n";
        print CMP "$sp4            background=\"/sys/images/grey_gradient.png\";\n";
        print CMP "$sp4            text = \"Cancel\";\n";
        print CMP "$sp4            fgcolor1=black;fgcolor2=white;\n";
        print CMP "$sp4            }\n";
        print CMP "$sp4        }\n";
    print CMP "$sp4    ${table}_form \"widget/form\"\n$sp12\{\n";
    print CMP "${sp12}_3bconfirmwindow = \"ConfirmWindow\";\n";
    print CMP "$sp12${table}_ctl \"widget/component\"\n$sp16\{\n";
    print CMP "${sp16}x=0;y=0;width=835;height=24;\n";
    print CMP "${sp16}path=\"/sys/cmp/form_controls.cmp\";\n";
    print CMP "${sp16}bgcolor=\"#d0d0d0\";\n$sp16\}\n";
    print CMP "$sp12${table}_vbox \"widget/vbox\"\n$sp16\{\n";
    print CMP "${sp16}x=10;y=40;width=800;height=800;cellsize=20; spacing=5;\n";
    my $rowcount=0;
    my $fieldcount=0;
    foreach $field (sort { $glob_field{$table}{$a}{'order'} <=> $glob_field{$table}{$b}{'order'} } (keys(%{$glob_field{$table}}))) {
        #print out the individual hboxes
        #we could ignore the hboxes if there were only three fields, but
        #we will just always do it for now.
        if ($fieldcount == 0) {
            print CMP "$sp16${table}_hbox$rowcount \"widget/hbox\"\n$sp16\{\n";
            print CMP "$sp4${sp16}x=0;y=0;\n";
            print CMP "$sp4${sp16}cellsize=250;\n";
            print CMP "$sp4${sp16}spacing=20;\n";
            print CMP "$sp4${sp16}width=750;\n";
            print CMP "$sp4${sp16}height=25;\n";
        }
        $textfield=$field;
        $textfield=~s/^[^_]*_//;
        $textfield=~s/_/ /g;
        my $ebtype="editbox";
        $ebtype="editbox_modby" if ($field =~ /modified_by/);
        $ebtype="editbox_creby" if ($field =~ /created_by/);
        $ebtype="editbox_moddate" if ($field =~ /date_created/);
        $ebtype="editbox_credate" if ($field =~ /date_modified/);
        print CMP "$sp4$sp16${field}_cmp \"widget/component\" \{ path=\"/lightsys/smart_field.cmp\"; ";
        print CMP "field=$field; text=\"$textfield\"; type=\"$ebtype\"; form=${table}_form; ";
        print CMP "tooltip=\"$glob_field{$table}{$field}{'comment'}\"; \}\n";
        $fieldcount++;
        if ($fieldcount == 3) {
            print CMP "$sp4$sp16\}\n";
            $fieldcount=0;
            $rowcount++;
        }
    }
    if ($fieldcount != 0) {
        #If we did not end with a } already.
        print CMP "$sp4$sp16\}\n";
    }
    print CMP "$sp16\}\n";
    print CMP "$sp12\}\n";
    print CMP "$sp8\}\n";
    print CMP "$sp4\}\n";
    close (CMP);
}

###############################################################
###############################################################
# MAIN
###############################################################
###############################################################

$glob_table="Kardia_DB" if ($glob_table eq "");

if ($ARGV[0] eq "-b") {
    shift;
    $glob_backend = $ARGV[0];
    shift;
}
if ($glob_backend eq "sybase") {
    $cmd_terminator = "\ngo\n";
} elsif ($glob_backend eq "mysql") {
    $cmd_terminator = ";\n";
    $userlist='';
}

if ($ARGV[0] eq "-n" or $ARGV[0] eq "") {
    shift;
    print "When pulling off the web, you may want to delete\n";
    print "the $component_path directory and all the files in it.\n";
    print "This will clear out any unneeded components.\n";
    pull_off_web();
} elsif ($ARGV[0] eq "-?" or $ARGV[0] eq "-h" ) {
    print "Usage: $0 [-b sybase|mysql] [-n|-f|-h]\n";
    print "  -b Output DDL in the given backend format (default: sybase)\n";
    print "  -n Pull data off the Internet (default)\n";
    print "  -f Pull data from a file\n";
    print "  -h This helpfile\n";
    print "  -p Pull data from Petra files\n";
} elsif ($ARGV[0] eq "-f" ) {
    shift;
    while ($#ARGV >= 0) {
        $myfile=$ARGV[0];
        shift;
        if ( not -e "$myfile" ) {
            print "ERROR: The file ($myfile) cannot be found\n";
            exit;
        }
        #We read in the data from the sql file
        print "Parsing $myfile\n";
        &get_data_from_sql($myfile);
    }
} else {
        while ( not -e "$path/p_partner.html" ) {
        print "Cannot find the petra html at $path\n";
        print "Please enter path for html: ";
        $path=<STDIN>;
        chomp($path);
        }
    get_data_from_html();
}
#Read in the data
#process the references
find_links();
#Now we get to print out our files.

# open the files
open(SQL_C,">${sql_out}_create.sql");
open(SQL_N,">database_create.sql");
open(INX_C,">${index_out}_create.sql");
open(REF_C,">${references_out}_create.sql");
open(SEC_C,">${security_out}_create.sql");
open(KEY_C,">${keys_out}_create.sql");
open(SKEY_C,">${sec_keys_out}_create.sql");
open(SQL_D,">${sql_out}_drop.sql");
open(INX_D,">${index_out}_drop.sql");
open(REF_D,">${references_out}_drop.sql");
open(SEC_D,">${security_out}_drop.sql");
open(KEY_D,">${keys_out}_drop.sql");
open(WIKI,">${wiki_out}.txt");


# Logins - use PAM (uses linux passwd)
print SEC_C "use master$cmd_terminator\n";

if ($glob_backend eq "sybase") {
    print SEC_C "sp_addgroup kardiausers$cmd_terminator\n";
}

foreach $a (split /[,\s]+/,$userlist) {
    $a=~s/ //g;
    print SEC_C "if not exists (select * from syslogins where name='$a')\n"; 
    print SEC_C "begin\n";
    print SEC_C "\texecute sp_addlogin $a, dummypassword, \@auth_mech=PAM\n";
    print SEC_C "end\n";
}
print SEC_C "\n\n";


print SEC_C "use $glob_table$cmd_terminator\n";
print SEC_D "use $glob_table$cmd_terminator\n";
#create any users if we need to
foreach $a (split /[,\s]+/,$userlist) {
    $a=~s/ //g;
    print SEC_C "if not exists (select * from sysusers where name='$a')\n"; 
    print SEC_C "begin\n";
    print SEC_C "\texecute sp_adduser $a\n";
    print SEC_C "end\n"
}
print SEC_C "grant select on ra to public$cmd_terminator";
print SEC_D "revoke select on ra to public$cmd_terminator";

#print the "create database" stuff
make_sql_header();
#print notices to ignore page zise warnings
if ($glob_backend eq "sybase") {
    print SQL_C "print \"Ignore any 'Warning: Row size (X bytes) could exceed row size limit...' errors\"\n";
    print INX_C "print \"Ignore any 'Warning: Row size (X bytes) could exceed row size limit...' errors\"\n";
    print REF_C "print \"Ignore any 'Warning: Row size (X bytes) could exceed row size limit...' errors\"\n";
}
#SQL_C "use kardia" is in make_SQL_header
#print "glob_table = $glob_table\n";
#print "glob_table = $glob_table\n";
print SQL_D "use $glob_table$cmd_terminator\n";
print INX_C "use $glob_table$cmd_terminator\n";
print INX_D "use $glob_table$cmd_terminator\n";
print REF_C "use $glob_table$cmd_terminator\n";
print REF_C "use $glob_table$cmd_terminator\n";
print KEY_C "use $glob_table$cmd_terminator\n";
print SKEY_C "use $glob_table$cmd_terminator\n";
print KEY_D "use $glob_table$cmd_terminator\n";

print SQL_D "drop table ra$cmd_terminator";

if ($#ARGV == -1) {
print "Processing everything\n";
    #Now we process every table
    foreach $table (keys( %glob_field)) {
        print "Table: $table\n";
    }
    if (%glob_table_order) { #there is a table order set, use that
        foreach $table (sort { $glob_table_order{$a} <=> $glob_table_order{$b} } (keys (%glob_field)))  {
            print WIKI "* [[Kardia:NewTables_$table| $table]]\n";    
        }
        foreach $table (sort { $glob_table_order{$a} <=> $glob_table_order{$b} } (keys (%glob_field)))  {
            &print_table($table);
        }
    } else { # no table order set, use standard sort
        foreach $table (sort(keys (%glob_field)))  {
            print WIKI "* [[Kardia:Tables_$table| $table]]\n";    
        }
        foreach $table (sort(keys (%glob_field)))  {
            &print_table($table);
        }
    }
} else {
print "Processing dependencies\n";
    $dependencies=1;
    foreach $tryit (@ARGV) {
        chomp $tryit;
        if ($tryit =~ /-h|\/h|-\?|\/\?/) {
            print "\n\nUSAGE:  $ARGV [-n|-f file] ([-d|+d|table]...)\n";
            print "  Use -n as the first argument to download from the wiki instead of\n";
            print "  reading from the Petra html files.\n";
            print "  Use -f as the first option to read in from a sql file.";
            print "  Use -d or +d to enable dependency checking from that point onward.\n";
            print "  Dependency checking is on by default.\n";
            print "  For example:\n";
            print "    # $ARGV p_person -d a_accounting_period +d a_form\n";
            print "  The above example will not check table dependencies for a_accounting_period\n";
            print "  but all the tables which p_person and a_form depend on (recursively)\n";
            print "  will be included in the SQL, along with a_accounting_period (without the\n";
            print "  tables a_accounting_period depends on.)\n\n";
        } else {
            &adddep($tryit);
        }
    }
    processdeps();
}

if ($glob_backend eq "sybase") {
    print SEC_D "sp_dropgroup kardiausers$cmd_terminator\n";
}

make_sql_footer();
close(SQL_C);
close(INX_C);
close(REF_C);
close(SEC_C);
close(KEY_C);
close(SKEY_C);
close(SQL_D);
close(INX_D);
close(REF_D);
close(SEC_D);
close(KEY_D);
close(SQL_N);
close(WIKI);
