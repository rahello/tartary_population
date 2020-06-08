#!/usr/bin/perl
use strict;
use warnings;
use PerlIO::gzip;
use Getopt::Long qw(:config no_ignore_case);
my $USAGE = qq{
Name:
	$0
Fuction:
	This is used to 
Useage:
	$0 options
Options:
	-h|help		Print this help
	-o|out 	<str>   Prefix for output file;
	-i|in	<str>	Input depthresult list;

 ;
};
my ($help,$list,$output);
GetOptions(
	"h|help" =>\$help,
	"i|in=s" =>\$list,
	"o|out=s" =>\$output,
);
$output ||="Result";

die "$USAGE" if ($help);
open LS, "$list" or die "Can not open the file:$!";
open OUT,">$output" or die $!;
print OUT "Average_depth\tCoverage_at_least 1X\tCoverage_at_least_4X\n";

while(<LS>){
	chomp;
	my $sample=$_;
	open FILE, "$sample" || die $!;
	my $depth=0;
	my $coverage1x=0;
	my $coverage4x=0;
	while(<FILE>){
		chomp;
		my $seq=$_;
		my @arr=split /\s+/,$seq;
		if($arr[0]=~/depth/){
			$depth=$arr[1];
		}
		elsif($arr[0]=~/^Coverage:/){
			$coverage1x=$arr[1];
			$coverage1x=~s/%$//g;
		}
		elsif($arr[0]=~/4X/){
			$coverage4x=$arr[1];
			$coverage4x=~s/%$//g;
		}
		else{
			next;
		}
	}
	print OUT "$depth\t$coverage1x\t$coverage4x\n";
}
close LS;
close OUT;
close FILE;
