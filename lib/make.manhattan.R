library(qqman)
library(RColorBrewer)

allchrs <- read.table("/ebc_data/awwohns/selection_v4/inter.files/20.manhattan.data/assoc.results.all.chrs.no.ambiguous.txt", header=TRUE)
manhattan(allchrs, col = c("blue4", "orange3"), ylim = c(0, 50))