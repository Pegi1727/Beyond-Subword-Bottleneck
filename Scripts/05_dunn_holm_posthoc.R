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

groups <- sort(unique(d$Language)); results <- list(); k <- 1
for (m in c("TCR","TMR","TCI")) {
  x <- d[[m]]; N <- length(x); r <- rank(x, ties.method="average")
  tie_counts <- as.numeric(table(x)); tie_sum <- sum(tie_counts^3-tie_counts)
  variance <- N*(N+1)/12 - tie_sum/(12*(N-1))
  pairs <- combn(groups,2,simplify=FALSE)
  rawp <- numeric(length(pairs)); tmp <- vector("list",length(pairs))
  for (i in seq_along(pairs)) {
    a <- pairs[[i]][1]; b <- pairs[[i]][2]; ia <- d$Language==a; ib <- d$Language==b
    denom <- sqrt(max(variance,0)*(1/sum(ia)+1/sum(ib)))
    zz <- if(denom>0) (mean(r[ia])-mean(r[ib]))/denom else 0
    rawp[i] <- 2*pnorm(-abs(zz))
    tmp[[i]] <- data.frame(Metric=m,Group1=a,Group2=b,N1=sum(ia),N2=sum(ib),Z=zz,P_raw=rawp[i])
  }
  adj <- p.adjust(rawp,method="holm")
  for(i in seq_along(tmp)) { tmp[[i]]$P_Holm <- adj[i]; results[[k]] <- tmp[[i]]; k<-k+1 }
}
out <- do.call(rbind,results); write_table(out,"dunn_holm_posthoc.csv"); print(out)
