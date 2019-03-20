#!/bin/bash

#SBATCH --job-name=snap
#SBATCH -N 1
#SBATCH --mem=5000
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=maker-%j.out
#SBATCH --error=maker-%j.err

chr=$1
spe=$2
module load snap


snap  ../../training/$spe/$spe.hmm  $spe.fa > $spe.snap
