#!/bin/bash
#
#SBATCH --job-name=augustus_bb
#SBATCH --cpus-per-task=16
#SBATCH --mem=9000
#SBATCH --partition=basic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=raw.fc-%j.out
#SBATCH --error=raw.fc-%j.err

spe=$1

module load snap augustus
maker2zff -c 0.99 -e 0.99 -o 0.99 -l 800 -x 0.01 run0_$spe.maker.gff

fathom genome.ann genome.dna -gene-stats > gene-stats.log 2>&1
fathom genome.ann genome.dna -validate > validate.log 2>&1
fathom genome.ann genome.dna -categorize 1000 > categorize.log 2>&1
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
mkdir params
cd params
forge ../export.ann ../export.dna
#cd ..
hmm-assembler.pl $spe .  > ../$spe.hmm
cd ..
mv genome.ann $spe.genome.ann

## augustus
zff2gff3.pl $spe.genome.ann |  perl -plne 's/\t(\S+)$/\t\.\t$1/' > $spe.initial.gff3
new_species.pl --species=$spe  --AUGUSTUS_CONFIG_PATH=/scratch/luohao/Fish/annotation/augustus/config
gff2gbSmallDNA.pl $spe.initial.gff3 genome.dna 1000 $spe.gb
etraining --AUGUSTUS_CONFIG_PATH=/scratch/luohao/Fish/annotation/augustus/config  --species=$spe $spe.gb

/apps/perl/5.28.0/bin/perl /apps/augustus/3.3/scripts/optimize_augustus.pl --AUGUSTUS_CONFIG_PATH=/scratch/luohao/Fish/annotation/augustus/config  --species=$spe $spe.gb --kfold=16  --cpus=16 1>$spe.augustOpt.stdout 2>$spe.augustOpt.stderr
