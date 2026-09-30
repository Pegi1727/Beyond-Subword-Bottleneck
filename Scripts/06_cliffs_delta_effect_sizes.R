#!/usr/bin/env Rscript
# Beyond the Subword Bottleneck: reproducible analysis
options(stringsAsFactors = FALSE, warn = 1)
ROOT <- normalizePath(getwd(), mustWork = FALSE)
# Robust root based on script path when called by Rscript.
args <- commandArgs(trailingOnly=FALSE); f <- sub("^--file=", "", args[grep("^--file=",args)])
if(length(f)) ROOT <- normalizePath(file.path(dirname(f), "../.."), mustWork=FALSE)
dir.create(file.path(ROOT,"tables"),showWarnings=FALSE,recursive=TRUE); dir.create(file.path(ROOT,"figures"),showWarnings=FALSE,recursive=TRUE)
input <- file.path(ROOT,"data","final_analysis_dataset.csv")
user <- commandArgs(trailingOnly=TRUE); if(length(user)>=2 && user[1]=="--input") input <- user[2]
if(!file.exists(input)) stop("Input CSV not found: ",input)
d <- tryCatch(read.csv(input, check.names=FALSE), error=function(e) stop("Could not read CSV: ",e$message))
required <- c("Language","Item_ID","TCR","TCI","TMR"); miss <- setdiff(required,names(d)); if(length(miss)) stop("Missing columns: ",paste(miss,collapse=", "))
d <- d[required]; d$Language <- trimws(as.character(d$Language)); d$Item_ID <- trimws(as.character(d$Item_ID))
for(m in c("TCR","TCI","TMR")) d[[m]] <- suppressWarnings(as.numeric(d[[m]]))
d <- d[complete.cases(d) & d$Language!="" & d$Item_ID!="",]
if(!nrow(d)) stop("No valid observations remain")
write_table <- function(x,name) write.csv(x,file.path(ROOT,"tables",name),row.names=FALSE,na="")

groups <- sort(unique(d$Language)); out <- list(); k <- 1
for (m in c("TCR","TMR","TCI")) for (i in seq_len(length(groups)-1)) for (j in (i+1):length(groups)) {
  a<-groups[i]; b<-groups[j]; x<-d[d$Language==a,m]; y<-d[d$Language==b,m]
  delta<-(sum(outer(x,y,">"))-sum(outer(x,y,"<")))/(length(x)*length(y)); ad<-abs(delta)
  mag<-if(ad<.147) "negligible" else if(ad<.33) "small" else if(ad<.474) "medium" else "large"
  out[[k]]<-data.frame(Metric=m,Group1=a,Group2=b,N1=length(x),N2=length(y),Cliffs_delta=delta,Magnitude=mag); k<-k+1
}
out<-do.call(rbind,out); write_table(out,"cliffs_delta_effect_sizes.csv"); print(out)
