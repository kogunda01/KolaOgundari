setwd("~/R_Nigeria")
dir()
### load stata data
library(foreign)
###load the convergence test program
HDIa=read.dta("HDI_1a.dta")
View(HDIa)
library(ConvergenceClubs)

logHDI <- log(hdi[,-1])
filteredHDI <- apply(logHDI, 1,
                     function(x){mFilter::hpfilter(x, freq=400, type="lambda")$trend} )
filteredHDI <- data.frame(Countries = hdi[,1], t(filteredHDI), stringsAsFactors=FALSE )
colnames(filteredHDI) <- colnames(hdi)

