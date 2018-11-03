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
rsync  $genome $genome.fai $TMPDIR

## split genome to speed up arrow polishing
mkdir fa_split
cat all_p_ctg.fa.fai | sort -k2R | split -l 20 - fa_split/

ls fa_split | grep -v fa | while read line; do

cat fa_split/$line | seqkit grep -f - $genome > $TMPDIR/$line.fa; samtools faidx $TMPDIR/$line.fa
cat fa_split/$line | awk '{printf $1" "}' | sed 's#^#samtools view -h $genome.merged.bam #' | sed "s#$  -O BAM -o $TMPDIR/$line.bam##" | sh;

arrow -j8 $TMPDIR/$line.bam  -r $TMPDIR/$line.fa  -o fa_split/$line.arrow.fasta -o fa_split/$line.variants.gff;

done
