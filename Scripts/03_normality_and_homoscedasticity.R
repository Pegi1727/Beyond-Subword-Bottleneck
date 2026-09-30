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

rows <- list(); k<-1
for(m in c("TCR","TMR","TCI")) { for(g in sort(unique(d$Language))) {v<-d[d$Language==g,m]; z<-tryCatch(shapiro.test(v),error=function(e) NULL); rows[[k]]<-data.frame(Metric=m,Test="Shapiro-Wilk",Language=g,N=length(v),Statistic=if(is.null(z)) NA else unname(z$statistic),P_value=if(is.null(z)) NA else z$p.value,Note=""); k<-k+1}; z<-tryCatch(leveneTest<-fligner.test(d[[m]],d$Language),error=function(e) NULL); rows[[k]]<-data.frame(Metric=m,Test="Fligner-Killeen (robust homogeneity)",Language="ALL_GROUPS",N=nrow(d),Statistic=if(is.null(z)) NA else unname(z$statistic),P_value=if(is.null(z)) NA else z$p.value,Note=""); k<-k+1 }
out<-do.call(rbind,rows); write_table(out,"normality_homoscedasticity.csv"); print(out)
