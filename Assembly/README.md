## Diploid assembly
Assemble the hybrid genomes directly using raw reads
```
# bjbf
sbatch falcon.sh fc_run.bjbf.cfg fc_unzip.bjbf.cfg
# bbbf
sbatch
```

Polishing the assembly using arrow
```
# bjbf
sbatch bjbf_pbmm.sh all_p_ctg.fa
sbatch bjbf_arrow_split.sh all_p_ctg.fa
```
## Separating parental reads
Polishing the assembly using pilon
```
# bjbf
sbatch pilon_bjbf.sh
```

Calculating contig coverage of Illumina reads and separate contigs
```
# bjbf
sbatch IlluminaCov_bjbf.sh
paste all_p_ctg.fa.arrow2.fasta.bj.sorted.bam.depth.g all_p_ctg.fa.arrow2.fasta.bf.sorted.bam.depth.g > bj-bf.coverage
cat bj-bf.coverage | awk '$7>10' > bj.list
cat bj-bf.coverage | awk '$14>10' > bf.list
grep 000485F bj-bf.coverage >> bj.list
grep 000464F bj-bf.coverage >> bf.list
grep 000469F  bj-bf.coverage >> bf.list
grep 000465F  bj-bf.coverage >> bf.list
```

Separating Illumina reads
```
# bjbf
sbatch split.read_bjbf.sh
```

Separating Pacbio reads
```
# bjbf
sbatch split.read-pacbio__bjbf.sh
```

## Haploid Assembly
Falcon assembly
```
# bj
sbatch falcon.sh fc_run.bj.cfg
# bf
sbatch falcon.sh fc_run.bf.cfg
```

canu assembly
```
# bj
sbatch canu.sh 'bj.list.pacbio-read.fa.part.*' 390m
# bf
sbatch canu.sh 'bf.list.pacbio-read.fa.part.*' 490m
```

quickmerge
