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
	-i|in	<str>	Input alninfo list;
};
my ($help,$list,$output);
GetOptions(
	"h|help" =>\$help,
	"i|in=s" =>\$list,
	"o|out=s" =>\$output,
);
$output ||="Result";

die "$USAGE" if ($help);

open IN, "$list" or die "Can not open the file:$!";
open OUT,">$output" or die $!;
print OUT "Mapped_Reads\tTotal_reads\tMapping_rate\n";

while(<IN>){
	chomp;
	my $sample=$_;
	open FILE,"$sample" || die $!;
	my $maprate="";
	my $totalreads=0;
	my $mapreads=0;
	my @n1=();
	my @n3=();
	my @n7=();
	my $n=0;
	while(<FILE>){
		$n++;
		chomp;
		my $line=$_;
		if($n==1){
		        @n1=split /\s+/,$line;
			$totalreads=$n1[2];
			};
		if($n==3){
			@n3=split /\s+/,$line;
			$mapreads=$n3[2];
			};
		if($n==7){
			@n7=split /\s+/,$line;
			$maprate=$n7[2];
			$maprate=~s/%$//g;
			};
	}
	print OUT "$mapreads\t$totalreads\t$maprate\n";
}
close IN;
close OUT;
close FILE;
