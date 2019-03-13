#!/bin/bash

#SBATCH --job-name=gatk_genotype
#SBATCH --partition=himem
#SBATCH --cpus-per-task=1
#SBATCH --mem=185000
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=luohao.xu@univie.ac.at
#SBATCH --output=depth-%j.out
#SBATCH --error=depth-%j.err

#module unload java
#module load java/1.8u152

spe=$1
ref=$spe.fa
samtools faidx $ref
java -jar /apps/picard_tools/2.14.0/picard.jar CreateSequenceDictionary R=$spe.fa O=$spe.dict

sample=$2
java -jar /apps/picard_tools/2.14.0/picard.jar MarkDuplicates I=$ref.$sample.sorted.filt.bam O=$ref.$sample.dedup.bam M=$sample.m
samtools index $ref.$sample.dedup.bam

java -jar /apps/picard_tools/2.14.0/picard.jar AddOrReplaceReadGroups I=$ref.$sample.dedup.bam O=$ref.$sample.dedup.bam.rg.bam RGID=4$sample RGLB=lib$sample RGPU=unit1 RGSM=$sample RGPL=illumina
samtools index $ref.$sample.dedup.bam.rg.bam

java -Xmx83g  -jar  /apps/gatk/3.8.0/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $ref.$sample.dedup.bam.rg.bam --emitRefConfidence GVCF -o $ref.$sample.dedup.bam.rg.bam.g.vcf.gz -nct 12
