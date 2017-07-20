for cur_chr in {1..22}
do
	eval 'cp pre.post.inter/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic.bim pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.post.bim'
	eval 'cp pre.post.inter/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps.bim pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.pre.bim'

	eval 'cp pre.post.inter/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic.fam pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.post.fam'
	eval 'cp pre.post.inter/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps.fam pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.pre.fam'

	eval 'cp pre.post.inter/23.flipped.snps.post/${cur_chr}.flipped.post.monomorphic.bed pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.post.bed'
	eval 'cp pre.post.inter/15.pre.with.post.snps/${cur_chr}.pre.with.post.snps.bed pre.post.inter/ambiguous.pre.post.for.download/${cur_chr}.pre.bed'
done
