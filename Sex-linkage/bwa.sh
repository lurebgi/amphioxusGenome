#!/bin/bash

#SBATCH --job-name=bwa
#SBATCH --partition=basic
#SBATCH --cpus-per-task=8
#SBATCH --mem=5000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

module load bwa
genome0=$1
read1=$2
read2=$3
size=$4
cpu=8

genome=$(echo ${genome0##*/})
#cp $genome0 .

if [ ! -f ${genome0}.bwt ] ; then
bwa index $genome0 #-p $genome
fi
#cp ${genome0}.bwt ${genome0}.pac ${genome0}.ann ${genome0}.amb ${genome0}.sa ${genome0}  $TMPDIR
#bwa mem -t $cpu  $TMPDIR/$genome $read1 $reads  |  samtools sort -@ $cpu  -O BAM -o $TMPDIR/$genome.$size.sorted.bam  -
#mv $TMPDIR/$genome.$size.sorted.bam .

bwa mem -t $cpu $genome $read1 $reads  |  samtools sort -@ $cpu  -O BAM -o $genome.$size.sorted.bam  -
samtools index $genome.$size.sorted.bam

# entire contig
samtools faidx $genome0
cut -f 1,2 $genome0.fai > $genome.fai.g
#cut -f 1,2 $genome.fai | awk '{print $1"\t1\t"$2}' > $genome.fai.bed
#samtools depth -m 300 -Q 59 $genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a $genome.fai.bed -g $genome.fai.g -b - -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.g

#50k
bedtools makewindows -g $genome0.fai.g -w 50000 > $genome.scf-len.50k-win
samtools depth -m 180 -Q 59 $genome.$size.sorted.bam  | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' |  bedtools map -a  $genome.scf-len.50k-win -b - -c 4 -o median,mean,count  > $genome.$size.sorted.bam.depth.bed.50k-win
