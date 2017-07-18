eval 'references/./update.map.se.england.pobi.sh'
eval 'references/split.file.by.chr.sh'
eval 'references/./pobi.snps.bim.to.chr_bp.sh'
eval 'references/./remove.duplicates.sh'
#You have to cd into pobi.snps.by.chr before calling ./makenewlists.sh
eval 'references/pobi.snps.by.chr/./makenewlists.sh'
eval 'references/pobi.snps.by.chr/./index.files.sh'
