#!/bin/bash
#
#BATCH --job-name=pre.post.selection
#SBATCH --output=std.out.pre.post.txt
#
#SBATCH --ntasks=1
#SBATCH --time=60:00:00
#SBATCH --mem-per-cpu=50g

cur_chr=$1
maxmis_pre=$2
maxmis_post=$3
# maxmis_pre=$((44-$num_indiv))
# maxmis_post=$((24-$num_indiv))

directory="pre.post.inter"

module load angsd-0.913-22 
module load plink-1.9.0
module load R

# #Perform haplocall pre
# angsd -b references/pre.bam.list.txt -doHaploCall 1 -doCounts 1 -out ${directory}/1.haplo.pre/${cur_chr}  -r ${cur_chr} -maxMis ${maxmis_pre} -sites references/pobi.snps.by.chr/${cur_chr}.se.pobi.updated.bim.chr.pos.txt

# #Haplocall post
# angsd -b references/post.bam.list.txt -doHaploCall 1 -doCounts 1 -out ${directory}/2.haplo.post/${cur_chr}  -r ${cur_chr} -maxMis ${maxmis_post} -sites references/pobi.snps.by.chr/${cur_chr}.se.pobi.updated.bim.chr.pos.txt

# # Convert to tped
# /storage/software/angsd-0.913-22/misc/haploToPlink ${directory}/1.haplo.pre/${cur_chr}.haplo.gz ${directory}/3.pre.tped/${cur_chr}
# /storage/software/angsd-0.913-22/misc/haploToPlink ${directory}/2.haplo.post/${cur_chr}.haplo.gz ${directory}/4.post.tped/${cur_chr}


#Replace N's with 0's
eval 'sed 's/N/0/g' ${directory}/3.pre.tped/${cur_chr}.tped  > ${directory}/5.pre.tped.nto0/temp.${cur_chr}.tped'
eval 'sed 's/N/0/g' ${directory}/4.post.tped/${cur_chr}.tped  > ${directory}/6.post.tped.nto0/temp.${cur_chr}.tped'

#Copy the tfam file
eval 'cp ${directory}/3.pre.tped/${cur_chr}.tfam ${directory}/5.pre.tped.nto0/temp.${cur_chr}.tfam'
eval 'cp ${directory}/4.post.tped/${cur_chr}.tfam ${directory}/6.post.tped.nto0/temp.${cur_chr}.tfam'

#Convert tped to ped
plink --tfile ${directory}/5.pre.tped.nto0/temp.${cur_chr} --recode --out ${directory}/7.pre.ped/${cur_chr}_pre_ped
plink --tfile ${directory}/6.post.tped.nto0/temp.${cur_chr} --recode --out ${directory}/8.post.ped/${cur_chr}_post_ped

#Add the rsids
plink --file ${directory}/7.pre.ped/${cur_chr}_pre_ped --update-map references/pobi.snps.by.chr/${cur_chr}.se.pobi.updated.bim.txt --update-name --make-bed --out ${directory}/9.pre.add.rsid/${cur_chr}.pre.with.rsid
plink --file ${directory}/8.post.ped/${cur_chr}_post_ped --update-map references/pobi.snps.by.chr/${cur_chr}.se.pobi.updated.bim.txt --update-name --make-bed --out ${directory}/10.post.add.rsid/${cur_chr}.post.with.rsid

#Get list of rsids from pre
cut -f2 ${directory}/9.pre.add.rsid/${cur_chr}.pre.with.rsid.bim > ${directory}/11.pre.snps/${cur_chr}.pre.snps.txt

#Find intersected SNPS between pre and post (extract the pre snps from post)
plink --bfile ${directory}/10.post.add.rsid/${cur_chr}.post.with.rsid --extract ${directory}/11.pre.snps/${cur_chr}.pre.snps.txt --make-bed --out ${directory}/12.post.intersected.with.pre/${cur_chr}.post.intersected

#Add phenotypes to post list
cp ${directory}/12.post.intersected.with.pre/* ${directory}/13.post.intersect.pheno/
awk '{$6 = "2";print $0 }' ${directory}/12.post.intersected.with.pre/${cur_chr}.post.intersected.fam > ${directory}/13.post.intersect.pheno/${cur_chr}.post.intersected.fam

#Get list of SNPs intersected from the post dataset
cut -f2 ${directory}/13.post.intersect.pheno/${cur_chr}.post.intersected.bim > ${directory}/14.post.snps/${cur_chr}.post.snps.txt

#Extract the post SNPs from pre
plink --bfile ${directory}/9.pre.add.rsid/${cur_chr}.pre.with.rsid --extract ${directory}/14.post.snps/${cur_chr}.post.snps.txt --make-bed --out ${directory}/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps

#Merge pre and post
plink --bfile ${directory}/13.post.intersect.pheno/${cur_chr}.post.intersected --bmerge ${directory}/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps --make-bed --out ${directory}/16.merged/${cur_chr}.merge

#Flip the missnps
plink --bfile ${directory}/13.post.intersect.pheno/${cur_chr}.post.intersected --flip ${directory}/16.merged/${cur_chr}.merge-merge.missnp --make-bed --out ${directory}/17.post.merged.flipped/${cur_chr}.post.merge.flipped

#Remerge after the flip
plink --bfile ${directory}/17.post.merged.flipped/${cur_chr}.post.merge.flipped --bmerge ${directory}/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps --make-bed --out ${directory}/18.remerged/${cur_chr}.pre.post

#Final exclude and merge
plink --bfile ${directory}/17.post.merged.flipped/${cur_chr}.post.merge.flipped --exclude ${directory}/18.remerged/${cur_chr}.pre.post-merge.missnp --make-bed --out ${directory}/19.notriallelic.post/${cur_chr}.post.notri_tmp
plink --bfile ${directory}/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps --exclude ${directory}/18.remerged/${cur_chr}.pre.post-merge.missnp --make-bed --out ${directory}/20.notriallelic.pre/${cur_chr}.pre.notri_tmp
plink --bfile ${directory}/19.notriallelic.post/${cur_chr}.post.notri_tmp --bmerge ${directory}/20.notriallelic.pre/${cur_chr}.pre.notri_tmp --make-bed --allow-no-sex --out ${directory}/21.notriallelic.pre.post/${cur_chr}.pre.post.notri

#Find Monomorphic Problems
Rscript lib/flip.mono.problems.R ${cur_chr} ${directory}

#Flip the monomorphic SNPs
plink --bfile ${directory}/19.notriallelic.post/${cur_chr}.post.notri_tmp --flip ${directory}/22.snps.to.flip/${cur_chr}results.txt --make-bed --out ${directory}/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic 

#Remerge the flipped sites with the pobi file
plink --bfile ${directory}/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic   --bmerge ${directory}/20.notriallelic.pre/${cur_chr}.pre.notri_tmp  --make-bed --allow-no-sex --out ${directory}/24.flipped.merged/${cur_chr}.pre.post.no.tri.no.monomorphic

# #**********NEED STEP HERE TO FIND AMBIGUOUS SNPS*******************************
