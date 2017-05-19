module load plink-1.9.0
module load R
cur_chr=$1

#Remove Ambiguous
#ancient
plink --bfile inter.files/15.flipped.snps/${cur_chr}.flipped.monomorphic --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.anc.modern/${cur_chr}ambigious.snps.txt --make-bed --out inter.files/17.ambiguous.removed/${cur_chr}.anc.ambiguous.removed

#pobi
plink --bfile inter.files/13.notriallelic/${cur_chr}.pobi.notri_tmp --exclude /ebc_data/awwohns/selection_v4/references/ambiguous.snps.anc.modern/${cur_chr}ambigious.snps.txt --make-bed --out inter.files/17.ambiguous.removed/${cur_chr}.pobi.ambiguous.removed

#merge
plink --bfile inter.files/17.ambiguous.removed/${cur_chr}.anc.ambiguous.removed --bmerge inter.files/17.ambiguous.removed/${cur_chr}.pobi.ambiguous.removed --make-bed --allow-no-sex --out inter.files/18.ambiguous.removed.merged/${cur_chr}.anc.pobi.no.ambiguous


#****Calculate the Association Values*******
plink --bfile inter.files/18.ambiguous.removed.merged/${cur_chr}.anc.pobi.no.ambiguous --assoc --adjust --allow-no-sex --out inter.files/19.assoc.results/${cur_chr}.results 

#Prepare values for manhattan plot creation
if [ ${cur_chr} = 1 ]
then
awk '{print($2,$1,$3,$9)}' inter.files/19.assoc.results/${cur_chr}.results.assoc >> inter.files/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
else
awk 'NR >= 2 {print($2,$1,$3,$9)}' inter.files/19.assoc.results/${cur_chr}.results.assoc >> inter.files/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt
fi


