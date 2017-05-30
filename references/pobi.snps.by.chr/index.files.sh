module load angsd-0.913-22 

for file in *.se.pobi.updated.bim.chr.pos.txt 
do
angsd sites index ${file}
done
