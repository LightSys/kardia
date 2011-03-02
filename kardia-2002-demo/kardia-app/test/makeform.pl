#!/usr/bin/perl -w

use strict;
use warnings;
my $lx=10;	# label x
my $dx=180;	# data x
my $cx=340; # shift $cx right for new column

my $sy=40;	# starting y
my $iy=20;	# amount to increment y per row

my $lw=170;	# label width
my $dw=120;	# data width

my $h=15;	# height
my $ls='raised';	# label style
my $ds='raised';	# data style

my $y=$sy;
my $count=0;
my $split=int((@ARGV)/2+.5);
#print "$count --> $split)\n";
foreach my $field (@ARGV)
{
	print<<"_END_";
				${field}_label "widget/label" {
					x=$lx; y=$y; width=$lw; height=$h; style="$ls"; text="$field:";align="right";
				}
				${field}_data "widget/editbox" {
					x=$dx; y=$y; width=$dw; height=$h; style="$ds"; fieldname="$field";
				}
_END_
	$y+=$iy;
	$count++;
	if ($count==$split)
	{
		$lx+=$cx;
		$dx+=$cx;
		$y=$sy;
	}
}
