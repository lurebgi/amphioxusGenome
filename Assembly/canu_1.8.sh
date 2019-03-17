#!/bin/bash

#SBATCH --job-name=canu.bj_hap
#SBATCH --partition=himem
#SBATCH --cpus-per-task=48
#SBATCH --mem=500000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=canu-%j.out
#SBATCH --error=canu-%j.err

#module load canu
module unload java

fa=$1
size=$2

/apps/perl/5.28.0/bin/perl /scratch/luohao/software/canu-1.8/Linux-amd64/bin/canu  -p hap -d $TMPDIR/7000-2000.errorRate java=/apps/java/1.8u152/bin/java \
genomeSize=$size rawErrorRate=0.3, minReadLength=7000 minOverlapLength=2000 corOutCoverage=200 correctedErrorRate=0.15  \
-pacbio-raw $fa  gnuplotTested=true stopOnReadQuality=false  \
maxMemory=900G maxThreads=24 ovlThreads=24 \
gridOptions="--partition=basic,himem --nice=9000" useGrid=True

rsync -qr   $TMPDIR/7000-2000.errorRate .
