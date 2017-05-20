#!/bin/bash
#
#BATCH --job-name=haplo_plink
#SBATCH --output=haplo_plink.txt
#
#SBATCH --ntasks=1
#SBATCH --time=60:00:00
#SBATCH --mem-per-cpu=50g

cur_chr=$1
num_indiv=$2
maxmis_pre=$((44-$num_indiv))
maxmis_post=$((24-$num_indiv))

module load angsd-0.913-22 
module load plink-1.9.0
module load R

#Perform haplocall pre
angsd -b references/pre_list.filelist -doHaploCall 1 -doCounts 1 -out pre.post.inter/1.haplo.pre/${cur_chr}  -r ${cur_chr} -maxMis ${maxmis_pre} -sites references/pobi.snps.by.chr/${cur_chr}.se.pobi.bim.chr.pos.txt

#Haplocall post
angsd -b references/post_list.filelist -doHaploCall 1 -doCounts 1 -out pre.post.inter/2.haplo.post/${cur_chr}  -r ${cur_chr} -maxMis ${maxmis_post} -sites references/pobi.snps.by.chr/${cur_chr}.se.pobi.bim.chr.pos.txt

#Convert to tped
/storage/software/angsd-0.913-22/misc/haploToPlink pre.post.inter/1.haplo.pre/${cur_chr}.haplo.gz pre.post.inter/3.pre.tped/${cur_chr}
/storage/software/angsd-0.913-22/misc/haploToPlink pre.post.inter/2.haplo.post/${cur_chr}.haplo.gz pre.post.inter/4.post.tped/${cur_chr}


#Replace N's with 0's
eval 'sed 's/N/0/g' pre.post.inter/3.pre.tped/${cur_chr}.tped  > pre.post.inter/5.pre.tped.nto0/temp.${cur_chr}.tped'
eval 'sed 's/N/0/g' pre.post.inter/4.post.tped/${cur_chr}.tped  > pre.post.inter/6.post.tped.nto0/temp.${cur_chr}.tped'

#Copy the tfam file
#eval 'cp 2.ancient.tped/${cur_chr}_5min.tfam 3.ancient.tped.nto0/temp.${cur_chr}_5min.tfam'

#Convert tped to ped
# plink --tfile inter.files/3.tped.nto0/temp.${cur_chr} --recode --out inter.files/4.ped/${cur_chr}_ped

# #Add the rsids
# plink --file inter.files/4.ped/${cur_chr}_ped --update-map references/pobi.snps.by.chr/${cur_chr}.se.pobi.bim.txt --update-name --make-bed --out inter.files/5.add.rsid/${cur_chr}.with.rsid

# #Find intersected SNPS between ancient and pobi
# plink --bfile inter.files/5.add.rsid/${cur_chr}.with.rsid --extract references/pobi.snps/${cur_chr}.se.pobi.bim.snps.only.txt --make-bed --out inter.files/6.intersect/${cur_chr}.intersected.anc.pobi

# #Add phenotypes to intersected list
# cp inter.files/6.intersect/* inter.files/7.intersect.pheno/
# awk '{$6 = "2";print $0 }' inter.files/6.intersect/${cur_chr}.intersected.anc.pobi.fam > inter.files/7.intersect.pheno/${cur_chr}.intersected.anc.pobi.fam


# #Get list of SNPs intersected from the ancient dataset
# cut -f2 inter.files/7.intersect.pheno/${cur_chr}.intersected.anc.pobi.bim > inter.files/8.anc.snps/${cur_chr}.anc.snps.txt


# #Extract the overlapping SNPs from POBI
# plink --bfile references/se.england.pobi/se.england.pobi --extract inter.files/8.anc.snps/${cur_chr}.anc.snps.txt --make-bed --out inter.files/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps

# #Merge pobi and ancient
# plink --bfile inter.files/7.intersect.pheno/${cur_chr}.intersected.anc.pobi --bmerge inter.files/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --make-bed --out inter.files/10.merged/${cur_chr}.merge

# #Flip the missnps
# plink --bfile inter.files/7.intersect.pheno/${cur_chr}.intersected.anc.pobi --flip inter.files/10.merged/${cur_chr}.merge-merge.missnp --make-bed --out inter.files/11.merged.flipped/${cur_chr}.merge.flipped

# #Remerge after the flip
# plink --bfile inter.files/11.merged.flipped/${cur_chr}.merge.flipped --bmerge inter.files/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --make-bed --out inter.files/12.remerged/${cur_chr}.pobi.anc

# #Final exclude and merge
# plink --bfile inter.files/11.merged.flipped/${cur_chr}.merge.flipped --exclude inter.files/12.remerged/${cur_chr}.pobi.anc-merge.missnp --make-bed --out inter.files/13.notriallelic/${cur_chr}.anc.notri_tmp
# plink --bfile inter.files/9.pobi.with.anc.snps/${cur_chr}.pobi.with.anc.snps --exclude inter.files/12.remerged/${cur_chr}.pobi.anc-merge.missnp --make-bed --out inter.files/13.notriallelic/${cur_chr}.pobi.notri_tmp
# plink --bfile inter.files/13.notriallelic/${cur_chr}.anc.notri_tmp --bmerge inter.files/13.notriallelic/${cur_chr}.pobi.notri_tmp --make-bed --allow-no-sex --out inter.files/13.notriallelic/${cur_chr}.anc.pobi.notri

# #Find Monomorphic Problems
# Rscript lib/flip.mono.problems.R ${cur_chr}

# #Flip the monomorphic SNPs
# plink --bfile inter.files/13.notriallelic/${cur_chr}.anc.notri_tmp --flip inter.files/14.snps.to.flip/${cur_chr}results.txt --make-bed --out inter.files/15.flipped.snps/${cur_chr}.flipped.monomorphic 

# #Remerge the flipped sites with the pobi file
# plink --bfile inter.files/15.flipped.snps/${cur_chr}.flipped.monomorphic  --bmerge inter.files/13.notriallelic/${cur_chr}.pobi.notri_tmp  --make-bed --allow-no-sex --out inter.files/16.flipped.merged/${cur_chr}.anc.pobi.no.tri.no.monomorphic

# #**********NEED STEP HERE TO FIND AMBIGUOUS SNPS*******************************
