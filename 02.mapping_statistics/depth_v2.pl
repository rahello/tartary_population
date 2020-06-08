#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long;

=pod

=head1 Usage
	perl $0 [option] <bam> <outdir>
		-q	base quality
		-Q	mapping quality
		-l	genome size
		-h	help

=cut
		

my ($basethres,$mapQthres,$total_chr,$help);
GetOptions("q:i"=>\$basethres,"Q:i"=>\$mapQthres,"l:i"=>\$total_chr,"h"=>\$help);

$basethres ||= 0;
$mapQthres ||= 0;
die `pod2text $0` if(!$total_chr || $help);

my $bam=shift;
my $outdir=shift;
my $samApp = "samtools";
my $RApp = "R";
mkdir $outdir unless -d $outdir;

open DEPTH,"$samApp depth -q $basethres -Q $mapQthres $bam | " or die;

my %depth=();
my $maxCov=0;
my $Average_sequencing_depth=0;
my $Average_sequencing_depth4=0;
my $Average_sequencing_depth10=0;
my $Average_sequencing_depth20=0;
my $Coverage=0;
my $Coverage4=0;
my $Coverage10=0;
my $Coverage20=0;

my $Coverage_bases=0;
my $Coverage_bases_4=0;
my $Coverage_bases_10=0;
my $Coverage_bases_20=0;

my $total_Coverage_bases=0;
my $total_Coverage_bases_4=0;
my $total_Coverage_bases_10=0;
my $total_Coverage_bases_20=0;

my$total_aa=0;
while(<DEPTH>)
{
	chomp;
	my @arr = split;
        if($arr[2]>=1){
            $depth{$arr[2]}+=1;
            $total_aa++;
        }
}
close DEPTH;

my @depth=sort {$a<=>$b} keys %depth;

open HIS,">$outdir/depth_frequency.txt" or die;
open CUM,">$outdir/cumu.txt" or die;

foreach my $depth1 (sort {$a<=>$b} keys %depth)
{
	next if($depth1==0);
	my $per=$depth{$depth1}/$total_chr;
	$total_Coverage_bases += $depth1*$depth{$depth1};
	$Coverage_bases += $depth{$depth1};

	if($depth1>=4)	
	{
		$total_Coverage_bases_4 += $depth1 * $depth{$depth1};
		$Coverage_bases_4 += $depth{$depth1};
	}
	if($depth1>=10)
	{
		$total_Coverage_bases_10 += $depth1 * $depth{$depth1};
		$Coverage_bases_10 += $depth{$depth1};
	}
	if($depth1>=20)
	{
		$total_Coverage_bases_20 += $depth1 * $depth{$depth1};
 		$Coverage_bases_20 += $depth{$depth1};
	}



	$maxCov=$per if($maxCov<$per);
	my $tmp=0;
	print HIS "$depth1\t$per\n";
	foreach my $depth2(@depth)
	{
		$tmp+=$depth{$depth2} if($depth2 >= $depth1); 
	}
	$tmp=$tmp/$total_chr;
	print CUM "$depth1\t$tmp\n";
}

$Average_sequencing_depth=$total_Coverage_bases/$total_aa;
$Coverage=$Coverage_bases/$total_chr;
$Average_sequencing_depth4=$total_Coverage_bases_4/$total_aa;
$Coverage4=$Coverage_bases_4/$total_chr;
$Average_sequencing_depth10=$total_Coverage_bases_10/$total_aa;
$Coverage10=$Coverage_bases_10/$total_chr;
$Average_sequencing_depth20=$total_Coverage_bases_20/$total_aa;
$Coverage20=$Coverage_bases_20/$total_chr;

open SUM,">$outdir/summary.txt" or die $!;
print SUM "Average_sequencing_depth:\t",sprintf("%.2f",$Average_sequencing_depth),"\n";
print SUM "Coverage:\t",sprintf("%.2f%%",100*$Coverage),"\n";
print SUM "Coverage_at_least_4X:\t",sprintf("%.2f%%",100*$Coverage4),"\n";
print SUM "Coverage_at_least_10X:\t",sprintf("%.2f%%",100*$Coverage10),"\n";
print SUM "Coverage_at_least_20X:\t",sprintf("%.2f%%",100*$Coverage20),"\n";
close SUM;
close HIS;
close CUM;

if(1)
{
	my $ylim = 100*$maxCov;
	my ($xbin,$ybin);
	$ylim= int($ylim) + 1;
	if($ylim <= 3)
	{
		$ybin = 0.5;
	}else{
		$ybin=1;
	}
	my $xlim=0;
	if($Average_sequencing_depth<30)
	{
		$xlim=100;
		$xbin=20;
	}elsif($Average_sequencing_depth < 50)
	{
		$xlim=160;
		$xbin=20;
	}elsif($Average_sequencing_depth  < 120)
	{
		$xlim=250;
		$xbin=50;
	}else{
		$xlim=600;
		$xbin=100;
	}
	&histPlot($outdir,"$outdir/depth_frequency.txt",$ylim,$ybin,$xlim,$xbin);
	&cumuPlot($outdir,"$outdir/cumu.txt",$xlim,$xbin);
	&Seqdepth($outdir,"$outdir/depth_frequency.txt","$outdir/cumu.txt");
}

sub cumuPlot {
	my ($outdir, $dataFile, $xlim, $xbin) = @_;
	my $figFile = "$outdir/cumuPlot.pdf";
	my $Rline=<<Rline;
	pdf(file="$figFile",w=8,h=6)
	rt <- read.table("$dataFile")
	opar <- par()
	x <- rt\$V1[1:($xlim+1)]
	y <- 100*rt\$V2[1:($xlim+1)]
	par(mar=c(4.5, 4.5, 2.5, 2.5))
	plot(x,y,col="red",type='l', lwd=2, bty="l",xaxt="n",yaxt="n", xlab="", ylab="", ylim=c(0, 100))
	xpos <- seq(0,$xlim,by=$xbin)
	ypos <- seq(0,100,by=20)
	axis(side=1, xpos, tcl=0.2, labels=FALSE)
	axis(side=2, ypos, tcl=0.2, labels=FALSE)
	mtext("Cumulative sequencing depth",side=1, line=2, at=median(xpos), cex=1.5 )
	mtext("Fraction of bases (%)",side=2, line=3, at=median(ypos), cex=1.5 )
	mtext(xpos, side=1, las=1, at=xpos, line=0.3, cex=1.4)
	mtext(ypos, side=2, las=1, at=ypos, line=0.3, cex=1.4)
	par(opar)
	dev.off()
	png(filename="$outdir/cumuPlot.png",width = 480, height = 360,type='cairo')
	par(mar=c(4.5, 4.5, 2.5, 2.5))
	plot(x,y,col="red",type='l', lwd=3, bty="l",xaxt="n",yaxt="n", xlab="", ylab="", ylim=c(0, 100))
	xpos <- seq(0,$xlim,by=$xbin)
	ypos <- seq(0,100,by=20)
	axis(side=1, xpos, tcl=0.2, labels=FALSE)
	axis(side=2, ypos, tcl=0.2, labels=FALSE)
	mtext("Cumulative sequencing depth",side=1, line=2, at=median(xpos), cex=1.5 )
	mtext("Fraction of bases (%)",side=2, line=3, at=median(ypos), cex=1.5 )
	mtext(xpos, side=1, las=1, at=xpos, line=0.3, cex=1.5)
	mtext(ypos, side=2, las=1, at=ypos, line=0.3, cex=1.5)
	par(opar)
	dev.off()
	
Rline
	open (ROUT,">$figFile.R");
	print ROUT $Rline;
	close(ROUT);

	system("$RApp CMD BATCH  $figFile.R");
}


sub histPlot {
	my ($outdir, $dataFile, $ylim, $ybin, $xlim, $xbin) = @_;
	my $figFile = "$outdir/histPlot.pdf";
	my $Rline=<<Rline;
	pdf(file="$figFile",w=8,h=6)
	rt <- read.table("$dataFile")
	opar <- par()
	t=sum(rt\$V2[($xlim+1):length(rt\$V2)])
	y=c(rt\$V2[1:$xlim],t)
	y <- y*100
	x <- rt\$V1[1:($xlim+1)]
	par(mar=c(4.5, 4.5, 2.5, 2.5))
	plot(x,y,col="blue",type='h', lwd=1.5, xaxt="n",yaxt="n", xlab="", ylab="", bty="l",ylim=c(0,$ylim),xlim=c(0,$xlim))
	xpos <- seq(0,$xlim,by=$xbin)
	ypos <- seq(0,$ylim,by=$ybin)
	axis(side=1, xpos, tcl=0.2, labels=FALSE)
	axis(side=2, ypos, tcl=0.2, labels=FALSE)
	mtext("Sequencing depth",side=1, line=2, at=median(xpos), cex=1.5 )
	mtext("Fraction of bases (%)",side=2, line=3, at=median(ypos), cex=1.5 )
	end <- length(xpos)-1
	mtext(c(xpos[1:end],"$xlim+"), side=1, las=1, at=xpos, line=0.3, cex=1.4)
	mtext(ypos, side=2, las=1, at=ypos, line=0.3, cex=1.4)
	par(opar)
	dev.off()
	png(filename="$outdir/histPlot.png",width = 480, height = 360, type='cairo')
	par(mar=c(4.5, 4.5, 2.5, 2.5))
	plot(x,y,col="blue",type='h', lwd=1.5, xaxt="n",yaxt="n", xlab="", ylab="", bty="l",ylim=c(0,$ylim),xlim=c(0,$xlim))
	xpos <- seq(0,$xlim,by=$xbin)
	ypos <- seq(0,$ylim,by=$ybin)
	axis(side=1, xpos, tcl=0.2, labels=FALSE)
	axis(side=2, ypos, tcl=0.2, labels=FALSE)
	mtext("Sequencing depth",side=1, line=2, at=median(xpos), cex=1.5 )
	mtext("Fraction of bases (%)",side=2, line=3, at=median(ypos), cex=1.5 )
	end <- length(xpos)-1
	mtext(c(xpos[1:end],"$xlim+"), side=1, las=1, at=xpos, line=0.3, cex=1.5)
	mtext(ypos, side=2, las=1, at=ypos, line=0.3, cex=1.5)
	par(opar)
	dev.off()
Rline
	open (ROUT,">$figFile.R");
	print ROUT $Rline;
	close(ROUT);

	system("$RApp CMD BATCH  $figFile.R");
#	system("rm  $figFile.R  $figFile.Rout");
}

sub Seqdepth {
	my($outDir, $depth_frequency, $cumu) = @_;
	open TEMP,">$outDir/Sequencing-depth.R"||die"Can not open the file:$!";
	print TEMP "
#==========================================================================================
#for pdf
pdf(file='$outDir/Sequencing-depth.pdf',w = 8, h = 6)
rt <- read.table('$depth_frequency')
par()
select_list=seq(from=40,to=100,by=10)
for (j in select_list){
        select_sum=sum(rt\$V2[(j+1):length(rt\$V2)])
        if(select_sum<=0.005){
                break
        }
}
t=sum(rt\$V2[(j+1):length(rt\$V2)])
y=c(rt\$V2[1:j],t)
y <- y*100
x <- rt\$V1[1:(j+1)]
par(mar=c(4.5, 4.5, 2.5, 4.5))
plot(x,y,col='blue',type='l', lwd=3, xaxt='n',yaxt='n', xlab='', ylab='', bty='l',ylim=c(0,max(y)),xlim=c(0,j))
box()
xpos <- seq(0,j,by=10)
ypos <- seq(0,max(y),by=1)
axis(side=1, xpos, labels=FALSE)
axis(side=2, ypos, labels=FALSE)
mtext('Sequencing depth',side=1, line=2, at=median(xpos), cex=1.5 )
mtext('Fraction of bases (%)',side=2, line=3, at=median(ypos), cex=1.5 )
end <- length(xpos)-1
mtext(c(xpos[1:end],paste(j,\"+\",sep=\"\")), side=1, las=1, at=xpos, line=0.8, cex=1.5)
mtext(ypos, side=2, las=1, at=ypos, line=0.8, cex=1.5)
########
par(new=T,ann=F)
#rt1 <- read.table('$cumu')
rt1<-rt
row_index<-nrow(rt)
for(i in 2:row_index){
        rt1[i,2]<-rt1[i-1,2]+rt[i,2]
        i=i+1
}
x1 <- rt1\$V1[1:(j+1)]
y1 <- 100*rt1\$V2[1:(j+1)]
plot(x1,y1,col='red',type='l', lwd=3, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(0, 100))
y1pos <- seq(0,100,by=20)
axis(side=4, y1pos,labels=FALSE)
mtext('Cumulative fraction of bases (%)',side=4, line=3, at=median(y1pos), cex=1.5 )
mtext(y1pos, side=4, las=1, at=y1pos, line=0.8, cex=1.5)
legend('right',legend=c('Sequencing depth','Cumulative sequencing depth'),pch=c(-1),lty=1,lwd=3,col=c('blue','red'),cex=1)
dev.off()
#================================================================================================
#for png
png(filename='$outDir/Sequencing-depth.png',width = 480, height = 360,type='cairo')
rt <- read.table('$depth_frequency')
par()
select_list=seq(from=40,to=100,by=10)
for (j in select_list){
        select_sum=sum(rt\$V2[(j+1):length(rt\$V2)])
        if(select_sum<=0.005){
                break
        }
}
t=sum(rt\$V2[(j+1):length(rt\$V2)])
y=c(rt\$V2[1:j],t)
y <- y*100
x <- rt\$V1[1:(j+1)]
par(mar=c(4.5, 4.5, 2.5, 4.5))
plot(x,y,col='blue',type='l', lwd=3, xaxt='n',yaxt='n', xlab='', ylab='', bty='l',ylim=c(0,max(y)),xlim=c(0,j))
box()
xpos <- seq(0,j,by=10)
ypos <- seq(0,max(y),by=1)
axis(side=1, xpos, labels=FALSE)
axis(side=2, ypos, labels=FALSE)
mtext('Sequencing depth',side=1, line=2, at=median(xpos), cex=1.5 )
mtext('Fraction of bases (%)',side=2, line=3, at=median(ypos), cex=1.5 )
end <- length(xpos)-1
mtext(c(xpos[1:end],paste(j,\"+\",sep=\"\")), side=1, las=1, at=xpos, line=0.8, cex=1.5)
mtext(ypos, side=2, las=1, at=ypos, line=0.8, cex=1.5)
########
par(new=T,ann=F)
#rt1 <- read.table('$cumu')
rt1<-rt
row_index<-nrow(rt)
for(i in 2:row_index){
        rt1[i,2]<-rt1[i-1,2]+rt[i,2]
        i=i+1
}
x1 <- rt1\$V1[1:(j+1)]
y1 <- 100*rt1\$V2[1:(j+1)]
plot(x1,y1,col='red',type='l', lwd=3, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(0, 100))
y1pos <- seq(0,100,by=20)
axis(side=4, y1pos, labels=FALSE)
mtext('Fraction of bases (%)',side=4, line=3, at=median(y1pos), cex=1.5 )
mtext(y1pos, side=4, las=1, at=y1pos, line=0.8, cex=1.5)
legend('right',legend=c('Sequencing depth','Cumulative sequencing depth'),pch=c(-1),lty=1,lwd=3,col=c('blue','red'),cex=1)
dev.off()
#================================================================================================
";
	close TEMP;
	`$RApp -f $outDir/Sequencing-depth.R`;
}
