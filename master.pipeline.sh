#!/bin/bash
echo "Please input anc.modern, pre.post, pre.modern, or post.modern"
read option
echo "Please input number of minimum number of individuals required for coverage"
read indiv

if [ "$option" == "anc.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch anc.modern.eachchr.sh ${i} ${indiv} new_bams.filelist"
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
        eval "sbatch anc.modern.eachchr.sh ${i} ${indiv} pre_list.filelist"
        sleep 1
done
elif [ "$option" = "post.modern" ]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch anc.modern.eachchr.sh ${i} ${indiv} post_list.filelist"
        sleep 1
done
else
	echo "Incorrect input. Please input anc.modern, pre.post, pre.modern, or post.modern"
fi

