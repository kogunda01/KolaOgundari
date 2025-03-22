library(foreign)
setwd("~/OneDrive/Documents/R_Nigeria")
nutrient= read.dta("kola2.dta")
View(nutrient)

#summary statistics
summary(nutrient)
summary(nutrient$proteingcapitaday)
summary (subset(nutrient, years ==2006))

# creating a subset from a whole data
nut2007 <- subset(nutrient, years==2007)
summary(nut2007)
View(nut2007)
subset(nut2007, foodindex==134)
subset(nut2007)
subset(nutrient)

# frequency of variable (counts)
xtabs(~ years, data = nutrient)


install.packages("ggplot2")
library(ggplot2)

nut2007.matrix <- data.matrix(nut2007)
nut2007.mod <- data.frame(nut2007.matrix)

# ploting historgram, bar chart and density function
ggplot(nut2007.mod, aes(x=working)) + geom_histogram(binwidth=3)

ggplot(nutrient, aes(x=working)) + geom_histogram(binwidth=0.1)

ggplot(nutrient, aes(x=working)) + geom_histogram(binwidth=3)

ggplot(nutrient, aes(x=years)) + geom_bar()

ggplot(nutrient, aes(x=working)) + geom_density()

ggplot(nutrient, aes(logP,logC))+geom_boxplot()

ggplot(nutrient, aes(y=logP))+geom_boxplot()

# scatter plot
# y vs x
ggplot(nutrient, aes(x=logP, y=logC, color=years)) +geom_point(shape=1)

ggplot(nutrient, aes(x=years, y=logC)) +geom_point(shape=1)+ geom_smooth(smooth=lm)

ggplot(nutrient, aes(x=years, y=logC)) +geom_point(shape=1)+ geom_smooth(method=lm)

ggplot(nutrient, aes(x=years, y=logF)) +geom_point(shape=1)


       
       
# removing subset data
rm(nut2007)


