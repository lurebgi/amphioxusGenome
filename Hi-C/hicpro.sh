#!/bin/bash

#SBATCH --job-name=hicpro
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=14000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err

module load bowtie2 hicpro

#/apps/hicpro/2.10.0/bin/utils/digest_genome.py -r  mboi -o zz.racon2.FINAL.fasta.bed zz.racon2.FINAL.fa
#bowtie2-build zz.racon2.FINAL.fa zz.racon2.FINAL.fa
fa=ZZ-pilon1.fasta.newRef.fa
fa=$1
/apps/hicpro/2.10.0/bin/utils/digest_genome.py -r  mboi -o $fa.bed $fa
samtools faidx $fa
cut -f 1,2 $fa.fai > $fa.sizes

# bowtie2 index
bowtie2-build  $fa  $fa

mkdir rawdata
# prepare soft links of fastq in rawdata, make sure LIGATION_SITE is correct
# create hicpro submission scripts (-p)
HiC-Pro -i rawdata -o rawdata.out -c config-hicpro.txt -p
