perl /bin/qsub-sge.pl --interval 30 --maxjob 20 --convert no --queue reseq.q --resource vf=4G -lines 1  /00.bin/All.bwa.sh
perl /bin/qsub-sge.pl --interval 30 --maxjob 20 --convert no --queue reseq.q --resource vf=2G -lines 1  /00.bin/popSNP_BWAstat.sh
