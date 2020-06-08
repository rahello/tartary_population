conda init --all
conda activate base
conda activate TESTxpclr
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft1 --size 200000  --step 100000 --out ./north-vs-hr_Ft1.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft3 --size 200000  --step 100000 --out ./north-vs-hr_Ft3.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft4 --size 200000  --step 100000 --out ./north-vs-hr_Ft4.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft5 --size 200000  --step 100000 --out ./north-vs-hr_Ft5.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft6 --size 200000  --step 100000 --out ./north-vs-hr_Ft6.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft7 --size 200000  --step 100000 --out ./north-vs-hr_Ft7.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft8 --size 200000  --step 100000 --out ./north-vs-hr_Ft8.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  north.txt --samplesB  group1-other --chr Ft2 --size 200000  --step 100000 --out ./north-vs-hr_Ft2.out

xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft1 --size 200000  --step 100000 --out ./south-vs-hr_Ft1.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft3 --size 200000  --step 100000 --out ./south-vs-hr_Ft3.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft4 --size 200000  --step 100000 --out ./south-vs-hr_Ft4.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft5 --size 200000  --step 100000 --out ./south-vs-hr_Ft5.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft6 --size 200000  --step 100000 --out ./south-vs-hr_Ft6.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft7 --size 200000  --step 100000 --out ./south-vs-hr_Ft7.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft8 --size 200000  --step 100000 --out ./south-vs-hr_Ft8.out
xpclr --input /ku/510.passed_SNP.recode.vcf --samplesA  south.txt --samplesB  group1-other --chr Ft2 --size 200000  --step 100000 --out ./south-vs-hr_Ft2.out