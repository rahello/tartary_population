#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;

die "Usage:perl $0 <aln.bam> [<mapping quality>]" if @ARGV<1;

my $bin="/samtools-0.1.19";
my $clean_reads=0;
my $clean_bases=0;
my $mapped_reads=0;
my $mapped_bases=0;
my $mapping_rate=0;
my $mismatch_bases=0;
my $mismatch_rate=0;
my $cut_q = $ARGV[2];
my $cut_mis = $ARGV[3];
if(not $cut_q){
	$cut_q = 0;
}
if(not $cut_mis){
	$cut_mis = 5;
}

my %hash;
open BAM,"$bin/samtools view -h -X $ARGV[0] | " or die;
open Stat,">$ARGV[1]" || die $!;
while(<BAM>)
{
		chomp;
		my $info=$_;
		if($_=~m/^@/){
			print $info,"\n";
			next;
		}
		my @info=split /\s+/,$info;
		if($info[1]=~/s/){
			next;
		};
		$clean_reads++;
		$clean_bases+=length($info[9]);
		unless($info[1]=~/u/)
		{
		  	if($info=~/XC:i:(\d+)/){$mapped_reads++;$mapped_bases+=$1;}
			else{$mapped_reads++;$mapped_bases+=length($info[9]);}
			if($info=~/NM:i:(\d+)/){
				$mismatch_bases+=$1;
					print $info,"\n";
			}
		}
}
#$mapped_bases=$mapped_bases-$mismatch_bases;
$mismatch_rate=$mismatch_bases/$mapped_bases;
$mapped_bases=$mapped_bases-$mismatch_bases;
$mapping_rate=$mapped_reads/$clean_reads;

print Stat "clean reads:\t$clean_reads\n";
print Stat "clean bases(bp):\t$clean_bases\n";
print Stat "mapped reads:\t$mapped_reads\n";
print Stat "mapped bases(bp):\t$mapped_bases\n";
print Stat "mismatch bases(bp):\t$mismatch_bases\n";
print Stat "mismatch rate:\t",sprintf("%.2f%%",100*$mismatch_rate),"\n";
print Stat "mapping rate:\t",sprintf("%.2f%%",100*$mapping_rate),"\n";

close BAM;
