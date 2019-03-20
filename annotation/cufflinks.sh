#!/bin/bash

#SBATCH --job-name=cufflinks_bj
#SBATCH --partition=basic,himem
#SBATCH --cpus-per-task=12
#SBATCH --mem=68000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=hisat2-%j.out
#SBATCH --error=hisat2-%j.err

module load cufflinks

spe=$1
cufflinks $spe.sort.cuff.bam -b $spe.fa -p 12  –multi-read-correct –max-intron-length 30000 
