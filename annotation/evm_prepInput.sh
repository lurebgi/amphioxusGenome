gffread $spe.v2.gtf -o $spe.v2.gtf.gff3
les $spe.v2.gtf.gff3 | awk '$3=="exon"' | sed -e 's/exon/cDNA_match/' -e 's/Parent/ID/' > $spe.v2.gtf.evm.gff3
less ../../isoseq/$spe/all.polished.hq.fastq.gff3 | awk '$3=="exon"' | sed 's/exon/cDNA_match/' | sed 's/$spe2_index/isoseq/' | sed 's/exon[0-9]*;Name.*/exon;/' > isoseq.evm.gff3
les protein_alignments.gff3 | sed 's/ID.*Parent/ID/' > protein_alignments.evm.gff3 # protein alignment extracted from MAKER

/apps/snap/2013-11-29/zff2gff3.pl ../../snap/$spe/$spe.snap > $spe.snap.gff3
perl /scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/misc/SNAP_to_GFF3.pl $spe.snap.gff3 > $spe.snap.evm.gff3
perl   /scratch/luohao/software/EVidenceModeler-1.1.1/EvmUtils/misc/augustus_GTF_to_EVM_GFF3.pl <(cat ../../augustus/$spe/chr.out/Chr*.augustus) > $spe.augustus.evm.gff3
cat $spe.snap.evm.gff3 $spe.augustus.evm.gff3 > predictions.gff3
