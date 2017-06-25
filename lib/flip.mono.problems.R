args =commandArgs(trailingOnly = TRUE)
cur_chr <- args[1]
folder <- args[2]

if (folder == "inter.files") {
	ancient <- read.delim(paste0("/ebc_data/awwohns/selection_v4/",folder,"/13.notriallelic/",cur_chr,".anc.notri_tmp.bim"),header=FALSE)
pobi <- read.delim(paste0("/ebc_data/awwohns/selection_v4/",folder,"/13.notriallelic/",cur_chr,".pobi.notri_tmp.bim"),header=FALSE)

} else if (folder == "pre.post.inter") {
	ancient <- read.delim(paste0("/ebc_data/awwohns/selection_v4/",folder,"/20.notriallelic.pre/",cur_chr,".pre.notri_tmp.bim"),header=FALSE)
	pobi <- read.delim(paste0("/ebc_data/awwohns/selection_v4/",folder,"/19.notriallelic.post/",cur_chr,".post.notri_tmp.bim"),header=FALSE)
}

merged <- merge(ancient, pobi, by=("V2"))
#print(head(merged))

#Helper Function
reverse <- function(base) {
	if(base=="N") {
		return(base)
	}
		if(base == "G") {
			return("C")
		}
		else if(base == "C") {
			return("G")
		}
		else if(base == "T") {
			return("A")
		}
		else if(base == "A") {
			return("T")
		}
}

#merged <- matrix(unlist(merged),nrow=length(merged),byrow=T)


find.mismatch <- function(cursnp) {
	if (cursnp["V5.x"] == "0") {
		
		if (cursnp["V6.x"] == reverse(cursnp["V6.y"])) {
			print("bad match")
			#print(cursnp)
			return(cursnp["V2"])
			#return(cursnp)
		}
	}

}

#results <- apply(merged,1,find.mismatch)
results <- list()

index <- 1
for(i in 1:nrow(merged)) {

		if (merged[i,]["V5.x"] == "0") {
			
			if (merged[i,]["V6.x"] == reverse(merged[i,]["V6.y"])) {
				
				#print(cursnp)
				results[[index]] <- (merged[i,]["V2"])
				index <- index + 1
				#return(cursnp)
			}
		}
		
}
results <- t(as.data.frame(results))

if (folder == "inter.files") {
	write.table(results, file=paste0(folder,"/14.snps.to.flip/",cur_chr,"results.txt"),row.names=FALSE,col.names=FALSE,quote=FALSE)
} else if (folder == "pre.post.inter"){
	write.table(results, file=paste0(folder,"/22.snps.to.flip/",cur_chr,"results.txt"),row.names=FALSE,col.names=FALSE,quote=FALSE)
}
