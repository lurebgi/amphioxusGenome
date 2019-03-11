#!/bin/bash

#SBATCH --job-name=lofreq
#SBATCH --partition=himem,basic
#SBATCH --cpus-per-task=8
#SBATCH --mem=185000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

module load lofreq

genome=$1
cpu=8
#genome=$(echo ${genome0##*/})

#samtools merge -@ 16 $TMPDIR/female.bam bb.fa.female_*.dedup.bam
samtools merge -@ $cpu female.bam $genome.female*bam
samtools index  female.bam
samtools merge -@ $cpu male.bam $genome.male*bam
samtools index  male.bam
#samtools index  $TMPDIR/male.bam

python /apps/lofreq/2.1.2/bin/lofreq2_somatic.py  -n female.bam  -t male.bam   -o male_ -f $genome --threads $cpu --min-cov 10
python /apps/lofreq/2.1.2/bin/lofreq2_somatic.py  -n male.bam  -t female.bam   -o female_ -f $genome --threads $cpu --min-cov 10
