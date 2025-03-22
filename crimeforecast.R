setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")

## load library for related to data format(stata)
library(haven)

## load the data
crime <- read_dta("crime2023.dta")

## view the data
View(crime)



##load packages 
library(tidyverse)
library(urca)
library(forecast)
library(tseries) 
library(TSstudio)

## Declaring the data as a time series 

violent <- ts(crime$violent, start = c(1960,1), frequency = 1)
property <- ts(crime$property, start = c(1960,1), frequency = 1)

##Graphs
autoplot(violent) + ggtitle("Violent crime rate , 1960 to 2020") + labs(x = "Year", y = "Violent Crime rate")
autoplot(property) + ggtitle("property crime rate , 1960 to 2020") + labs(x = "Year", y = "property Crime rate")

#ACF and PACF graphs

ggAcf(violent) + ggtitle("ACF of violent crime rate")

ggPacf(violent) + ggtitle("PACF of violent crimae rate")

ggAcf(property) + ggtitle("ACF of property crime rate")

ggPacf(property) + ggtitle("PACF of property crimae rate")

## ACF and PACF graphs by differencing the series 

dviolent <- diff(violent)
ggAcf(dviolent) + ggtitle("ACF of violent crime rate (Differenced)") 
ggPacf(dviolent) + ggtitle("PACF of violent crime rate (Differenced)")


dproperty <- diff(property)
ggAcf(dproperty) + ggtitle("ACF of property crime rate (Differenced)") 
ggPacf(dproperty) + ggtitle("PACF of property crime rate (Differenced)")

## Differenced series graph

autoplot(dviolent) + ggtitle("violent crime rate (Differenced), 1960 to 2020") + labs(x = "Year", y = "violent crime rate")

autoplot(dproperty) + ggtitle("property crime rate (Differenced), 1960 to 2020") + labs(x = "Year", y = "property crime rate")

## Tests for non-stationarity

## ADF, PP, & KPSS

adf.test(violent) 
adf.test(violent, k = 1)
adf.test(violent, k = 2)
adf.test(dviolent)

pp.test(violent)
pp.test(dviolent)

kpss.test(violent)
kpss.test(dviolent)

adf.test(property) 
adf.test(property, k = 1)
adf.test(property, k = 2)
adf.test(dproperty)

pp.test(property)
pp.test(dproperty)

kpss.test(property)
kpss.test(dproperty)

## forecasting 
## split the data into training and testing series

split_vio <- ts_split(violent, sample.out = 13)
training <- split_vio$train 
testing <- split_vio$test
length(training)
length(testing)

split_vio <- ts_split(property, sample.out = 13)
training <- split_vio$train 
testing <- split_vio$test
length(training)
length(testing)

## Diagnosing the Training Set

arima_diag(training)


##Building the Forecast Model

#For Model 1
arima201 <- arima(training, order = c(1,0,9))
autoplot(arima201)
check_res(arima201)

#For Model 2
arima2011 <- arima(training, order = c(2,2,2))
autoplot(arima2011)
check_res(arima2011)

#For Model 3
auto <- auto.arima(training, seasonal = FALSE)
auto 
autoplot(auto)
check_res(auto)

##Generating the Forecasts and Forecast Evaluation

#For Model 1
fcast1 <- forecast(arima201, h = 13)
test_forecast(actual = property, forecast.obj = fcast1, test = testing)
accuracy(fcast1,testing)

#For Model 2
fcast2 <- forecast(arima2011, h = 13)
test_forecast(actual = property, forecast.obj = fcast2, test = testing)
accuracy(fcast2,testing)

#For Model 3
fcasta <- forecast(auto, h = 13)
test_forecast(actual = property, forecast.obj = fcasta, test = testing)
accuracy(fcasta,testing)

##Generating the Optimal Fit

finalfit <- auto.arima(violent, seasonal = FALSE)
autoplot(finalfit)
check_res(finalfit)


finalfit <- auto.arima(property, seasonal = FALSE)
autoplot(finalfit)
check_res(finalfit)


##Out of Sample Forecasting

fcastf <- forecast(violent, model = finalfit, h = 10)
plot_forecast(fcastf)
summary(fcastf)

fcastf <- forecast(property, model = finalfit, h = 10)
plot_forecast(fcastf)
summary(fcastf)
