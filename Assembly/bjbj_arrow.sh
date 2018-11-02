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


genome=all_p_ctg.fa.arrow.fasta

pbmm2 index $genome $genome.mmi

cp $genome.mmi $TMPDIR

cat bam.list | while read line; do  pbmm2 align /proj/luohao/amphioxus/data/pacbio_bj/$line  $TMPDIR/$genome.mmi -j 20 --min-length 1000 | samtools sort -@ 20 -O BAM -o $TMPDIR/$line.bam; done

samtools merge -@ 16 $TMPDIR/$genome.merged.bam $TMPDIR/*.bam

mv $TMPDIR/$genome.merged.bam .
samtools index $genome.merged.bam
#pbindex $TMPDIR/$genome.merged.bam
#mv $TMPDIR/$genome.merged.bam .




## split genome to speed up arrow polishing
mkdir fa_split
cat all_p_ctg.fa.fai | sort -k2R | split -l 20 - fa_split/
ls fa_split/ | while read line; do cat fa_split/$line | seqkit grep -f - all_p_ctg.fa > fa_split/$line.fa; done

#line=$1
rsync  $genome $genome.fai $TMPDIR
rsync fa_split/$line.fa $TMPDIR
samtools faidx $TMPDIR/$line.fa
#cat fa_split/$line | awk '{printf $1" "}' | sed 's#^#samtools view -h $genome.merged.bam #' | sed "s#$  -O BAM -o $TMPDIR/$line.bam##" | sh

#arrow -j8 $TMPDIR/$genome.merged.bam  -r $TMPDIR/$line.fa  -o $line.arrow.fasta -o $line.variants.gff
