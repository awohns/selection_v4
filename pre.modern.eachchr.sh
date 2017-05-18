#!/bin/bash
#
#BATCH --job-name=haplo_plink
#SBATCH --output=haplo_plink.txt
#
#SBATCH --ntasks=1
#SBATCH --time=60:00:00
#SBATCH --mem-per-cpu=50g

cur_chr=$1

module load angsd-0.913-22 
module load plink-1.9.0

#Perform haplocall
#angsd -b new_bams.filelist -doHaploCall 1 -doCounts 1 -out 1.ancient.haplo/${cur_chr}_5min  -r ${cur_chr} -maxMis 81

#Convert to tped
#/storage/software/angsd-0.913-22/misc/haploToPlink 1.ancient.haplo/${cur_chr}_5min.haplo.gz 2.ancient.tped/${cur_chr}_5min

#Replace N's with 0's
eval 'sed 's/N/0/g' 2.ancient.tped/${cur_chr}_5min.tped  > 3.ancient.tped.nto0/temp.${cur_chr}_5min.tped'

#Copy the tfam file
eval 'cp 2.ancient.tped/${cur_chr}_5min.tfam 3.ancient.tped.nto0/temp.${cur_chr}_5min.tfam'

#Convert tped to ped
plink --tfile 3.ancient.tped.nto0/temp.${cur_chr}_5min --recode --out 4.ancient.ped/${cur_chr}_ped_5min

#Add the rsids
plink --file 4.ancient.ped/${cur_chr}_ped_5min --update-map pobi.snps.by.chr/${cur_chr}.se.pobi.bim.txt --update-name --make-bed --out 5.ancient.with.rsid/${cur_chr}.with.rsid_5min
