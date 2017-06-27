module load plink-1.9.0
module load R
cur_chr=$1
folder=$2

#Remove Ambiguous
#post
plink --bfile ${folder}/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.${folder}/${cur_chr}ambiguous.snps.txt --make-bed --out ${folder}/25.ambiguous.removed/${cur_chr}.post.ambiguous.removed

#pre
plink --bfile ${folder}/20.notriallelic.pre/${cur_chr}.pre.notri_tmp --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.${folder}/${cur_chr}ambiguous.snps.txt --make-bed --out ${folder}/25.ambiguous.removed/${cur_chr}.pre.ambiguous.removed

#merge
plink --bfile ${folder}/25.ambiguous.removed/${cur_chr}.pre.ambiguous.removed --bmerge ${folder}/25.ambiguous.removed/${cur_chr}.post.ambiguous.removed --make-bed --allow-no-sex --out ${folder}/26.ambiguous.removed.merged/${cur_chr}.pre.post.no.ambiguous


#****Calculate the Association Values*******
plink --bfile ${folder}/26.ambiguous.removed.merged/${cur_chr}.pre.post.no.ambiguous --assoc --adjust --allow-no-sex --out ${folder}/27.assoc.results/${cur_chr}.results 

#Prepare values for manhattan plot creation
if [ ${cur_chr} = 1 ]
then
awk '{print($2,$1,$3,$9)}' ${folder}/27.assoc.results/${cur_chr}.results.assoc >> ${folder}/28.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
else
awk 'NR >= 2 {print($2,$1,$3,$9)}' ${folder}/27.assoc.results/${cur_chr}.results.assoc >> ${folder}/28.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
fi


# #Make Manhattan Plot
# eval 'Rscript lib/make.manhattan.R'