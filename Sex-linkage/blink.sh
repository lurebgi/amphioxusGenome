#!/bin/bash

#SBATCH --job-name=bam2gvcf
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=9000
#SBATCH --output=log/%j.bam2gvcf.out
#SBATCH --error=log/%j.bam2gvcf.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at

module load vcftools
vcftools --gzvcf bb.snp.final.vcf.gz  --max-missing 0.9 --maf 0.05 --min-meanDP 5 --recode --recode-INFO-all --out  $TMPDIR/bb.snp.final.filter.vcf
mv $TMPDIR/bb.snp.final.filter.vcf* .

/apps/java/1.8u152/bin/java -Xmx158G -jar /scratch/luohao/software/beagle.28Sep18.793.jar  gt=bb.snp.final.filter.vcf.recode.vcf out=bb.snp.final.filter.vcf.recode.IM.vcf nthreads=12
sed -i  -e 's/Chr//' -e 's#0|#0/#g' -e 's#1|#1/#g' bb.snp.final.filter.vcf.recode.IM.vcf.vcf
/scratch/luohao/software/BLINK/blink_linux --gwas --vcf --file bb.snp.final.filter.vcf.recode.IM.vcf --out bb.snp.final.IM.out
