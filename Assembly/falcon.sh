#!/bin/bash
#
#SBATCH --job-name=falcon
#SBATCH --cpus-per-task=1
#SBATCH --mem=5000
#SBATCH --partition=basic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=raw.fc-%j.out
#SBATCH --error=raw.fc-%j.err

cfg=$1
unzip=$2

module unload  pbsmrt mummer samtools minimap2
export PATH=/scratch/luohao/software/minimap2-2.12_x64-linux/:$PATH
source /scratch/luohao/software/falcon/fc_env_180904/bin/activate

/proj/luohao/amphioxus/*bam  | while read line; do samtools index $line; pbindex $line; done

/proj/luohao/amphioxus/*bam  | while read line;  do bam2fasta -u $line -o $line.fa ; done

# falcon
fc_run.py $cfg

# falcon unzip
#python /apps/pbsmrt/20171207/bin/fc_unzip.py fc_unzip.cfg
fc_unzip.py $unzip

#trace reads
#python -m falcon_kit.mains.fetch_reads

# 1-hsam
#python2.7 -m pypeflow.do_task /scratch/luohao/Fish/pacbio_assembly/falcon_6k/3-unzip/1-hasm/rid-to-phase-all/task.json
