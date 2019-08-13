#!/bin/bash

#SBATCH --job-name=guidance
#SBATCH --partition=basic
#SBATCH --cpus-per-task=1
#SBATCH --mem=4000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=nuc-%j.out
#SBATCH --error=nuc-%j.err

guidence=/proj/zongji/Genome-scale_phylogeny_of_Paleognathous_birds/guidance.v2.02/www/Guidance/guidance.pl
prank=/apps/prank/170427/bin/prank
gene=$1

perl  $guidence  --seqFile /scratch/luohao/BOP/rubra_zw/paml/$gene.cds --msaProgram PRANK --seqType codon  --outDir /scratch/luohao/BOP/rubra_zw/paml/$gene.out --prank $prank --bootstraps 10
#~/bin/trimal -in $gene/$gene.out/MSA.PRANK.Without_low_SP_Col.With_Names -out $gene/$gene.cds.phy -phylip_paml
