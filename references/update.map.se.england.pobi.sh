module load plink-1.9.0

plink --bfile /ebc_data/awwohns/selection_v4/references/se.england.pobi/pobi.9.10.11.with.rsid --update-map dbsnp.files.for.update.map/allchrs.dbsnp.update.map.txt --make-bed --out se.england.pobi/9.10.11.updated.map
