#!/bin/bash
#
#SBATCH --job-name=isoseq
#SBATCH --cpus-per-task=16
#SBATCH --mem=55000
#SBATCH --partition=basic,himem
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=raw.fc-%j.out
#SBATCH --error=raw.fc-%j.err

spe=all

source activate /scratch/luohao/software/pacbio
gunzip $spe.polished.hq.fastq.gz
/apps/perl/5.28.0/bin/perl /scratch/luohao/software/pacbio/bin/gmap_build  -D . -d bb2_index /proj/luohao/amphioxus/assembly/bb.fa
gmap -D ./ -d bb2_index -f samse -n 0 -t 20 --cross-species --max-intronlength-ends 80000 -z sense_force   $spe.polished.hq.fastq > $TMPDIR/$spe.polished.hq.fastq.sam   2> $spe.polished.hq.fastq.sam.log

gmap -D ./ -d bb2_index -f gff3_gene -n 0 -t 16 --cross-species --max-intronlength-ends 80000 -z sense_force  $spe.polished.hq.fastq > $spe.polished.hq.fastq.gff3   2> $spe.polished.hq.fastq.sam.log


sort -k 3,3 -k 4,4n $TMPDIR/$spe.polished.hq.fastq.sam > $TMPDIR/$spe.polished.hq.fastq.sorted.sam
collapse_isoforms_by_sam.py --input  $spe.polished.hq.fastq --fq -s $TMPDIR/$spe.polished.hq.fastq.sorted.sam --dun-merge-5-shorter -c 0.6 -i 0.85 -o $spe
mv $TMPDIR/$spe.polished.hq.fastq.sorted.sam* .
get_abundance_post_collapse.py $spe.collapsed cluster_report.csv
filter_by_count.py $spe.collapsed --min_count=3 --dun_use_group_count
filter_away_subset.py $spe.collapsed.min_fl_2
get_abundance_post_collapse.py $spe.collapsed  $spe.polished.cluster_report.csv
