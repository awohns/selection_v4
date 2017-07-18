#!/bin/bash
echo "Welcome to Selection scan after you've checked for ambiguous SNPs!"
echo "Please input anc.modern, pre.post, pre.modern, or post.modern"
read option


if [ "$option" == "anc.modern" ]; then
         eval "rm inter.files/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt"
	for i in {1..22}; do
        echo ${i}
       
        eval "./anc.modern.after.ambiguous.eachchr.sh ${i} inter.files"
        sleep 1
done

elif [ "$option" = "pre.post" ]; then
	for i in {1..22}; do
        echo ${i}
        eval "./pre.post.after.ambiguous.eachchr.sh ${i} pre.post.inter"
        sleep 1
done
elif [ "$option" = "pre.modern" ]; then
        eval "rm pre.modern/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt"
	for i in {1..22}; do
        echo ${i}
        #eval "rm pre.modern/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt"
        eval "./anc.modern.after.ambiguous.eachchr.sh ${i} pre.modern"
        sleep 1
done
elif [ "$option" = "post.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        eval "./anc.modern.after.ambiguous.eachchr.sh  ${i} post.modern"
        sleep 1
done
else
	echo "Incorrect input. Please input anc.modern, pre.post, pre.modern, or post.modern"
fi

