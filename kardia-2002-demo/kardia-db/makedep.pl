#!/usr/bin/perl -w
# vim: set ts=4 : #
use strict;
use Data::Dumper;

=cut

$Log: makedep.pl,v $
Revision 1.9  2002/04/24 23:16:11  jorupp
 * partial build is now working right (I think)
 * anytime a file is removed, make sure to do a make clean to clean up the leftovers
 * added annotation and Centrallix key generation stuff

Revision 1.8  2002/04/24 01:19:21  jorupp
 * I think I finally got this....

Revision 1.7  2002/04/23 23:09:12  jorupp
 * lots of changes....

Revision 1.6  2002/04/23 21:28:15  jorupp
 * .depend file is a little cleaner -- no duplicates

Revision 1.5  2002/04/23 20:06:40  jorupp
 * I'm trying to get logging turned on in this file.....


=cut

my $deps={};

my @FILES=@ARGV;
my @SQLFILES=@FILES;

my $file;
sub findtable
{
	my($table)=@_;
	foreach my $f (@SQLFILES)
	{
						# only match an $f with /data/ if $table has data/
		if($f=~/$table.sql$/ && ( $f=~m#/data/# || $table!~m#^data/#) )
		{						
			return $f;
		}
	}
	print STDERR "Could not find match for $table in $file !!!!!!!\n";
	return "";
}


undef $/;

while($file=shift @FILES)
{
	if(!$file) { next; }
	print "kardia_sys/keys.sql: $file\n";
	if($file=~m#/data/#)
	{
		open(HANDLE,"gcc -x c -E -P $file | ");
		my ($tablefile)=($file=~/([A-Za-z_]+)\.sql/);
		while(<HANDLE>)
		{
			next unless ((length $_)>0);
			print "$file: $file\n";
			$$deps{$file}={};
			my @tables;
			@tables=($_=~/INSERT INTO ([A-Za-z_]+)/gi);
			foreach my $table (@tables)
			{
				my $tbl=&findtable($table);
				next if($$deps{$file}{$tbl});
				$$deps{$file}{$tbl}=1;
				print "$file: $tbl\n";

				$table=~s#^#data/#;
				$tbl=&findtable($table);
				next if($$deps{$file}{$tbl});
				$$deps{$file}{$tbl}=1;
				print "$file: $tbl\n";

				#foreach my $tbl (keys %{$$deps{$tablefile}})
				#{
				#	next if($$deps{$file}{$tbl});
				#	$$deps{$file}{$tbl}=1;
				#	$tbl=~s#^#data/#;
				#	my $t=&findtable($tbl);
				#	print "$file: $t\n" if ($t);
				#}
			}
		}
		close(HANDLE);
	} else {
		open(HANDLE,"gcc -x c -E -P $file | ");
		my ($tablefile)=($file=~/([A-Za-z_]+)\.sql/);
		$$deps{$tablefile}={};
		my $refs=0;
		while(<HANDLE>)
		{
			next unless ((length $_)>0);
			print "$file: $file\n";
			my @tables;
			@tables=($_=~/REFERENCES\s+([A-Za-z_]+)/gi);
			foreach my $table (@tables)
			{
				if($$deps{$tablefile}{$table}) { next; }
				$refs++;
				$$deps{$tablefile}{$table}=1;
				my $t=&findtable($table);
				print "$file: $t\n" if ($t);
			}
		}
		#$refs=0;
		# the following line ensures that there is always a line in the .depend file, even if there is no parent

		close(HANDLE);
	}
}
