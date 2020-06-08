/bin/gff3ToGenePred /ref/Ft.IGDBv1.Allset.gff3 /anno/lib/Buckwheat.outGP &&  echo This-Work-is-Completed!
awk 'BEGIN { OFS="\t" } { print FNR, $_ }' /anno/lib/Buckwheat.outGP > /anno/lib/Buckwheat.outGP.tmp &&  echo This-Work-is-Completed!
perl /bin/genepredformat.pl -i /anno/lib/Buckwheat.outGP -o /anno/lib/Buckwheat_refGene.txt &&  echo This-Work-is-Completed!
perl /bin/retrieve_seq_from_fasta.pl -format genericGene -seqfile /ref/Ft.HERA.all.fa -outfile /anno/lib/Buckwheat_refGeneMrna.fa /anno/lib/Buckwheat.outGP.tmp

perl /bin/convert2annovar.pl -format vcf4 -snpqual 0 Ft4.filted.indel.vcf > 510.passed_INDEL_Ft4.avinput
perl /bin/annotate_variation.pl -buildver Buckwheat -geneanno 510.passed_INDEL_Ft4.avinput /anno/lib
perl /bin/split_snpindel.pl -i 510.passed_INDEL_Ft4.avinput.exonic_variant_function -i1 6 -i2 7 -indel 510.passed_INDEL_Ft4.avinput.exonic_variant_function.indel -snp 510.passed_INDEL_Ft4.avinput.exonic_variant_function.snp
perl /bin/split_snpindel.pl -i 510.passed_INDEL_Ft4.avinput.variant_function -i1 5 -i2 6 -indel 510.passed_INDEL_Ft4.avinput.variant_function.indel -snp 510.passed_INDEL_Ft4.avinput.variant_function.snp
perl /bin/statNonsyn.pl -fai Ft.HERA.all.fa.fai -ann 510.passed_INDEL_Ft4.avinput.exonic_variant_function -stp 10000 -wsz 50000 -out /anno/ku
