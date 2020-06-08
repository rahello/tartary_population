# The directory of input and output files was just a example, please adjust it when doing a real running

#For instance, the input is genome000.bed of genome , call variants for all samples 

#Step:
java -Xmx20g -jar ./GenomeAnalysisTK.jar  -nt 4 -glm BOTH -T UnifiedGenotyper  -I  bam.list  -R \ 
/ref/Ft.HERA.all.fa   -L \
/bed/genome000.bed	-o ./raw000.vcf	-metrics	./unifiedgenotype.000.txt -stand_call_conf 50 -stand_emit_conf 10 -dcov 1000 -A Coverage -A AlleleBalance
