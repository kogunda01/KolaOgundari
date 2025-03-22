setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")

## load library for related to data format(stata)
library(haven)

## load the data
energy <- read_dta("energy_date1.dta")

## view the data
View(energy)
head(energy)

##load packages 
library(tidyverse)
library(urca)
library(forecast)
library(tseries) 
library(TSstudio)



## Declaring the data as a time series 


Econsump<-ts(energy$Energy_Consumption,start = c(2022,1,1),end = c(2024,1,22),frequency = 365)
hourtemp <-ts(energy$hourly_temp,start = c(2022,1,1),end = c(2024,1,22),frequency = 365)
avertemp <-ts(energy$daily_avg_temp,start = c(2022,1,1),end = c(2024,1,22),frequency = 365)


View(energy)

library(xts)
library(ggplot2)
library(forecast)
library(dplyr)
library(hydroTSM)
library(ggpubr)
library(expss)
library(labelled)

demandts <- xts(energy$Energy_Consumption, energy$date)
plot(demandts, main = 'Trends in Energy Demand', xlab = 'Date', ylab = 'Demand (kWh)')

##forecast

model <- Arima(Econsump, order = c(2, 1, 2), list(order = c(1, 1, 1), period = 7))

autoplot(model)


########

df_test <- subset(energy, date >= strptime('2022-01-01', format = '%y-%m-%d'))
energy <- subset(energy, date < strptime('2022-01-01', format = '%y-%m-%d'))
energy <- ts(df$demand, frequency = 1)


#############################
## creating a date

DATES<-c(seq(as.Date('2022-01-01'), as.Date('2024-01-22'), by = 'days'))
df<-data.frame(DATES)

View(df)

##create seasoanl 

seasonal= cut(lubridate::yday(energy$date - lubridate::days(79)), 
    breaks = c(0, 93, 187, 276, Inf), 
    labels = c("Spring", "Summer", "Autumn", "Winter"))


seasonal <- as.data.frame(seasonal)

energy2 <- cbind(energy, seasonal)
View(energy2)



## splint date into year, number of days and month
energy2$year <- year(ymd(energy2$date))
energy2$month <- month(ymd(energy2$date)) 
energy2$day <- day(ymd(energy2$date))
energy2$Weekday <- weekdays(as.Date(energy2$date,'%Y%m%d'))

val_lab(energy2$month) <- make_labels("1 Jan
                                       2 Feb
                                       3 Mar
                                       4 Apr
                                       5 May
                                       6 Jun
                                       7 July
                                       8 Aug
                                       9 Sept
                                       10 Oct
                                       11 Nov
                                       12 Dec")


##plots
counts <- table(energy2$seasonal)
barplot(counts, main="Seasonal distribution",
        xlab="Number of Seasons")


counts <- table(energy2$Weekday)
barplot(counts, main="Weekdays Distribution",
        xlab="Number of Days")



ggbarplot(data=energy2, x="seasonal", y="Energy_Consumption", add=c("mean_sd"), position=position_dodge(0.7), width = 0.5) 


ggbarplot(data=energy2, x="month", y="Energy_Consumption", fill = "seasonal", add=c("mean_sd"), position=position_dodge(0.7), width = 0.5) +
  scale_fill_brewer(palette="Greens")

ggbarplot(data=energy2, x="year", y="Energy_Consumption", fill = "seasonal", add=c("mean_sd"), position=position_dodge(0.7), width = 0.5) +
  scale_fill_brewer(palette="Reds")

ggbarplot(data=energy2, x="month", y="hourly_temp", fill = "seasonal", add=c("mean_sd"), position=position_dodge(0.7), width = 0.5) +
  scale_fill_brewer(palette="Greens") 

ggbarplot(data=energy2, x="Weekday", y="hourly_temp", fill = "seasonal", add=c("mean_sd"), position=position_dodge(0.7), width = 0.5) +
  scale_fill_brewer(palette="Reds") 

###line chart
ggplot(data = energy2, aes(x = hourly_temp, y = Energy_Consumption, color = seasonal)) +       
  geom_line(aes(group = seasonal)) + geom_point()

ggplot(energy2, aes(x=hourly_temp, y=Energy_Consumption, group=1)) +
  geom_line(linetype = "dashed")+
  geom_point()


ggplot(data = energy2, aes(x=hourly_temp, y=Energy_Consumption, group=seasonal, color=seasonal)) +
  geom_line() +
  ggtitle("Energy Consumption-Temperature") +
  ylab("Energy Consumption")
