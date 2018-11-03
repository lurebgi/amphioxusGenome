#!/bin/bash
#
#SBATCH --job-name=split
#SBATCH --cpus-per-task=12
#SBATCH --mem=10000
#SBATCH --partition=himem
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=pbalign-%j.out
#SBATCH --error=pbalign-%j.err

module load bwa
ref=bjbf_v2.fasta
mkdir index
bwa index $ref -p index/$ref
cp index/$ref* $TMPDIR

# map reads
bwa mem -t 12  $TMPDIR/$ref /proj/luohao/amphioxus/data/illumina_bj/WCY-01_R1.fq.gz /proj/luohao/amphioxus/data/illumina_bj/WCY-01_R2.fq.gz | samtools sort -@ 12 -O SAM -o $TMPDIR/sam

samtools view -L bj.list.bed -h -m 100 -q 20 -F 256 $TMPDIR/sam  | samtools sort -n -@ 12 -O SAM -o $TMPDIR/bj.list.bed.sam &
samtools view -L bf.list.bed -h -m 100 -q 20 -F 256 $TMPDIR/sam  | samtools sort -n -@ 12 -O SAM -o $TMPDIR/bf.list.bed.sam

# filtering
cat $TMPDIR/bj.list.bed.sam | awk '$7=="=" || $1~/@/' | samtools view -O BAM -o $TMPDIR/bj.list.bed.filt.sam
cat $TMPDIR/bf.list.bed.sam | awk '$7=="=" || $1~/@/' | samtools view -O BAM -o  $TMPDIR/bf.list.bed.filt.sam


bamToFastq -i $TMPDIR/bj.list.bed.filt.sam -fq $TMPDIR/bj.list.bed.1.fq -fq2 $TMPDIR/bj.list.bed.2.fq
gzip $TMPDIR/bj.list.bed.1.fq &
gzip $TMPDIR/bj.list.bed.2.fq &

bamToFastq -i $TMPDIR/bf.list.bed.filt.sam -fq $TMPDIR/bf.list.bed.1.fq -fq2 $TMPDIR/bf.list.bed.2.fq
gzip $TMPDIR/bf.list.bed.1.fq
gzip $TMPDIR/bf.list.bed.2.fq

mv $TMPDIR/bj.list.bed.*.fq.gz .
mv $TMPDIR/bf.list.bed.*.fq.gz .
