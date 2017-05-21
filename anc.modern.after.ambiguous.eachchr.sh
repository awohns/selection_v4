module load plink-1.9.0
module load R
cur_chr=$1
folder=$2

#Remove Ambiguous
#ancient
plink --bfile ${folder}/15.flipped.snps/${cur_chr}.flipped.monomorphic --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.${folder}/${cur_chr}ambiguous.snps.txt --make-bed --out ${folder}/17.ambiguous.removed/${cur_chr}.anc.ambiguous.removed

#pobi
plink --bfile ${folder}/13.notriallelic/${cur_chr}.pobi.notri_tmp --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.${folder}/${cur_chr}ambiguous.snps.txt --make-bed --out ${folder}/17.ambiguous.removed/${cur_chr}.pobi.ambiguous.removed

#merge
plink --bfile ${folder}/17.ambiguous.removed/${cur_chr}.anc.ambiguous.removed --bmerge ${folder}/17.ambiguous.removed/${cur_chr}.pobi.ambiguous.removed --make-bed --allow-no-sex --out ${folder}/18.ambiguous.removed.merged/${cur_chr}.anc.pobi.no.ambiguous


#****Calculate the Association Values*******
plink --bfile ${folder}/18.ambiguous.removed.merged/${cur_chr}.anc.pobi.no.ambiguous --assoc --adjust --allow-no-sex --out ${folder}/19.assoc.results/${cur_chr}.results 

#Prepare values for manhattan plot creation
if [ ${cur_chr} = 1 ]
then
awk '{print($2,$1,$3,$9)}' ${folder}/19.assoc.results/${cur_chr}.results.assoc >> ${folder}/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
else
awk 'NR >= 2 {print($2,$1,$3,$9)}' ${folder}/19.assoc.results/${cur_chr}.results.assoc >> ${folder}/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
fi


# #Make Manhattan Plot
# eval 'Rscript lib/make.manhattan.R'