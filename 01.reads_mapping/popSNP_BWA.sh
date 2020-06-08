sample=$1
ref=$2
read1=$3
read2=$4
length=$5
length_noN=$6

echo step bwa mem
bwa mem -t 4 -k 32 -M -R "@RG\tID:$sample\tLB:$sample\tSM:$sample\tPL:illumina\tPU:$sample" $ref $read1 $read2 |/samtools view  -bhSt $ref.fai - >/BWA/$sample.bam
echo step mapping rate and sort bam
perl /4.BWA/bin/stat_bwa_mem_v4.pl /BWA/$sample.bam /aln/$sample.alninfo | /samtools view -q 30 -bS - |/samtools sort -m 30000000000 - /BWA/$sample.sort
echo step stat coverage rate 
perl /4.BWA/bin/depth_v2.pl -l $length /BWA/$sample.sort.bam /coverage/$sample.withN
perl /4.BWA/bin/depth_v2.pl -l $length_noN /BWA/$sample.sort.bam /coverage/$sample.noN
echo  index and remove
samtools index /BWA/$sample.sort.bam 
rm /BWA/$sample.bam
echo finish!

