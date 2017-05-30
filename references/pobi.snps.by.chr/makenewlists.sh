for file in *.se.pobi.updated.bim.txt 
do
filename=$(basename "$file")
extension="${filename##*.}"
filename="${filename%.*}"
awk '{ print $1 }' ${file}  | tr "_" " " > ${filename}.chr.pos.txt
done
