########################################
vcftools --vcf /ku/north.passed_all.mis0.95.recode.vcf     --window-pi 200000 --window-pi-step 200000  --out north_200k
vcftools --vcf /ku/south.passed_all.mis0.95.recode.vcf    --window-pi 200000 --window-pi-step 200000 --out  south_200k
vcftools --vcf /ku/root.passed_all.mis0.95.recode.vcf    --window-pi 200000 --window-pi-step 200000 --out  root_200k
########################################
vcftools --vcf /ku/510.passed_all_snp.mis0.95.recode.vcf  --weir-fst-pop south.txt  --weir-fst-pop north.txt --fst-window-size 200000 --fst-window-step 200000 --out  south_north_200k
vcftools --vcf /ku/510.passed_all_snp.mis0.95.recode.vcf  --weir-fst-pop root.txt  --weir-fst-pop south.txt --fst-window-size 200000 --fst-window-step 200000 --out  root_south_200k
vcftools --vcf /ku/510.passed_all_snp.mis0.95.recode.vcf  --weir-fst-pop root.txt  --weir-fst-pop north.txt --fst-window-size 200000 --fst-window-step 200000 --out  root_north_200k
########################################
perl /bin/fst_pi_common.pl  south_north_200k.windowed.weir.fst south_200k.windowed.pi  north_200k.windowed.pi  0 | sort -k1,1 -k2,2n > south_north_200k.fst_pi.diversity
#sed -i "s/Ft/chr/g"  south_north.fst_pi.diversity
perl /bin/draw_fst_pi_v1.pl  south_north_200k.fst_pi.diversity   south-north_200k  0.05

perl /bin/fst_pi_common.pl  root_south_200k.windowed.weir.fst root_200k.windowed.pi  south_200k.windowed.pi  0 | sort -k1,1 -k2,2n > root_south_200k.fst_pi.diversity
#sed -i "s/Ft/chr/g"  root_south.fst_pi.diversity
perl /bin/draw_fst_pi_v1.pl  root_south_200k.fst_pi.diversity   root-south_200k  0.05

perl /bin/fst_pi_common.pl  root_north_200k.windowed.weir.fst root_200k.windowed.pi  north_200k.windowed.pi  0 | sort -k1,1 -k2,2n > root_north_200k.fst_pi.diversity
#sed -i "s/Ft/chr/g"  root_south.fst_pi.diversity
perl /bin/draw_fst_pi_v1.pl  root_north_200k.fst_pi.diversity   root-north_200k  0.05
