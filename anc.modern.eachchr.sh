#!/bin/bash
#
#BATCH --job-name=haplo_plink
#SBATCH --output=haplo_plink.txt
#
#SBATCH --ntasks=1
#SBATCH --time=60:00:00
#SBATCH --mem-per-cpu=50g

cur_chr=$1
maxmis=$2
bams_list=$3
folder=$4

module load angsd-0.913-22 
module load plink-1.9.0
module load R

#Perform haplocall
angsd -b references/${bams_list} -doHaploCall 1 -doCounts 1 -out ${folder}/1.haplo/${cur_chr}  -r ${cur_chr} -maxMis ${maxmis} -sites references/pobi.snps.by.chr/${cur_chr}.se.pobi.bim.chr.pos.txt

#Convert to tped
/storage/software/angsd-0.913-22/misc/haploToPlink ${folder}/1.haplo/${cur_chr}.haplo.gz ${folder}/2.tped/${cur_chr}

#Replace N's with 0's
eval 'sed 's/N/0/g' ${folder}/2.tped/${cur_chr}.tped  > ${folder}/3.tped.nto0/temp.${cur_chr}.tped'

#Copy the tfam file
eval 'cp ${folder}/2.tped/${cur_chr}.tfam ${folder}/3.tped.nto0/temp.${cur_chr}.tfam'

#Convert tped to ped
plink --tfile ${folder}/3.tped.nto0/temp.${cur_chr} --recode --out ${folder}/4.ped/${cur_chr}_ped

#Add the rsids
plink --file ${folder}/4.ped/${cur_chr}_ped --update-map references/pobi.snps.by.chr/${cur_chr}.se.pobi.bim.txt --update-name --make-bed --out ${folder}/5.add.rsid/${cur_chr}.with.rsid

#Find intersected SNPS between ancient and pobi
plink --bfile ${folder}/5.add.rsid/${cur_chr}.with.rsid --extract references/pobi.snps/${cur_chr}.se.pobi.bim.snps.only.txt --make-bed --out ${folder}/6.intersect/${cur_chr}.intersected.anc.pobi

#Add phenotypes to intersected list
cp ${folder}/6.intersect/* ${folder}/7.intersect.pheno/
awk '{$6 = "2";print $0 }' ${folder}/6.intersect/${cur_chr}.intersected.anc.pobi.fam > ${folder}/7.intersect.pheno/${cur_chr}.intersected.anc.pobi.fam


#Get list of SNPs intersected from the ancient dataset
cut -f2 ${folder}/7.intersect.pheno/${cur_chr}.intersected.anc.pobi.bim > ${folder}/8.anc.snps/${cur_chr}.anc.snps.txt


#Extract the overlapping SNPs from POBI
plink --bfile references/se.england.pobi/se.england.pobi --extract ${folder}/8.anc.snps/${cur_chr}.anc.snps.txt --make-bed --out ${folder}/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps

#Merge pobi and ancient
plink --bfile ${folder}/7.intersect.pheno/${cur_chr}.intersected.anc.pobi --bmerge ${folder}/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --make-bed --out ${folder}/10.merged/${cur_chr}.merge

#Flip the missnps
plink --bfile ${folder}/7.intersect.pheno/${cur_chr}.intersected.anc.pobi --flip ${folder}/10.merged/${cur_chr}.merge-merge.missnp --make-bed --out ${folder}/11.merged.flipped/${cur_chr}.merge.flipped

#Remerge after the flip
plink --bfile ${folder}/11.merged.flipped/${cur_chr}.merge.flipped --bmerge ${folder}/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --make-bed --out ${folder}/12.remerged/${cur_chr}.pobi.anc

#Final exclude and merge
plink --bfile ${folder}/11.merged.flipped/${cur_chr}.merge.flipped --exclude ${folder}/12.remerged/${cur_chr}.pobi.anc-merge.missnp --make-bed --out ${folder}/13.notriallelic/${cur_chr}.anc.notri_tmp
plink --bfile ${folder}/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --exclude ${folder}/12.remerged/${cur_chr}.pobi.anc-merge.missnp --make-bed --out ${folder}/13.notriallelic/${cur_chr}.pobi.notri_tmp
plink --bfile ${folder}/13.notriallelic/${cur_chr}.anc.notri_tmp --bmerge ${folder}/13.notriallelic/${cur_chr}.pobi.notri_tmp --make-bed --allow-no-sex --out ${folder}/13.notriallelic/${cur_chr}.anc.pobi.notri

#Find Monomorphic Problems
Rscript lib/flip.mono.problems.R ${cur_chr}

#Flip the monomorphic SNPs
plink --bfile ${folder}/13.notriallelic/${cur_chr}.anc.notri_tmp --flip ${folder}/14.snps.to.flip/${cur_chr}results.txt --make-bed --out ${folder}/15.flipped.snps/${cur_chr}.flipped.monomorphic 

#Remerge the flipped sites with the pobi file
plink --bfile ${folder}/15.flipped.snps/${cur_chr}.flipped.monomorphic  --bmerge ${folder}/13.notriallelic/${cur_chr}.pobi.notri_tmp  --make-bed --allow-no-sex --out ${folder}/16.flipped.merged/${cur_chr}.anc.pobi.no.tri.no.monomorphic

#**********NEED STEP HERE TO FIND AMBIGUOUS SNPS*******************************


