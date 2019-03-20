#!/bin/bash

#SBATCH --job-name=hisat2_bb
#SBATCH --partition=basic
#SBATCH --cpus-per-task=16
#SBATCH --mem=38000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=hisat2-%j.out
#SBATCH --error=hisat2-%j.err

spe=$1
module load hisat2

hisat2-build $spe.fa $spe.fa

cp $spe.fa* $TMPDIR

read1=/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-1_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-2_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-3_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_male-1_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-1_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-2_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-3_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-1_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-2_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-3_1.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-4_1.trimmed.fq.gz
read2=/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-1_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-2_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_female-3_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gm_male-1_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-1_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-2_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_female-3_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-1_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-2_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-3_2.trimmed.fq.gz,/proj/luohao/amphioxus/data/RNA_seq_bb/trimmed/bb_gum_male-4_2.trimmed.fq.gz

hisat2 -x $TMPDIR/$spe.fa -p 16 -1 $read1 -2 $read2 -S $TMPDIR/$spe.sam -k 4 --max-intronlen 80000 --min-intronlen 30
hisat2 -x $TMPDIR/$spe.fa -p 16 -1 $read1 -2 $read2 -S $TMPDIR/$spe.sam -k 4 --max-intronlen 50000 --min-intronlen 30 --dta-cufflinks

samtools view -@ 16 -h -q 10  $TMPDIR/$spe.sam | samtools sort - -@ 16 -O BAM -o $TMPDIR/$spe.sort.bam
samtools view -@ 16 -h -q 10  $TMPDIR/$spe.sam | samtools sort - -@ 16 -O BAM -o $TMPDIR/$spe.sort.cuff.bam

mv $TMPDIR/$spe.sort.bam .
mv $TMPDIR/$spe.sort.cuff.bam .
samtools index $spe.sort.bam
samtools index $spe.sort.cuff.bam
