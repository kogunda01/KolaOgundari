setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")

## load library for related to data format(stata)
library(haven)

## load the data
energy <- read_dta("energy_date1.dta")

## view the data
View(energy)

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

##Graphs
autoplot(Econsump) + ggtitle("Trends in Daily Energy Consumption, Jan.2022 to Jan. 2024") + labs(x = "Daily", y = "Energy Consumption")

pred<-stlf(Econsump,h=1,method="arima") 

## Forecasting using STL+ARIMA
stlf(Econsump,h=1*365,method="arima") %>%
autoplot()
fit<-auto.arima(Econsump)




data_deseason <- stl(Econsump, t.window=50, s.window='periodic', robust=TRUE) 
f <- forecast(data_deseason, h=1*365,
              forecastfunction=function(x,h,level){
                fit <- auto.arima(x,  include.mean=FALSE)
                return(forecast(fit,h=1*365,level=level))})
autoplot(f)


data_deseason <- stl(Econsump, t.window=50, s.window='periodic', robust=TRUE) 
f <- forecast(data_deseason, h=1*365,
              forecastfunction=function(x,h,level){
                fit <- Arima(x, order=c(2,1,2), include.mean=FALSE)
                return(forecast(fit,h=1*365,level=level))})
autoplot(f)


## ARIMA
## partition into train and test
train_series=Econsump[1:500]
test_series=Econsump[501:731]

## make arima models
arimaModel_1=arima(train_series, order=c(1,1,1))
arimaModel_2=arima(train_series, order=c(1,1,2))
arimaModel_3=arima(train_series, order=c(2,1,2))

## look at the parameters
print(arimaModel_1);print(arimaModel_2);print(arimaModel_3)

forecast1=predict(arimaModel_1, 10)
forecast2=predict(arimaModel_2, 10)
forecast3=predict(arimaModel_3, 10)









##plots
plot(hourtemp, Econsump, main = "Energy Consumption-Hourly Temperature",
     xlab = "Hourly Temperature", ylab = "Energy Consumption",
     pch = 19, frame = FALSE)

plot(avertemp, Econsump, main = "Energy Consumption-Average Temperature",
     xlab = "Average Temperature", ylab = "Energy Consumption",
     pch = 19, frame = FALSE)

ggplot(data = energy, aes(x = hourly_temp, y = Energy_Consumption)) +
  geom_point()

ggplot(data = energy, aes(x = daily_avg_temp, y = Energy_Consumption)) +
  geom_point()

#ACF and PACF graphs

ggAcf(Econsump) + ggtitle("ACF of Energy Consumption")

ggPacf(Econsump) + ggtitle("PACF of Energy Consumption")

## ACF and PACF graphs by differenced 

dconsump <- diff(Econsump)
ggAcf(dconsump) + ggtitle("ACF of Energy Consumption (Differenced)") 
ggPacf(dconsump) + ggtitle("PACF of Energy Consumption (Differenced)") 


## Differenced series graph

autoplot(dconsump) + ggtitle("Energy Consumption (Differenced), Jan.2022 to Jan.2024") + labs(x = "Daily", y = "Energy Consumption")

## Tests for non-stationarity

## ADF, PP, & KPSS

adf.test(tfp) 
adf.test(tfp, k = 1)
adf.test(tfp, k = 2)
adf.test(dtfp)

pp.test(tfp)
pp.test(dtfp)

kpss.test(tfp)
kpss.test(dtfp)


## forecasting 
## split the data into training and testing series

split_tfp <- ts_split(Econsump, sample.out = 180)
training <- split_tfp$train 
testing <- split_tfp$test
length(training)
length(testing)



## Diagnosing the Training Set

arima_diag(training)


##Building the Forecast Model

#For Model 1
arima201 <- arima(training, order = c(1,0,5))
autoplot(arima201)
check_res(arima201)

#For Model 2
arima2011 <- arima(training, order = c(1,1,5))
autoplot(arima2011)
check_res(arima2011)

#For Model 3
auto <- auto.arima(training, seasonal = FALSE)
auto 
autoplot(auto)
check_res(auto)

##Generating the Forecasts and Forecast Evaluation

#For Model 1
fcast1 <- forecast(arima201, h = 10)
test_forecast(actual = Econsump, forecast.obj = fcast1, test = testing)
accuracy(fcast1,testing)

#For Model 2
fcast2 <- forecast(arima2011, h = 2)
test_forecast(actual = Econsump, forecast.obj = fcast2, test = testing)
accuracy(fcast2,testing)

#For Model 3
fcasta <- forecast(auto, h = 2)
test_forecast(actual = Econsump, forecast.obj = fcasta, test = testing)
accuracy(fcasta,testing)

##Generating the Optimal Fit

finalfit <- auto.arima(tfp, seasonal = FALSE)
autoplot(finalfit)
check_res(finalfit)



##Out of Sample Forecasting

fcastf <- forecast(tfp, model = finalfit, h = 10)
plot_forecast(fcastf)
summary(fcastf)


