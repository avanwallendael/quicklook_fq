#plotting quicklook

mashdist <- read.delim("~/Desktop/quicklook_test/outs/tbl1_quicklook.tab", header=FALSE)

#cleanup####
#rename cols
colnames(mashdist)<-c("f1", "f2","dist","num", "frac")
#rm extra cols
mashdist$num<-NULL
mashdist$frac<-NULL
#spread to matrix
mash_wide<-reshape(mashdist, idvar="f1", timevar = "f2", direction = "wide")
#set rownames for mat
rownames(mash_wide)<-mash_wide$f1
#rm col
mash_wide$f1<-NULL
#make into numeric matrix
mash_mat<-data.matrix(mash_wide)
#make dist object
mash_dist<-as.dist(mash_mat)

#run pcoa####
#alter k to get more pcs
pcoa<-as.data.frame(cmdscale(mash_dist,k = 3))

#to color by population, import a file with the format shown below
#pop_cols_format<-data.frame(filenames=rownames(pcoa), pop=c(rep("popA",5),rep("popB", nrow(pcoa)-5)))
#pop_cols_format$col<-rainbow(length(unique(pop_cols_format$pop)))[match(pop_cols_format$pop, unique(pop_cols_format$pop))]
#pcoa$col<-pop_cols_format$col[match(rownames(pcoa), pop_cols_format$filenames)]

#plot pcs 1 and 2
pdf("mash_out.pdf", height=7, width=7)
plot(pcoa[,1], 
     #col=pcoa$col,
     pcoa[,2])
text(pcoa[,1], pcoa[,2], 
     #col=pcoa$col,
     labels = rownames(pcoa))  
dev.off()
