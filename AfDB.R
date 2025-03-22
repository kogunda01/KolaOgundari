library(foreign) 
setwd("~/work")
new_AfDB = read.dta("STATA.dta")  # read from .dta file
unique(new_AfDB$economy)
new_AfDB <- new_AfDB[order(new_AfDB$year),]
#extracting final data#
myvars <- c("economy", "year", "s_ATMs","s_branches_A1","s_deposit_acc_A1", "s_institutions_A1")
data_AfDB <- new_AfDB[myvars]
write.dta(data_AfDB,"C:/Users/ogund/OneDrive/Documents/work/data_AfDB1.dta")


