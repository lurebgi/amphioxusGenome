#!/bin/bash

#SBATCH --job-name=GvcfMerge
#SBATCH --partition=himem
#SBATCH --cpus-per-task=1
#SBATCH --mem=210000
#SBATCH --mail-type=FAIL
#SBATCH --output=GvcfMerge.%j.o
#SBATCH --error=GvcfMerge.%j.e


spe=$1

#perl QualFilter.pl $spe.raw.vcf.gz $spe.raw.QualFilter.vcf
/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T GenotypeGVCFs --variant female_1.g.vcf.gz --variant male_1.g.vcf.gz -o All.raw.vcf.gz

# snp
/apps/java/1.8u152/bin/java -Xmx208g  -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T SelectVariants -V All.raw.vcf.gz -selectType SNP -o $TMPDIR/$spe.snp.vcf
/apps/java/1.8u152/bin/java  -Xmx208g -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T VariantFiltration -V $TMPDIR/$spe.snp.vcf --logging_level ERROR --filterExpression " QD < 2.0 || FS > 60.0 || MQRankSum < -12.5 || RedPosRankSum < -8.0 || SOR > 3.0 || MQ < 40.0 " --filterName "my_snp_filter" -o $TMPDIR/$spe.snp.filter.vcf
/apps/java/1.8u152/bin/java  -Xmx208g -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T SelectVariants -V $TMPDIR/$spe.snp.filter.vcf --excludeFiltered -o $TMPDIR/$spe.snp.final.vcf.gz
#mv $TMPDIR/$spe.snp.final.vcf.gz* .

# indel
#/apps/java/1.8u152/bin/java  -Xmx208g  -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T SelectVariants -V $spe.raw.QualFilter.vcf -selectType INDEL -o $TMPDIR/$spe.indel.vcf
#/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T VariantFiltration -V $TMPDIR/$spe.indel.vcf --logging_level ERROR --filterExpression " QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 " --filterName "my_indel_filter" -o $TMPDIR/$spe.indel.filter.vcf
#/apps/java/1.8u152/bin/java -jar /apps/gatk/3.8.0/GenomeAnalysisTK.jar -R $spe.fa -T SelectVariants -V $TMPDIR/$spe.indel.filter.vcf --excludeFiltered -o $TMPDIR/$spe.indel.final.vcf.gz
#mv $TMPDIR/$spe.indel.final.vcf.gz* .

#rm $spe.raw.QualFilter.vcf $spe.snp.vcf $spe.snp.filter.vcf $spe.indel.vcf $spe.indel.filter.vcf
