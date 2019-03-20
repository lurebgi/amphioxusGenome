#!/bin/bash

#SBATCH --job-name=evm
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=8000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err
#SBATCH --constraint=array-1core|array-4core

## run EVM
# step 1: prepare commands
/scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/partition_EVM_inputs.pl  --genome /proj/luohao/amphioxus/assembly/$spe.fa  --gene_predictions predictions.gff3 --protein_alignments protein_alignments.evm.gff3  --transcript_alignments RNA_aln.gff3 --segmentSize 5000000 --overlapSize 100000 --partition_listing partitions_list.out

/scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/write_EVM_commands.pl --weights /scratch/luohao/amphioxus/annotation/evm/bb/weights.txt  --genome /proj/luohao/amphioxus/assembly/bb.fa.190125  --gene_predictions gene_predictions.sort.gff3 --protein_alignments protein_alignments.evm.gff3  --transcript_alignments RNA_aln.gff3  --output_file_name evm.out  --partitions partitions_list.out >  commands.list

# step 2: run evm for each chunk
list=$1
cat $list | sed -n ${SLURM_ARRAY_TASK_ID}p | sh

/scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/recombine_EVM_partial_outputs.pl --partitions partitions_list.out --output_file_name evm.outi
/scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/convert_EVM_outputs_to_GFF3.pl  --partitions partitions_list.out --output_file_name evm.out --genome /proj/luohao/amphioxus/assembly/bb.fa.190125
find . -regex ".*evm.out.gff3" -exec cat {} \; > EVM.all.gff3
