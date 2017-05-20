#!/bin/bash
echo "Please input anc.modern, pre.post, pre.modern, or post.modern"
read option
echo "Please input number of minimum number of individuals required for coverage"
read indiv

if [ "$option" == "anc.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        maxmis=$((86-$indiv))
        eval "sbatch anc.modern.eachchr.sh ${i} ${maxmis} new_bams.filelist inter.files"
        sleep 1
done

elif [ "$option" = "pre.post" ]; then
	for i in {1..22}; do
        echo ${i}
        #eval "sbatch pre.post.eachchr.sh  ${i} ${indiv}"
        sleep 1
done
elif [ "$option" = "pre.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        maxmis=$((44-$indiv))
        eval "sbatch anc.modern.eachchr.sh ${i} ${maxmis} pre_list.filelist pre.modern"
        echo "sbatch anc.modern.eachchr.sh" ${i} ${maxmis} "pre_list.filelist pre.modern"
        sleep 1
done
elif [ "$option" = "post.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        maxmis=$((24-$indiv))
        eval "sbatch anc.modern.eachchr.sh ${i} ${maxmis} post_list.filelist post.modern"
        sleep 1
done
else
	echo "Incorrect input. Please input anc.modern, pre.post, pre.modern, or post.modern"
fi

