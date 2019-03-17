#!/bin/bash

#SBATCH --job-name=maker_bb3
#SBATCH -N 3
#SBATCH --ntasks-per-node=7
#SBATCH --ntasks-per-core=1
#SBATCH --mem=9000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=maker-%j.out
#SBATCH --error=maker-%j.err

spe=$1
module load maker

unset  AUGUSTUS_CONFIG_PATH
export AUGUSTUS_CONFIG_PATH=/scratch/luohao/Fish/annotation/augustus/config

# bb
srun -n 16  maker -base run0 -fix_nucleotides  maker_opts.run0-bb.ctl  maker_bopts-bb.ctl  maker_exe.ctl
# bj & bf
srun -n 16  maker -base run0_$spe -fix_nucleotides  maker_opts.run0-$spe.ctl  maker_bopts.ctl  maker_exe.ctl
