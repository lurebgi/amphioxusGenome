## Falcon assembly
Assemble the hybrid genomes directly using raw reads
```
# bjbf
sbatch bjbj_falcon.sh
# bbbf
sbatch
```

Polishing the assembly using arrow
```
# bjbf
sbatch bjbf_pbmm.sh
sbatch bjbf_arrow_split.sh
```
## Separating parental reads
Polishing the assembly using pilon
```
# bjbf
sbatch pilon_bjbf.sh
```

Calculating contig coverage of Illumina reads
```
# bjbj
sbatch IlluminaCov_bjbf.sh
paste all_p_ctg.fa.arrow2.fasta.bj.sorted.bam.depth.g all_p_ctg.fa.arrow2.fasta.bf.sorted.bam.depth.g > bj-bf.coverage
cat bj-bf.coverage | awk '$7>10' > bj.list
cat bj-bf.coverage | awk '$14>10' > bf.list
grep 000485F bj-bf.coverage >> bj.list
grep 000464F bj-bf.coverage >> bf.list
grep 000469F  bj-bf.coverage >> bf.list
grep 000465F  bj-bf.coverage >> bf.list
```
