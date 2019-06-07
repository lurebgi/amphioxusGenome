# author: Jing Liu (jing.liu at univie.ac.at)
#After obtaining vcf file，using beagle/shapeit to do the imputation and phase.

        java -jar beagle.jar gt=snp.vcf out=snp.IM nthreads=8
        shapeit -V snp.imp.vcf --window 0.5 -O snp.IM.Ph --thread 8
#       (output: snp.sample snp.haps)

#Convert the outputs of shapeit to plink format.
        perl getSnpPlink.pl snp.sample snp.haps snp.map snp.ped (map/ped are the classic plink format)
        plink --file snp --out snp --make-bed --allow-extra-chr --allow-no-sex
#        (if you are using the vcf-format output of beagle, you can convert to plink format like: plink --vcf beagle.vcf --allow-extra-chr --double-id --make-bed --out snp)

#generate tped/tfam.
        plink --bfile snp --chr-set 32 --allow-extra-chr --allow-no-sex --recode 12 transpose --output-missing-genotype 0 --out snp
        plink --bfile snp --chr-set 32 --allow-extra-chr --pca --out snp
#        (--chr-set is chrom number)

#make phenotype file.
        awk '{print $1,$2,$6}' snp.tfam > snp.pheno
#        (The pheno format: family_id individual_id sex pheno1 pheno2..
#        Pheno can be quantitative or qualitative, if you want sex as pheno, then don't need pheno columns)

#make covariate file.
#Note: There are other factors influencing, such as the population structure or other traits you think should exclude, then you add those in this file. The format is simliar to .pheno file and just add covariate values from the third column.
#        example: awk 'BEGIN{a=1}{printf("%s %s ",$1,$2);printf("%s ",a);for(i=3;i<6;i++){printf("%s ",$i)}printf("%s","\n")}' snp.eigenvec > snp.cov
#        (here, to exclude the influence of population structure, I add the PCA results to snp.cov. You can always add more, sometimes also the sex trait if you don't want it)

#run emmax.
        emmax-kin -v -h -s -d 10 snp
        emmax-kin -v -h -d 10 snp

        emmax -v -d 10 -t snp -p snp.pheno -k snp.hIBS.kinf -c snp.cov -o snp.hIBS
        emmax -v -d 10 -t snp -p snp.pheno -k snp.hBN.kinf -c snp.cov -o snp.hBN
#        use snp.hBN as the final result

#plot
        ./plot_emmax.R snp
