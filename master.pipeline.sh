#!/bin/bash
option=$1

if [${option} = "anc.modern"]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch haplo_plink_eachchr_5min ${i}"
elif [${option} = "pre.post"]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch haplo_plink_eachchr_5min ${i}"
elif [${option} = "pre.modern"]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch haplo_plink_eachchr_5min ${i}"
elif [${option} = "post.modern"]; then
	for i in {1..22}; do
        echo ${i}
        eval "sbatch haplo_plink_eachchr_5min ${i}"
else
	echo "Incorrect input. Please input anc.modern, pre.post, pre.modern, or post.modern"



sleep 1
done


