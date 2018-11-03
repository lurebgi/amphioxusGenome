#!/bin/bash

#SBATCH --job-name=arrow
#SBATCH --partition=basic,himem
#SBATCH --cpus-per-task=8
#SBATCH --mem=98000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

module load pilon bwa samtools pbsmrt


genome=all_p_ctg.fa

pbmm2 index $genome $genome.mmi

cp $genome.mmi $TMPDIR

cat bam.list | while read line; do  pbmm2 align /proj/luohao/amphioxus/data/pacbio_bj/$line  $TMPDIR/$genome.mmi -j 20 --min-length 1000 | samtools sort -@ 20 -O BAM -o $TMPDIR/$line.bam; done

samtools merge -@ 16 $TMPDIR/$genome.merged.bam $TMPDIR/*.bam

mv $TMPDIR/$genome.merged.bam .
samtools index $genome.merged.bam
pbindex $TMPDIR/$genome.merged.bam
mv $TMPDIR/$genome.merged.bam .
