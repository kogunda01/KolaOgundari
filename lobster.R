setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")

## load library for related to data format(stata)
library(haven)

## load the data
herring <- read_dta("herringlobster.dta")


## Declaring the data as a time series 
## Declaring data as a time series for only logPrice_herring
heP <- ts(herring$logPRICE_Herring, start = c(1980,1), frequency = 12)
heQ <- ts(herring$log_herring, start = c(1980,1), frequency = 12)
lobP <- ts(herring$logPRICE_lobster, start = c(1980,1), frequency = 12)
tukP <- ts(herring$logturkey, start = c(1980,1), frequency = 12)

## Declaring data as a time series for all the variables
herring2 <- ts(herring, start = c(1980,1), frequency = 12)

head (herring2)
tail(herring2)
View(herring2)
list(herring2)

colnames(herring2)
sort(colnames(herring2))


##load packages 
library(tidyverse)
library(urca)
library(forecast)
library(tseries) 
library(TSstudio)
library(readr)
library(ggplot2)
library(fpp2)
library(TTR)
library(dplyr)

## graphs of the series

autoplot(heP) + ggtitle("Herring Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")
autoplot(heQ) + ggtitle("Herring Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")
autoplot(lobP) + ggtitle("Herring Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")
autoplot(tukP) + ggtitle("Herring Price , January 1980 to December 2016") + labs(x = "Time", y = "Price")

##or

plot(heP)

## ACF and PACF graphs at levels

ggAcf(heP) + ggtitle("ACF of herring price")
ggPacf(heP) + ggtitle("PACF of herring price")

## or
acf(heP)
pacf(heP)

## ACF and PACF graphs by differencing the series 

dheP <- diff(heP)
ggAcf(dheP) + ggtitle("ACF of herring price (Differenced)") 
ggPacf(dheP) + ggtitle("PACF of herring price (Differenced)")


## Differenced series graph

autoplot(dheP) + ggtitle("herring Price (Differenced) , January 1980 to December 2016") + labs(x = "Time", y = "Price")


## Decomposition of the series

ts_decompose(herring1, type = "additive", showline = TRUE)

## Tests for non-stationarity

## ADF, PP, & KPSS

adf.test(heP) 
adf.test(heP, k = 1)
adf.test(heP, k = 2)
adf.test(dheP)

pp.test(heP)
pp.test(dheP)

kpss.test(heP)
kpss.test(dheP)


##Naive Forecasting Method
naive_mod <- naive(heP, h = 12)
summary(naive_mod)


##Simple Exponential Smoothing

se_model <- ses(heP, h = 12)
summary(se_model)

##  Holt's Trend Method

holt_model <- holt(heP, h = 12)
summary(holt_model)

##ARIMA model
## full sample
arima_model <- auto.arima(heP)
summary(arima_model)
autoplot(arima_model)
check_res(arima_model)

##forecasting

fore_arima = forecast::forecast(arima_model, h=12)
df_arima = as.data.frame(fore_arima)
testing$arima = df_arima$`Point Forecast`
mape(testing$logPRICE_Herring, testing$arima)


##training sample
arima_mode2 <- auto.arima(training, seasonal = TRUE)
summary(arima_mode2)
autoplot(arima_mode2)
check_res(arima_mode2)
str(arima_mode2)

fore_arima <- forecast(arima_mode2, h = 48)
test_forecast(actual = herring1, forecast.obj = fore_arima, test = testing)
accuracy(fore_arima,testing)


fcasta <- forecast(auto, h = 48)
test_forecast(actual = lobster, forecast.obj = fcasta, test = testing)
accuracy(fcasta,testing)



##How to run a simple regression Analysis in R

## pairwise correlation
pairs(logPRICE_Herring ~ log_herring + lobster_price + logturkey, data=herring)

pairs(heP ~ heQ + lobP + tukP)


## fit regression model
ols1 <- lm(logPRICE_Herring~ log_herring + lobster_price + logturkey, data=herring)
summary(ols1)

#or

ols2 <- lm(heP ~ heQ + lobP + tukP)
summary(ols2)

## VAR model for forecasting in a multivariate setting
##load packages 
library(urca)
library(vars)
library(mFilter)
library(tseries)
library(forecast)
library(tidyverse)
library(TSstudio)

## Data visualization

ggplot(data=herring) + geom_point(mapping = aes(x=log_herring, y=logPRICE_Herring))

#plot the series 
autoplot(cbind(heP, heQ, lobP, tukP))

ts_plot(heP)
ts_plot(heQ)
ts_plot(lobP)
ts_plot(tukP)

# determine persistence of the model

acf(heP, main= "ACF for Herring Price")
acf(heQ, main= "ACF for Herring landed quantity")
acf(lobP, main= "ACF for lobster Price")
acf(tukP, main= "ACF for turkey Price")

pacf(heP, main= "PACF for Herring Price")
pacf(heQ, main= "PACF for Herring landed quantity")
pacf(lobP, main= "PACF for lobster Price")
pacf(tukP, main= "PACF for turkey Price")

# finding optimal lags
# bind the series
helotuk<- cbind(heP, heQ, lobP, tukP)
colnames(helotuk) <- cbind("HerringPrice", "HerringCatch","lobsterPrice", "TurkeyPrice")

lagselect <- VARselect(helotuk, lag.max=10, type="const", season = NULL)
lagselect$selection

lagselect$criteria

lagselect1 <- VARselect(heP, lag.max=10, type="const", season = NULL)
lagselect1$selection

lagselect2 <- VARselect(heQ, lag.max=10, type="const", season = NULL)
lagselect2$selection

#Building model
Modelvar1 <- VAR (helotuk, p=9, type="const", season = NULL, exog=NULL )
summary(Modelvar1)

# Diagnostic tests
# serial correlation

serial1 <- serial.test(Modelvar1, lags.pt=12, type = "PT.asymptotic")
serial1


# heteroskedacity

heter1<- arch.test(Modelvar1, lags.multi = 12, multivariate.only = TRUE)
heter1

#normal distribution of residuals
normal1= normality.test(Modelvar1,  multivariate.only = TRUE)
normal1

#Testing for structural breaks in the residuals

stability1 <- stability(Modelvar1, type = "OLS-CUSUM")
plot(stability1)

#Granger causality 

GrangerHeQ<- causality(Modelvar1, cause= "HerringCatch")
GrangerHeQ

GrangerHeP<- causality(Modelvar1, cause= "HerringPrice")
GrangerHeP

#Impulse response functions

HePirf<- irf (Modelvar1, impulse= "heQ", response = "heP", n.ahead = 20, boot=TRUE)
plot(HePirf, ylab= "HerringPrice", main= "Schock Herring Catch")


HeQirf<- irf (Modelvar1, impulse= "heP", response = "heQ", n.ahead = 20, boot=TRUE)
plot(HeQirf, ylab= "heP", main= "Schock from Herring Prichttp://127.0.0.1:32319/graphics/plot_zoom_png?width=1200&height=546e")


# Variance Decomposition

FEVD1 <- fevd(Modelvar1, n.ahead = 10)
plot(FEVD1)

# VAR Forecast

forcaste1<- predict(Modelvar1, n.ahead = 12, ci=0.95)
fanchart(forcaste1, names = "heP")
fanchart(forcaste1, names = "heQ")

### Structural VAR model

amat<- diag(4)
amat
amat[2,1]<- NA
amat[3,1]<- NA
amat[3,2]<- NA
amat[4,1]<- NA
amat[4,2]<- NA
amat[4,3]<- NA

#build the model
helotuk<- cbind("heP", "heQ", "lobP", "tukP")
colnames(helotuk)<- cbind("HerringPrice", "HerringCatch","lobsterPrice", "TurkeyPrice")

#lag (p) order selection
lagselect <- VARselect(helotuk, lag.max=8, type="both")
lagselect$selection

#Building model
Modelvar1 <- VAR (helotuk, p=9, type="const", season = NULL, exog=NULL )
SVARModel1<- SVAR(Modelvar1, Amat=amat, Bmat = NULL, hessian=TRUE, estmethod = c("scoring", "direct"))
SVARModel1

#impulse Response Functions

SVARheP <- irf(SVARModel1, impulse= "HerringPrice", response= "HerringPrice")
SVARheP
plot(SVARheP)

SVARheQ <- irf(SVARModel1, impulse= "HerringPrice", response= "HerringCatch")
SVARheQ
plot(SVARheQ)
