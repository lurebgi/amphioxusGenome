#!/bin/bash

#SBATCH --job-name=stringtie_bb
#SBATCH --partition=basic
#SBATCH --cpus-per-task=16
#SBATCH --mem=68000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=hisat2-%j.out
#SBATCH --error=hisat2-%j.err

module load stringtie

spe=$1
stringtie $spe.sort.bam  -o $spe.v2.gtf -p 16  -m 300   -j 5 -c 8
