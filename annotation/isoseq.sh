#!/bin/bash
#
#SBATCH --job-name=isoseq
#SBATCH --cpus-per-task=1
#SBATCH --mem=105000
#SBATCH --partition=himem,basic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=raw.fc-%j.out
#SBATCH --error=raw.fc-%j.err

#https://github.com/PacificBiosciences/IsoSeq_SA3nUP/wiki/Tutorial:-Installing-and-Running-Iso-Seq-3-using-Conda
#conda create -n anaCogent5.2 python=2.7 anaconda

source activate /scratch/luohao/software/pacbio

cpu=16
spe=m54170_180609_130333
ccs /proj/luohao/amphioxus/data/isoseq/bb/$spe.subreads.bam $TMPDIR/$spe.ccs.bam --noPolish --minPasses 1 --numThreads $cpu
#lima --isoseq --dump-clips --no-pbi -j $cpu $spe.ccs.bam /proj/luohao/amphioxus/data/isoseq/adapters.fasta $TMPDIR/$spe.demux.bam
spe=m54170_180609_232412
ccs /proj/luohao/amphioxus/data/isoseq/bb/$spe.subreads.bam $TMPDIR/$spe.ccs.bam --noPolish --minPasses 1 --numThreads $cpu

lima --isoseq --dump-clips --no-pbi -j $cpu $spe.ccs.bam /proj/luohao/amphioxus/data/isoseq/adapters.fasta $TMPDIR/$spe.demux.bam

mv $TMPDIR/* .

dataset create --force --type ConsensusReadSet combined_demux.consensusreadset.xml  *.primer_5p--primer_3p.bam

isoseq3 refine --require-polya combined_demux.consensusreadset.xml /proj/luohao/amphioxus/data/isoseq/adapters.fasta  $TMPDIR/unpolished.flnc.bam
bamtools convert -format fasta -in $TMPDIR/unpolished.flnc.bam > $TMPDIR/flnc.fasta
mv $TMPDIR/flnc.fasta .

# cluster
isoseq3 cluster combined_demux.consensusreadset.xml $TMPDIR/unpolished.bam -j $cpu #--require-polya

# polish
dataset create --force  --type SubreadSet combined.subreads.xml /proj/luohao/amphioxus/data/isoseq/bb/*.subreads.bam
isoseq3 polish -j $cpu $TMPDIR/unpolished.bam  combined.subreads.xml   $TMPDIR/all.polished.bam
mv $TMPDIR/* .

# report - need to rename output files
#python ~/anaconda2/envs/anaCogent5.2/bin/isoseq3_make_classify_report.py all.demux.lima.clips /proj/luohao/amphioxus/data/isoseq/adapters.fasta --flnc_bam all.unpolished.flnc.bam
python /scratch/luohao/amphioxus/annotation/isoseq/bb/cDNA_Cupcake/post_isoseq_cluster/isoseq3_make_cluster_report.py all.polished.bam
