#plotting quicklook

setwd(getwd())

#edit this if you are not running in command-line
mashdist <- read.delim(paste0(getwd(),"/outs/tbl1_quicklook.tab"), header=FALSE)

#cleanup####
#rename cols
colnames(mashdist)<-c("f1", "f2","dist","pval", "frac")
#rm extra cols
mashdist$pval<-NULL
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

#improve labels
common_prefix <- rownames(pcoa)[1]
for (i in 2:length(rownames(pcoa))) {
  while (!startsWith(rownames(pcoa)[i], common_prefix)) {
    common_prefix <- substr(common_prefix, 1, nchar(common_prefix) - 1)
  }
}

common_suffix <- rownames(pcoa)[1]
for (i in 2:length(rownames(pcoa))) {
  while (!endsWith(rownames(pcoa)[i], common_suffix)) {
    common_suffix <- substr(common_suffix, 2, nchar(common_suffix))
  }
}

pcoa$names<- sub(paste0("^", common_prefix, "(.*)", common_suffix, "$"), "\\1", rownames(pcoa))

#to color by population, import a file with the format shown below
#pop_cols_format<-data.frame(filenames=rownames(pcoa), pop=c(rep("popA",5),rep("popB", nrow(pcoa)-5)))
#pop_cols_format$col<-rainbow(length(unique(pop_cols_format$pop)))[match(pop_cols_format$pop, unique(pop_cols_format$pop))]
#pcoa$col<-pop_cols_format$col[match(rownames(pcoa), pop_cols_format$filenames)]

#plot pcs 1 and 2#####
pdf("mash_out.pdf", height=7, width=7)
plot(pcoa[,1], 
     #col=pcoa$col,
     pcoa[,2],
     pch=1)
text(pcoa[,1], pcoa[,2], 
     #col=pcoa$col,
     labels = pcoa$names,
     cex=.3)  
dev.off()
