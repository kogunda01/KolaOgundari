setwd("C:/Users/ogund/OneDrive/Documents/R_Nigeria")
dir()

Stores = read.csv("BHE-Stores.csv")  # read from csv data file
Test = read.csv("BHE-test.csv")  # read from csv data file
Train = read.csv("BHE-Train.csv")  # read from csv data

# Data cleaning & organization
#deleting the row and creating data by store

# creating subset data by store 
# create subset data from the Train data
new_251 = Train[seq(1, nrow(Train), 5), ]
new_262 = Train[seq(2, nrow(Train), 5), ]
new_562 = Train[seq(3, nrow(Train), 5), ]
new_1114 = Train[seq(5, nrow(Train), 5),]

#create subset data from the Test data
new_251Test = Test[seq(1, nrow(Test), 4), ]
new_262Test = Test[seq(2, nrow(Test), 4), ]
new_562Test = Test[seq(3, nrow(Test), 4), ]
new_1114Test = Test[seq(4, nrow(Test), 4), ]

#creat new column of Sale in Test data
new_251Test$Sale_Forecasted<-NA
new_262Test$Sale_Forecasted<-NA
new_562Test$Sale_Forecasted<-NA
new_1114Test$Sale_Forecasted<-NA

# write the data according to each store
write.csv(new_251Test,"C:/Users/ogund/OneDrive/Documents/R_Nigeria/sales_251Test.csv")
write.csv(new_262Test,"C:/Users/ogund/OneDrive/Documents/R_Nigeria/sales_262Test.csv")
write.csv(new_562Test,"C:/Users/ogund/OneDrive/Documents/R_Nigeria/sales_562Test.csv")
write.csv(new_1114Test,"C:/Users/ogund/OneDrive/Documents/R_Nigeria/sales_1114Test.csv")



# declare the daily data as time series

sale_251=ts(new_251$Sales, start=c(2013,1,1),frequency=365 )
sale_262=ts(new_262$Sales, start=c(2013,1,1),frequency=365)
sale_562=ts(new_562$Sales, start=c(2013,1,1),frequency=365)
sale_1114=ts(new_1114$Sales, start=c(2013,1,1),frequency=365)

#load packages
library(ggplot2)
library(zoo)
library(Rcpp)
library(xts)
library(timeSeries)

# Data visualization
# ts plots of the sale series by store
#using plot.ts from ts function
tsdisplay(sale_251, plot.type = c("scatter"),na.action=na.contiguous, main=NULL,lag.max = 20, pch=1, cex = 0.5)
tsdisplay(sale_262, plot.type = c("scatter"),na.action=na.contiguous, main=NULL,lag.max = 20, pch=1, cex = 0.5)
tsdisplay(sale_562, plot.type = c("scatter"),na.action=na.contiguous, main=NULL,lag.max = 20, pch=1, cex = 0.5)
tsdisplay(sale_1114, plot.type = c("scatter"),na.action=na.contiguous, main=NULL,lag.max = 20, pch=1, cex = 0.5)

is.Arima(sale_251)
is.Arima(sale_262)
is.Arima(sale_562)
is.Arima(sale_1114)

is.forecast(sale_562)
is.Arima(sale_1114)


# load packages unit root test
library(urca)
library(fUnitRoots)
library(tseries)
library(lmtest)

## To test whether the data is stationary or not, we need to carry out unit root test
## unit root test for store 251
DF_251 <- ur.df(sale_251, type="drift", selectlags = "AIC") 
summary(DF_251)
pp.251 <- ur.pp(sale_251, type="Z-tau", model="constant", lags="short") 
summary(pp.251)
kpss.251 <- ur.kpss(sale_251, type="tau", lags="short") 
summary(kpss.251)

## unit root test for store 262
DF_262 <- ur.df(sale_262, type="drift", selectlags = "AIC") 
summary(DF_262)
pp.262 <- ur.pp(sale_262, type="Z-tau", model="constant", lags="short") 
summary(pp.262)
kpss.262 <- ur.kpss(sale_262, type="tau", lags="short") 
summary(kpss.262)

## unit root test for store 562
DF_562 <- ur.df(sale_562, type="drift", selectlags = "AIC") 
summary(DF_562)
pp.562 <- ur.pp(sale_562, type="Z-tau", model="constant", lags="short") 
summary(pp.562)
kpss.562 <- ur.kpss(sale_562, type="tau", lags="short") 
summary(kpss.562)

## unit root test for store 1114
DF_1114 <- ur.df(sale_1114, type="drift", selectlags = "AIC") 
summary(DF_1114)
pp.1114 <- ur.pp(sale_1114, type="Z-tau", model="constant", lags="short") 
summary(pp.1114)
kpss.1114 <- ur.kpss(sale_1114, type="tau", lags="short") 
summary(kpss.1114)

# forecasting
## checking for serial correlation in sale series by store
### check for the serial correlation in the residual using ACF and PACF 

## preliminary analysis based ACF and PACF for store 251
urdfTest(sale_251, lags = 1, type = c( "c"), doplot = TRUE)
urkpssTest(sale_251, type = c("tau"), lags = c("short"), use.lag = NULL, doplot = TRUE)
urppTest(sale_251, type = c("Z-tau"), model = c("constant"), lags = c("short"), use.lag = NULL, doplot = TRUE)

## preliminary analysis based on ACF and PACF for store 262
urdfTest(sale_262, lags = 1, type = c( "c"), doplot = TRUE)
urkpssTest(sale_262, type = c("tau"), lags = c("short"), use.lag = NULL, doplot = TRUE)
urppTest(sale_262, type = c("Z-tau"), model = c("constant"), lags = c("short"), use.lag = NULL, doplot = TRUE)

## preliminary based ACF and PACF for store 562
urdfTest(sale_562, lags = 1, type = c( "c"), doplot = TRUE)
urkpssTest(sale_562, type = c("tau"), lags = c("short"), use.lag = NULL, doplot = TRUE)
urppTest(sale_562, type = c("Z-tau"), model = c("constant"), lags = c("short"), use.lag = NULL, doplot = TRUE)


## preliminary based ACF and PACF for store 1114
urdfTest(sale_1114, lags = 1, type = c( "c"), doplot = TRUE)
urkpssTest(sale_1114, type = c("tau"), lags = c("short"), use.lag = NULL, doplot = TRUE)
urppTest(sale_1114, type = c("Z-tau"), model = c("constant"), lags = c("short"), use.lag = NULL, doplot = TRUE)

## load packages
library(forecast)
library(locfit)
library(jsonlite)
library(tseries)
library(stats)
library(data.table)

# since Ljung-Box test fails to reject serial correlation in the series, I use ARIMA model with different specification for forecasting    
# Our forcast time period is between 2015/8/1 and 2015/9/17, which rerepresnt 48 days based on Test data
# state space model: exponential smoothing

 # forecast using ARIMA (p,d,q)

 ## using ACF to select q and PACF to select p
 par(mfrow=c(2,1))
 acf(sale_251)
 pacf(sale_251)
 
 # using auto arima to select oder of p and q
 arima251auto=auto.arima(sale_251)
 arima251auto
 plot(arima251auto)
 
 ## fit ARIMA model based on q selected from ACF and p selected from the PACF & auto.arima model suggestion
 nobs=length(sale_251)
 arima251A=arima(sale_251, order=c(5,0,10),xreg = 1:nobs)
 summary(arima251A)
 fit251=arima(sale_251, order=c(4,0,4), xreg = 1:nobs)
 summary(fit251)
 arima251auto=arima(sale_251, order=c(4,0,2), xreg = 1:nobs) # based on the auto.arima
 summary(arima251auto)
 

 ## model diagnostics
 
 #stability of the models
 plot(arima251A)
 plot(fit251)
 plot(arima251auto)
 
 # The Diebold-Mariano test to compare accuracy of the forecast methods
 dm.test(residuals(arima251A), residuals(arima251auto), h=1)
 dm.test(residuals(arima251A), residuals(fit251), h=1)
 dm.test(residuals(fit251), residuals(arima251auto), h=1)
 
 
 # graph of the stationary of the residuals of the fit, acf and autoccorelation  
 tsdiag(arima251A)
 tsdiag(fit251)
 tsdiag(arima251auto)
 # Historgram of forecast errors
 plotForecastErrors <- function(forecasterrors)
 {
   # make a histogram of the forecast errors:
   mybinsize <- IQR(forecasterrors)/4
   mysd <- sd(forecasterrors)
   mymin <- min(forecasterrors) - mysd*5
   mymax <- max(forecasterrors) + mysd*3
   # generate normally distributed data with mean 0 and standard deviation mysd
   mynorm <- rnorm(10000, mean=0, sd=mysd)
   mymin2 <- min(mynorm)
   mymax2 <- max(mynorm)
   if (mymin2 < mymin) { mymin <- mymin2 }
   if (mymax2 > mymax) { mymax <- mymax2 }
   # make a red histogram of the forecast errors, with the normally distributed?????data overlaid:
   mybins <- seq(mymin, mymax, mybinsize)
   hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
   # freq=FALSE ensures the area under the histogram = 1
   # generate normally distributed data with mean 0 and standard deviation mysd
   myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
   # plot the normal curve as a blue line on top of the histogram of forecast?????errors:
   points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
 }
 
 plotForecastErrors(arima251A$residuals)
 plotForecastErrors(fit251$residuals)
 plotForecastErrors(arima251auto$residuals)
 
# Ljung-Box to test for serial correlation in the residual of the models fitted
 Box.test(arima251A$residuals, lag=2, type = "Ljung-Box")
 Box.test(fit251$residuals, lag=2, type = "Ljung-Box")
 Box.test(arima251auto$residuals, lag=2, type = "Ljung-Box")
 

 ## actual forecast based on selected model with the least AIC
 fore251=predict(arima251A,48, newxreg=(nobs+1):(nobs+48))
 par(mfrow=c(2,1))
 ts.plot(sale_251, fore251$pred, col=1:2)
 dForec251=print(fore251)
 write.csv(dForec251,"C:/Users/ogund/OneDrive/Documents/work/Forecast251.csv")
 
 ## forecasted errors 
 accuracy(arima251A) 
 accuracy(fit251) 
 accuracy(arima251) 
 
 
 # Store262
 ## using ACF to select q and PACF to select p
 par(mfrow=c(2,1))
 acf(sale_262)
 pacf(sale_262)
 
 # using auto arima to select oder of p and q
 arima262auto=auto.arima(sale_262)
 arima262auto
 plot(arima262auto)
 
 ## fit ARIMA model based on q selected from ACF and p selected from the PACF & auto.arima model suggestion
 nobs=length(sale_262)
 arima262A=arima(sale_262, order=c(9,0,8), xreg = 1:nobs)
 summary(arima262A)
 fit262=arima(sale_262, order=c(7,0,4), xreg = 1:nobs)
 summary(fit262)
 arima262auto=arima(sale_262, order=c(1,0,1), xreg = 1:nobs) # based on the auto.arima
 summary(arima262auto)
 
 
 ## model diagnostics
 
 #stability of the models
 plot(arima262A)
 plot(fit262)
 plot(arima262auto)
 
 # The Diebold-Mariano test to compare accuracy of the forecast methods
 dm.test(residuals(arima262A), residuals(arima262auto), h=1)
 dm.test(residuals(arima262A), residuals(fit262), h=1)
 dm.test(residuals(fit262), residuals(arima262auto), h=1)
 
 # graph of the stationary of the residuals of the fists, acf and autoccorelation  
 tsdiag(arima262A)
 tsdiag(fit262)
 tsdiag(arima262auto)
 # Historgram of forecast errors
 plotForecastErrors(arima262A$residuals)
 plotForecastErrors(fit262$residuals)
 plotForecastErrors(arima262auto$residuals)
 
 # Ljung-Box to test for serial correlation in the residual sof the fits
 Box.test(arima262A$residuals, lag=2, type = "Ljung-Box")
 Box.test(fit262$residuals, lag=2, type = "Ljung-Box")
 Box.test(arima262auto$residuals, lag=2, type = "Ljung-Box")
 
 
 ## actual forecast based on selected model with the least AIC
 fore262=predict(arima262A,48, newxreg=(nobs+1):(nobs+48))
 par(mfrow=c(2,1))
 ts.plot(sale_262, fore262$pred, col=1:2)
 dForec262=print(fore262)
 write.csv(dForec262,"C:/Users/ogund/OneDrive/Documents/work/Forecast262.csv")
 
 ## forecasted errors 
 accuracy(arima262A) 
 accuracy(fit262) 
 accuracy(arima262) 
 

 
 # Store562
 ## using ACF to select q and PACF to select p
 par(mfrow=c(2,1))
 acf(sale_562)
 pacf(sale_562)
 
 # using auto arima to select oder of p and q
 arima562auto=auto.arima(sale_562)
 arima562auto
 plot(arima562auto)
 
 ## fit ARIMA model based on q selected from ACF and p selected from the PACF & auto.arima model suggestion
 nobs=length(sale_562)
 arima562A=arima(sale_262, order=c(9,0,5), xreg = 1:nobs)
 summary(arima562A)
 fit562=arima(sale_562, order=c(5,0,7), xreg = 1:nobs)
 summary(fit562)
 arima562auto=arima(sale_562, order=c(2,0,3), xreg = 1:nobs) # based on the auto.arima
 summary(arima562auto)
 

 ## model diagnostics
 #stability of the models
 plot(arima562A)
 plot(fit562)
 plot(arima562auto)
 
 # The Diebold-Mariano test to compare accuracy of the forecast methods
 dm.test(residuals(arima562A), residuals(arima562auto), h=1)
 dm.test(residuals(arima562A), residuals(fit562), h=1)
 dm.test(residuals(fit562), residuals(arima562auto), h=1)
 
 # graph of the stationary of the residuals of the fists, acf and autoccorelation  
 tsdiag(arima562A)
 tsdiag(fit562)
 tsdiag(arima562auto)
 # Historgram of forecast errors
 plotForecastErrors(arima562A$residuals)
 plotForecastErrors(fit562$residuals)
 plotForecastErrors(arima562auto$residuals)
 
 # Ljung-Box to test for serial correlation in the residual sof the fits
 Box.test(arima562A$residuals, lag=2, type = "Ljung-Box")
 Box.test(fit562$residuals, lag=2, type = "Ljung-Box")
 Box.test(arima562auto$residuals,lag=2, type = "Ljung-Box")
 
 
 ## actual forecast based on selected model with the least AIC
 fore562=predict(fit562,48, newxreg=(nobs+1):(nobs+48))
 par(mfrow=c(2,1))
 ts.plot(sale_562, fore562$pred, col=1:2)
 dForec562=print(fore562)
 write.csv(dForec562,"C:/Users/ogund/OneDrive/Documents/work/Forecast562.csv")
 
 ## forecasted errors 
 accuracy(arima562A) 
 accuracy(fit562) 
 accuracy(arima562) 
 
 
 # Store1114

 
 ## using ACF to select q and PACF to select p
 par(mfrow=c(2,1))
 acf(sale_1114)
 pacf(sale_1114)
 
 # using auto arima to select oder of p and q
 arima1114auto=auto.arima(sale_1114)
 arima1114auto
 plot(arima1114auto)
 
 ## fit ARIMA model based on q selected from ACF and p selected from the PACF & auto.arima model suggestion
 nobs=length(sale_1114)
 arima1114A=arima(sale_1114, order=c(8,0,3), xreg = 1:nobs)
 summary(arima1114A)
 fit1114=arima(sale_1114, order=c(8,0,5), xreg = 1:nobs)
 summary(fit1114)
 arima1114auto=arima(sale_1114, order=c(5,1,5), xreg = 1:nobs)
 summary(arima1114auto)
 
 
 ## model diagnostics
 #stability of the models
 plot(arima1114A)
 plot(fit1114)
 plot(arima1114auto)
 
 # The Diebold-Mariano test to compare accuracy of the forecast methods
 dm.test(residuals(arima1114A), residuals(arima1114auto), h=1)
 dm.test(residuals(arima1114A), residuals(fit1114), h=1)
 dm.test(residuals(fit1114), residuals(arima1114auto), h=1)
 
 # graph of the stationary of the residuals of the fists, acf and autoccorelation  
 tsdiag(arima1114A)
 tsdiag(fit1114)
 tsdiag(arima1114auto)
 # Historgram of forecast errors
 plotForecastErrors(arima1114A$residuals)
 plotForecastErrors(fit1114$residuals)
 plotForecastErrors(arima1114auto$residuals)
 
 # Ljung-Box to test for serial correlation in the residual sof the fits
 Box.test(arima1114A$residuals, lag=2, type = "Ljung-Box")
 Box.test(fit1114$residuals, lag=2, type = "Ljung-Box")
 Box.test(arima1114auto$residuals,lag=2, type = "Ljung-Box")
 
 
 ## actual forecast based on selected model with the least AIC
 fore1114=predict(fit1114,48, newxreg=(nobs+1):(nobs+48))
 par(mfrow=c(2,1))
 ts.plot(sale_1114, fore1114$pred, col=1:2)
 dForec1114=print(fore1114)
 write.csv(dForec1114,"C:/Users/ogund/OneDrive/Documents/work/Forecast1114.csv")
 
 ## forecasted errors 
 accuracy(arima1114A) 
 accuracy(fit1114) 
 accuracy(arima1114) 
 
 
 