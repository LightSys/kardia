#!/usr/bin/perl -w
# vim: set ts=4 : #

=cut

$Log: build.pl,v $
Revision 1.12  2004/01/15 14:50:33  jorupp
 * add support for views in build.pl
 * add a view that I found lying around my account - I think we were planning to use this for something

Revision 1.11  2002/04/24 23:16:11  jorupp
 * partial build is now working right (I think)
 * anytime a file is removed, make sure to do a make clean to clean up the leftovers
 * added annotation and Centrallix key generation stuff

Revision 1.10  2002/04/24 02:51:56  jorupp
 * small changes, cleaning up spacing issues

Revision 1.9  2002/04/24 01:46:30  jorupp
 * allow successful insert

Revision 1.8  2002/04/24 01:19:21  jorupp
 * I think I finally got this....

Revision 1.7  2002/04/23 23:09:12  jorupp
 * lots of changes....

Revision 1.6  2002/04/23 22:59:08  jorupp
luke broke my script

Revision 1.5  2002/04/23 21:29:40  jorupp
 * a little bit more cleanup...

Revision 1.4  2002/04/22 22:41:39  jorupp
 * a new version of the scripts used to manage db schema changes
 * this isn't extensively tested yet, I need the schema files working first, and some data files to test with, but it appears to work...

Revision 1.3  2002/04/19 17:53:45  jorupp
 * the build script now 'detects' and reports isql errors right after a script is run
 * it will only mark the script as run if it runs successfully

=cut
use strict;

# configuration parameters
my $username=$ENV{'USER'};
# the following is for sybase
my $sqlcmd=$ENV{"SYBASE"}."/bin/isql -U$username";
my $passwordasfirstcommand=1;
my $beginSQLcommand='';
my $endSQLcommand="\ngo\n";
my $quitcmd="quit\n";
my $dieonfailure=1;
my $promptonfailure=0;
my $gccflags="-D__END__='go' -DUNSIGNED='' -Dunsigned=''";

my $password;
# this can be hard-coded if you wish...
if(!($password=`cat .pass`))
{
	print "Password for $username: ";
	$password=<STDIN>;
	chomp($password);
}

# time script started, used to update .buildtime later
my $starttime=time;

# hash ref of parent -> child
my $parent;

# hash ref of child -> parent
my $child;

# hash ref to array ref, [0] is last update [1] is mod time
my $times;

# load list of dependencies
if(open(DEPS, ".depend"))
{
	while($_=<DEPS>)
	{
		my($c,$p);
		if((($c,$p)=($_=~/(.*):\s*(.*)/)))
		{
			$$parent{$p}{$c}=1;
			if($c ne $p) { $$child{$c}{$p}=1; }
		}
	}
	close(DEPS);
} else {
	die("Critical Error: .depend cannot be opened.  Run 'make depend' to create it.\n    $!");
}

# load all files and last build time
if(open(BUILD, ".buildtime"))
{
	while($_=<BUILD>)
	{
		my($table,$time)=($_=~/(.*): (.*)/);
		$$times{$table}[0]=int($time);
	}
	close(BUILD);
}

# make sure all files in $parent are in $times
foreach my $f (keys %$parent)
{
	if(!$$times{$f})
	{
		$$times{$f}[0]=0;
	}
}


# load mod times on all files in .buildtime
#foreach my $file (keys %$times)
foreach my $file (keys %$times)
{
	if(my @stat=stat($file))
	{
		$$times{$file}[1]=$stat[9];
	} else {
		warn ("\"$file\" not found....\n");
		undef $$times{$file};
		undef $$parent{$file};
		undef $$child{$file};
	}
}

# hash of files to build
my %build;

# command line arguments
my @args=@ARGV;
if(!$args[0]) { unshift @args,"all"; }

while( my $file = shift @args)
{
	# don't process .depend....it's something extra from the makefile
	if($file eq ".depend") { next; }

	if($file eq "all")
	{
		foreach my $f (keys %$parent)
		{
			&ProcessFile($f);
		}
	} else {
		&ProcessFile($file);
	}
}

sub ProcessFile
{
	my($file)=@_;
	if($$times{$file} && $$times{$file}[1]>$$times{$file}[0])
	{
		&buildtable($file);
	}
}

# marks a table to be rebuilt, also marks all children to be rebuilt as well
sub buildtable
{
	my($table)=@_;
	$build{$table}=1;
	foreach my $child (keys %{$$parent{$table}})
	{
		if(!$build{$child})
		{
			&buildtable($child);
		}
	}
}

# sorting subroutine
#  if $a is a parent of $b, $a needs to be built first
#  if $b is a parent of $a, $b needs to be build first
#  otherwise, the are 'equal'

=pod
sub sortbuild ($$)
{
	my($a,$b)=@_;
	if($$parent{$a}{$b}) { return 1; }
	elsif($$parent{$b}{$a}) { return -1; }
	else { return 0; }
}


sub mysort (@)
{
	my(@array)=@_;
	my($i,$j,$t);
	print "$#array\n";
	for($i=0;$i<$#array-1;$i++)
	{
		for($j=0;$j<$#array-1;$j++)
		{
			if(&sortbuild($array[$j],$array[$j+1])<=0)
			{
				#print "$array[$j] <-> $array[$j+1]\n";
				$t=$array[$j];
				$array[$j]=$array[$j+1];
				$array[$j+1]=$t;
			}
		}
	}
	return @array;
}
=cut

my %levels;

#foreach my $f (keys %$parent)
#{
#	#print "$f ==> ".(keys %{$$parent{$f}})." == > ".(keys %{$$child{$f}})."\n";
#	if((keys %{$$child{$f}})==0)
#	{
#		#print "==> $f\n";
#		$levels{$f}=1;
#	}
#}

while(keys %$parent>keys %levels)
{
#	print "Starting with ".(keys %levels)." out of ".(keys %$parent)."\n";
	foreach my $f (keys %$parent)
	{
		if($levels{$f}) { next; }
#		print " --> $f\n";
		my $max=0;
		my $error=0;
		if((keys %{$$child{$f}})==0)
		{
			$levels{$f}=1;
			next;
		}
		foreach my $f2 (keys %{$$child{$f}})
		{
#			print "$f2 is a parent of $f\n";
			if(!$levels{$f2})
			{
				$error=1;
				last;
			}
			if($levels{$f2}>$max)
			{
				$max=$levels{$f2};
#				print " ==> $f ==> $f2 => $max\n";
			}
		}
		if($error==0)
		{
			$levels{$f}=int($max+1);
#			print " ==> $f --> $levels{$f}\n";
		}
	}
#	sleep(1);
}


# order to add tables in
my @buildorder;

# order to drop tables in
my @droporder;

# sort using above function
## NOTE: it is possible that a > b, b > c, c ? d, and b < d, so 
##   I have it sort a bunch of times....not sure if it's strictly necessary or not...

@buildorder=sort {$levels{$a}<=>$levels{$b} || $a cmp $b } (keys %build);
@droporder=reverse @buildorder;

my %check;
foreach my $file (@buildorder)
{
	$check{$file}=1;
	foreach my $parent (keys %{$$child{$file}})
	{
		if(!$check{$parent})
		{
			die("$parent is not scheduled to be built before $file\n");
		}
	}
}

if(0)
{
	print "Here's the build order output, for debugging purposes:\n";
	use Data::Dumper;
	print Dumper(\%levels);
	print Dumper(\%check);
	print Dumper(\@buildorder);
	die();
}

# drop all tables marked to be droped, and update build times
# by doing this in order, dependencies should be taken care of

$SIG{'PIPE'} = sub { die "pipe problems...$!"; };

#print "$sqlcmd\n";

use IPC::Open2;
use IO::Select;
my $stdinsel=IO::Select->new();
$stdinsel->add(\*STDIN);

sub RunSqlCommands
{
	my ($fromserver,$toserver);
	my $conpid = open2($fromserver,$toserver,"$sqlcmd");
	print $toserver "$password\n";

	my $texttosend="${beginSQLcommand}".$_[0]."${endSQLcommand}${quitcmd}";

	print $toserver $texttosend;
	my $result=join('',<$fromserver>);
	$result=~s/Password: \n//g;
	$result=~s/\([\d]+ row.* affected\)\n//g;
	if($result && !($_[1]) && $texttosend!~/create table #tmptable/) 
	{
		$texttosend=~s/^/    /gm;
		$result=~s/^/    /gm;
		print "===================ERROR DETECTED==================\n";
		print "We sent: \n",$texttosend,"\n";
		print "Server sent back:\n",$result,"\n";
		
		if($dieonfailure) { die "SQL Error(s) detected\n"; }
		if($promptonfailure)
		{
			print "Hit enter to abort\n";
			if($stdinsel->can_read(.5)) { my $eatit=<STDIN>; die "SQL Error(s) detected\n"; }
		}
		return 0;
	}
	return 1;

}

foreach my $file (@droporder)
{
	if($file!~m#/data/#)
	{
		my $type="TABLE";
		if ($file=~/_view.sql/) { $type="VIEW"; }
		($file)=($file=~m#([^/]*)\.sql$#);
		if(&RunSqlCommands("if exists(select name from sysobjects where name='$file')\nDROP $type $file"))
		{
			print "DROP $type ==> $file\n";
		}
	} else {
		($file)=($file=~m#([^/]*)\.sql$#);
		if (&RunSqlCommands("if exists(select name from sysobjects where name='$file')\ntruncate table $file"))
		{
			print "DROP DATA  ==> $file\n";
		}
	}
}

# add all tables marked to be added, and update build times
# by doing this in order, dependencies should be taken care of
foreach my $file (@buildorder)
{
	my $texttosend="$beginSQLcommand";

	open(FILE,"gcc -x c -E -P $gccflags $file | ");
	$texttosend.=join('',<FILE>);
	close(FILE);
	
	if(&RunSqlCommands($texttosend))
	{
		$$times{$file}[0]=$starttime;
		if($file=~m#/data/#)
		{
			($file)=($file=~m#([A-Za-z_]+)\.sql#);
			print "INSERT ==> $file\n";
		} else{
			($file)=($file=~m#([A-Za-z_]+)\.sql#);
			print "CREATE ==> $file\n";
		}
	}
}

$SIG{'PIPE'}=sub {};

open(BUILD, ">.buildtime");
foreach my $f (keys %$parent)
{
	print BUILD "$f: ".$$times{$f}[0]."\n";
}
close(BUILD);
