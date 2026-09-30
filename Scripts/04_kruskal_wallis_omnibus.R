#!/usr/bin/env Rscript
# Beyond the Subword Bottleneck: reproducible analysis
options(stringsAsFactors = FALSE, warn = 1)
ROOT <- normalizePath(file.path(dirname(substitute(sys.function())), "../.."), mustWork = FALSE)
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

out<-do.call(rbind,lapply(c("TCR","TMR","TCI"),function(m){z<-kruskal.test(d[[m]],d$Language); data.frame(Metric=m,N=nrow(d),Groups=length(unique(d$Language)),H=unname(z$statistic),df=unname(z$parameter),P_value=z$p.value,Epsilon_squared=max(0,(unname(z$statistic)-length(unique(d$Language))+1)/(nrow(d)-length(unique(d$Language))))) })); write_table(out,"kruskal_wallis.csv"); print(out)
