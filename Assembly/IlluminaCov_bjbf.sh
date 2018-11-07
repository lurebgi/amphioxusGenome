#!/bin/bash

#SBATCH --job-name=bwa
#SBATCH --partition=basic,himem
#SBATCH --cpus-per-task=20
#SBATCH --mem=18000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

#cat fa_a*.arrow.fasta | sed 's/|arrow.*//' > all_p_ctg.fa.arrow2.fasta

module load bwa samtools bedtools
genome0=$1
#genome0=all_p_ctg.fa.arrow2.fasta
read1=$2
read2=$3

genome=$(echo ${genome0##*/})

if [ ! -f ${genome0}.bwt ] ; then
bwa index $genome0 #-p $genome
fi
cp $genome0 $TMPDIR
bwa index $TMPDIR/$genome

samtools faidx $genome0
bedtools makewindows -g $genome0.fai -w 50000 > $genome.scf-len.50k-win
cut -f 1,2 $genome0.fai > $genome.fai.g
cut -f 1,2 $genome0.fai | awk '{print $1"\t1\t"$2}' > $genome.fai.bed

#bf
size=bf
read1=/proj/luohao/amphioxus/data/illumina_bf/bf_R1.fq.gz
read2=/proj/luohao/amphioxus/data/illumina_bf/bf_R2.fq.gz

bwa mem -t 20  $TMPDIR/$genome $read1 $read2  |  samtools sort -@ 20 -O BAM -o $TMPDIR/$genome.$size.sorted.bam  -
samtools index $TMPDIR/$genome.$size.sorted.bam
samtools depth -m 300 -Q 59 $TMPDIR/$genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a $genome.fai.bed -g $genome.fai.g -b - -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.g
samtools depth -m 300 -Q 59 $TMPDIR/$genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a $genome.scf-len.50k-win  -b - -g $genome.fai.g -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.50k


#bj
size=bj
read1=/proj/luohao/amphioxus/data/illumina_bj/NGS/Project_s025g01133-g01134-r04042-1_20171120_6samples/Sample_R17017994LD01/R17017994LD01_combined_R1.fastq.gz
read2=/proj/luohao/amphioxus/data/illumina_bj/NGS/Project_s025g01133-g01134-r04042-1_20171120_6samples/Sample_R17017994LD01/R17017994LD01_combined_R2.fastq.gz

bwa mem -t 20  $TMPDIR/$genome $read1 $read2  |  samtools sort -@ 20 -O BAM -o $TMPDIR/$genome.$size.sorted.bam  -
samtools index $TMPDIR/$genome.$size.sorted.bam
samtools depth -m 300 -Q 59 $TMPDIR/$genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a $genome.fai.bed -g $genome.fai.g -b - -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.g
samtools depth -m 300 -Q 59 $TMPDIR/$genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a $genome.scf-len.50k-win  -b - -g $genome.fai.g -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.50k
