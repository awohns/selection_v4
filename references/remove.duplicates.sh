for file in pobi.snps.by.chr/*.se.pobi.updated.bim.txt; do
ls -l | awk '$2~/rs/' ${file} > pobi.snps.by.chr/$(basename "$file").duprm
awk '!x[$0]++' ${file}.duprm > ${file}.fixed
done