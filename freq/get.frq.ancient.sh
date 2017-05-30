module load plink-1.9.0 

for chr in {1..22}; do
plink --bfile /ebc_data/awwohns/selection_v4/pre.modern/5.add.rsid/${chr}.with.rsid --freq --out ${chr}
done
