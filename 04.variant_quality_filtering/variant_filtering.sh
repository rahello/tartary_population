# The shell is to perform quality filtering for the VCF format variant produced by GATK

java -Xmx20g -jar ./GenomeAnalysisTK.jar  -R  /ref/Ft.HERA.all.fa -T VariantFiltration -V raw.vcf -o raw.filtered.vcf  --clusterWindowSize 10  --filterExpression "MQ0 >= 4 &&((MQ0/(1.0 * DP))> 0.1)" --filterName "HARD_TO_VALIDATE" --filterExpression "DP < 5" --filterName "LowCoverage" --filterExpression "QUAL < 30.0"  --filterName "VeryLowQual" --filterExpression "QUAL > 30.0 && QUAL < 50.0" --filterName "LowQual" --filterExpression "QD<1.5" --filterName "LowQD"
#hard filter step

java -Xmx20g -jar ./GenomeAnalysisTK.jar -T SelectVariants -R  /ref/Ft.HERA.all.fa --variant raw.filtered.vcf  -ef  -o   filtered.passed.vcf 
#hard filter step

/vcftools --vcf filtered.passed.vcf --remove  t.txt  --remove-indels --maf 0.05    --recode --recode-INFO-all --out 510.passed_SNP
#filter samples and sites by vcftools

/vcftools --vcf filtered.passed.vcf --remove t.txt  --keep-only-indels --maf 0.05  --recode --recode-INFO-all --out 510.passed_INDEL
#filter samples and sites by vcftools

/vcftools --vcf filtered.passed.vcf --remove t.txt  --maf 0.05  --recode --recode-INFO-all --out 510.passed_all
#filter samples and sites by vcftools

/vcftools --vcf filtered.passed.vcf  --maf 0.05  --recode --recode-INFO-all --out filtered.passed_SNP_all
#filter samples and sites by vcftools
