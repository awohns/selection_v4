#!/bin/bash
for file in pobi.snps/*.se.pobi.updated.bim; do
awk '{print $1 "_" $4 " " $2}' ${file} > pobi.snps.by.chr/$(basename "$file").txt
done
