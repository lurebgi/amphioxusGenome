#!/bin/bash

#SBATCH --job-name=bam2gvcf
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=9000
#SBATCH --output=log/%j.bam2gvcf.out
#SBATCH --error=log/%j.bam2gvcf.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at

/apps/java/1.8u152/bin/java -jar /scratch/luohao/software/beagle.28Sep18.793.jar  gt=bb.snp.final.vcf out=bb.snp.final.IM nthreads=8
/scratch/luohao/software/BLINK/blink_linux --gwas --vcf --file bb.snp.final.IM --out bb.snp.final.IM.out
