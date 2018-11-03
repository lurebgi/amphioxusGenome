#!/bin/bash
#
#SBATCH --job-name=split
#SBATCH --cpus-per-task=2
#SBATCH --mem=10000
#SBATCH --partition=basic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=pbalign-%j.out
#SBATCH --error=pbalign-%j.err

module load bwa pbsmrt seqkit

cat bam.list | while read line; do

/scratch/luohao/software/minimap2-2.12_x64-linux/minimap2 --secondary=no -x map-pb -a -t 2 bjbf_v2.fasta $TMPDIR/$line.fasta > $TMPDIR/$line.fasta.sam

cat $TMPDIR/$line.fasta.sam | awk 'BEGIN{while(getline < "bj.list"){bj[$1]=3}}{if(bj[$3]==3){print $1} }' | seqkit grep -f - $TMPDIR/$line.fasta >> bj.list.pacbio-read.fa.part.$line
cat $TMPDIR/$line.fasta.sam | awk 'BEGIN{while(getline < "bf.list"){bf[$1]=3}}{if(bf[$3]==3){print $1} }' | seqkit grep -f - $TMPDIR/$line.fasta >> bf.list.pacbio-read.fa.part.$line

done
