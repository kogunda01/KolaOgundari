setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")

## load library for related to data format(stata)
library(haven)

## load the data
herringlobster <- read_dta("herringlobster.dta")

## view the data
View(herringlobster)
head(herringlobster)


##load packages 
library(tidyverse)
library(urca)
library(forecast)
library(tseries) 
library(TSstudio)

## Declaring the data as a time series 

lobster <- ts(herringlobster$logPRICE_lobster, start = c(1980,1), frequency = 12)

herring <- ts(herringlobster$logPRICE_Herring, start = c(1980,1), frequency = 12)

## graphs of the series

autoplot(lobster) + ggtitle("Lobster Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")

autoplot(herring) + ggtitle("herring Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")


## ACF and PACF graphs at levels

ggAcf(herring) + ggtitle("ACF of herring price")
ggPacf(herring) + ggtitle("PACF of herring price")


ggAcf(lobster) + ggtitle("ACF of lobster price")
ggPacf(lobster) + ggtitle("PACF of lobster price")


## ACF and PACF graphs by differencing the series 

dlobster <- diff(lobster)
ggAcf(dlobster) + ggtitle("ACF of Lobster price (Differenced)") 
ggPacf(dlobster) + ggtitle("PACF of Lobster price (Differenced)")


dherring <- diff(herring)
ggAcf(dherring) + ggtitle("ACF of herring price (Differenced)") 
ggPacf(dherring) + ggtitle("PACF of herring price (Differenced)")


## Differenced series graph

autoplot(dlobster) + ggtitle("Lobster Price (Differenced) , January 1980 to December 2016") + labs(x = "Time", y = "Price")

autoplot(dherring) + ggtitle("herring Price (Differenced) , January 1980 to December 2016") + labs(x = "Time", y = "Price")



## Decomposition of the series

ts_decompose(lobster, type = "additive", showline = TRUE)

ts_decompose(herring, type = "additive", showline = TRUE)


## Tests for non-stationarity

## ADF, PP, & KPSS

adf.test(lobster) 
adf.test(lobster, k = 1)
adf.test(lobster, k = 2)
adf.test(dlobster)

pp.test(lobster)
pp.test(dlobster)

kpss.test(lobster)
kpss.test(dlobster)


adf.test(herring) 
adf.test(herring, k = 1)
adf.test(herring, k = 2)
adf.test(dherring)

pp.test(herring)
pp.test(dherring)

kpss.test(herring)
kpss.test(dherring)

## forecasting 
## split the data into training and testing series


split_lob <- ts_split(lobster, sample.out = 48)
training <- split_lob$train 
testing <- split_lob$test
length(training)
length(testing)


split_her <- ts_split(herring, sample.out = 48)
training <- split_her$train 
testing <- split_her$test
length(training)
length(testing)

## Diagnosing the Training Set

arima_diag(training)


##Building the Forecast Model

#For Model 1
#For lobster
arima201 <- arima(training, order = c(2,1,1))
autoplot(arima201)
check_res(arima201)

#for herring
arima201h <- arima(training, order = c(6,1,2))
autoplot(arima201h)
check_res(arima201h)

# For model 2
sarima2101 <- arima(training, order = c(2,0,1), seasonal = list(order = c(1,0,0)))
autoplot(sarima2101)
check_res(sarima2101)

#for herring
sarima2101h <- arima(training, order = c(6,1,2), seasonal = list(order = c(1,0,0)))
autoplot(sarima2101h)
check_res(sarima2101h)

#For Model 3
auto <- auto.arima(training, seasonal = TRUE)
auto #We obtained a SARIMA(1,0,3)(2,1,2) based on auto.arima()
autoplot(auto)
check_res(auto)

# for herring 
auto1 <- auto.arima(training, seasonal = TRUE)
auto1 #We obtained a SARIMA(0,1,2)(1,0,0) based on auto.arima()
autoplot(auto1)
check_res(auto1)


##Generating the Forecasts and Forecast Evaluation

#For Model 1
fcast1 <- forecast(arima201, h = 48)
test_forecast(actual = lobster, forecast.obj = fcast1, test = testing)
accuracy(fcast1,testing)

#for herring
fcast11 <- forecast(arima201h, h = 48)
test_forecast(actual = herring, forecast.obj = fcast11, test = testing)
accuracy(fcast11,testing)


#For Model 2
fcast2 <- forecast(sarima2101, h = 48)
test_forecast(actual = lobster, forecast.obj = fcast2, test = testing)
accuracy(fcast2,testing)

# for herring
fcast22 <- forecast(sarima2101h, h = 48)
test_forecast(actual = herring, forecast.obj = fcast22, test = testing)
accuracy(fcast22,testing)

#For Model 3
fcasta <- forecast(auto, h = 48)
test_forecast(actual = lobster, forecast.obj = fcasta, test = testing)
accuracy(fcasta,testing)

#for herring 
fcasta1 <- forecast(auto1, h = 48)
test_forecast(actual = herring, forecast.obj = fcasta1, test = testing)
accuracy(fcasta1,testing)

##Generating the Optimal Fit

#lobsters
finalfit <- auto.arima(lobster, seasonal = TRUE)
autoplot(finalfit)
check_res(finalfit)

#for herring
finalfit1 <- auto.arima(herring, seasonal = TRUE)
autoplot(finalfit1)
check_res(finalfit1)

##Out of Sample Forecasting

fcastf <- forecast(lobster, model = finalfit, h = 12)
plot_forecast(fcastf)
summary(fcastf)

#for herring
fcastf1 <- forecast(herring, model = finalfit, h = 12)
plot_forecast(fcastf1)
summary(fcastf1)


## remove all files
rm(list = ls())
