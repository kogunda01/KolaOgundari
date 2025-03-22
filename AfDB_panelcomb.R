library(foreign) 
setwd("~/work")
AfDB1 = read.dta("data_AfDB1.dta")  # read from .dta file
GDP1 = read.dta("GDP_1.dta")  # read from .dta file
AfDB_panel1 = merge(AfDB1,GDP1, by="country_id", all=TRUE)
write.dta(AfDB_panel1 ,"C:/Users/ogund/OneDrive/Documents/work/AfDB_panel.dta")

