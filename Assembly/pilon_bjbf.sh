#!/bin/bash

#SBATCH --job-name=pilon_canu
#SBATCH --partition=basic,himem
#SBATCH --cpus-per-task=20
#SBATCH --mem=388000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

module load pilon bwa samtools

genome=all_p_ctg.fa.arrow2.fasta
#genome=bjbf_v1.fasta


read1=/proj/luohao/amphioxus/data/illumina_bj/WCY-01_R1.fq.gz
read2=/proj/luohao/amphioxus/data/illumina_bj/WCY-01_R2.fq.gz

cp $genome $TMPDIR
bwa index $TMPDIR/$genome

bwa mem -t 20  $TMPDIR/$genome $read1 $read2  |  samtools sort -@ 20 -O BAM -o $TMPDIR/$genome.$size.sorted.bam  -
samtools index $TMPDIR/$genome.$size.sorted.bam

samtools view -@ 20 -h -f 2 -q 10 $TMPDIR/$genome.$size.sorted.bam  | awk '$NF!~/XA/ || $1~/@/' | samtools view - -O BAM -o $TMPDIR/filt.bam -@ 20
samtools index $TMPDIR/filt.bam

#java -Xmx358G  -jar /apps/pilon/1.22/pilon-1.22.jar  --genome $TMPDIR/$genome --frags $TMPDIR/filt.bam --output bjbf_v1 --changes --threads 16 --minmq 30 --mindepth 20 --fix bases
java -Xmx358G  -jar /apps/pilon/1.22/pilon-1.22.jar  --genome $TMPDIR/$genome --frags $TMPDIR/filt.bam --output bjbf_v2 --changes --threads 20 --minmq 30 --mindepth 20 --fix bases
