library(foreign) 
setwd("~/work")

library(haven)
Herring <- read_dta("Herring.dta")
View(Herring)

library(haven)
AOC_DIVERSION <- read_dta("AOC_DIVERSION.dta")
View(AOC_DIVERSION)

