use "C:\Users\ogund\OneDrive\Desktop\crime_incarceration\crime_GDP.dta", replace

tsset year

** graphs***

twoway tsline log_Prisoners 
twoway tsline log_TOTALCRIME_rate
twoway tsline log_GDP
twoway tsline log_Totalviolent
twoway tsline log_Totalproperty

twoway tsline diff_totalcrime
twoway tsline diff_prisoners
twoway tsline diff_violent
twoway tsline diff_property 
twoway tsline diff_GDP

total_violent_crime total_property_crime total_crime  real_gdp_percapita

tw (tsline real_gdp_percapita, yaxis(2)) (tsline total_crime  ), ti(" GDP & Crime rates in USA")

tw (tsline total_property_crime, yaxis(2)) (tsline total_violent_crime ), ti(" Crime rates in USA")

gen log_crime = log(total_crime)

tw (tsline log_GDP, yaxis(2)) (tsline log_crime ), ti(" GDP & Crime rates in USA")

tw (tsline log_Prisoners, yaxis(2)) (tsline log_TOTALCRIME_rate ), ti(" Incarceration & Crime rates in USA")

tw (tsline log_Totalproperty, yaxis(2)) (tsline log_Totalviolent ), ti(" Crime rates in USA")

tw (tsline log_TOTALCRIME_rate, yaxis(2)) (tsline log_Totalviolent log_Totalproperty ), ti(" Crime rates in USA")

** determining number of lags***
varsoc log_TOTALCRIME_rate 
varsoc log_GDP
varsoc log_Prisoners 
varsoc log_Totalviolent
varsoc log_Totalproperty



**unit root tests**

dfuller log_Prisoners , lags(2) trend
dfuller log_TOTALCRIME_rate , lags(4) trend
dfuller log_Totalviolent , lags(3) trend
dfuller log_Totalproperty , lags(4) trend
dfuller log_GDP , lags(3)trend


dfuller d.log_Prisoners
dfuller d.log_TOTALCRIME_rate
dfuller d.log_Totalviolent 
dfuller d.log_Totalproperty 
dfuller d.log_GDP 

dfgls log_Prisoners , trend
dfgls log_TOTALCRIME_rate , trend
dfgls log_Totalviolent , trend
dfgls log_Totalproperty, trend 
dfgls log_GDP, trend

dfgls d.log_Prisoners 
dfgls d.log_TOTALCRIME_rate 
dfgls d.log_Totalviolent 
dfgls d.log_Totalproperty 
dfgls d.log_GDP


pperron log_Prisoners , lags(2)  
pperron log_TOTALCRIME_rate , lags(4)
pperron log_Totalviolent , lags(3)
pperron log_Totalproperty , lags(4)
pperron log_GDP , lags(3)trend

 kpss log_Prisoners ,  trend  /* optimum lag based on the test is 2*/
 kpss log_TOTALCRIME_rate , trend /* optimum lag based on the test is 4*/
 kpss log_Totalviolent , trend /* optimum lag based on the test is 3*/
 kpss log_Totalproperty , trend  /* optimum lag based on the test is 4*/
 kpss log_GDP , trend  /* optimum lag based on the test is 3*/

 kpss d.log_Prisoners ,  trend  /* optimum lag based on the test is 2*/
 kpss d.log_TOTALCRIME_rate , trend /* optimum lag based on the test is 4*/
 kpss d.log_Totalviolent , trend /* optimum lag based on the test is 3*/
 kpss d.log_Totalproperty , trend  /* optimum lag based on the test is 4*/
 kpss d.log_GDP , trend  /* optimum lag based on the test is 3*/

** test for cointegration relationship using ARDL ***

** using regression command***
** with lag equals 0 (k=0)***
reg diff_totalcrime  diff_prisoners  l.log_TOTALCRIME_rate l.log_Prisoners
test (l.log_TOTALCRIME_rate =0) (l.log_Prisoners = 0) 
estat ic

** with lag equals 1 (k=1)***
reg diff_totalcrime l.diff_totalcrime diff_prisoners l.diff_prisoners l.log_TOTALCRIME_rate l.log_Prisoners
test (l.log_TOTALCRIME_rate =0) (l.log_Prisoners = 0) 
estat ic

** with lag equals 3 (k=3)***
reg diff_totalcrime L(1/3).diff_totalcrime  L(0/3).diff_prisoners l.log_TOTALCRIME_rate l.log_Prisoners
test (l.log_TOTALCRIME_rate =0) (l.log_Prisoners = 0) 
estat ic



** using ARDL stata command**
ardl log_TOTALCRIME_rate log_Prisoners, lags(5) ec1 /* equivalent to 4 lags*/
estat btest
estat ic

ardl log_Prisoners  log_TOTALCRIME_rate , lags(5) ec1
estat btest
estat ic

ardl log_Totalviolent log_Prisoners, lags(4) ec1 /* equivalent to 3 lags*/
estat btest
estat ic

ardl log_Prisoners  log_Totalviolent, lags(4) ec1 /* equivalent to 3 lags*/
estat btest
estat ic

ardl log_Totalproperty log_Prisoners, lags(5) ec1
estat btest
estat ic

ardl log_Prisoners  log_Totalproperty, lags(5) ec1
estat btest
estat ic

ardl log_TOTALCRIME_rate log_GDP, lags(2) ec1
estat btest

ardl log_GDP  log_TOTALCRIME_rate , lags(2) ec1
estat btest


***Long run relationship***

reg log_TOTALCRIME_rate log_Prisoners
predict ect1, res
reg log_Prisoners log_TOTALCRIME_rate 
predict ect2, res

reg log_Totalviolent log_Prisoners
predict ect3, res
reg log_Prisoners log_Totalviolent 
predict ect4, res

reg log_Totalproperty log_Prisoners
predict ect5, res
reg log_Prisoners log_Totalproperty 
predict ect6, res



**short run relationship*** 
reg diff_totalcrime l.diff_totalcrime l.diff_prisoners l.ect1 
test (l.diff_prisoners = 0) 
test (l.ect1 = 0) 
test (l.diff_prisoners = l.ect1 = 0) 

reg diff_prisoners l.diff_prisoners l.diff_totalcrime l.ect2 
test (l.diff_totalcrime = 0) 
test (l.ect2 = 0) 
test (l.diff_totalcrime = l.ect2 = 0) 


reg diff_violent l.diff_violent l.diff_prisoners l.ect3 
test (l.diff_prisoners = 0) 
test (l.ect3 = 0) 
test (l.diff_prisoners = l.ect3 = 0) 

reg diff_prisoners l.diff_prisoners l.diff_violent l.ect4 
test (l.diff_violent = 0) 
test (l.ect4 = 0) 
test (l.diff_violent = l.ect4 = 0) 


reg diff_property l.diff_property l.diff_prisoners l.ect5
test (l.diff_prisoners = 0) 
test (l.ect5 = 0) 
test (l.diff_prisoners = l.ect5 = 0) 

reg diff_prisoners l.diff_prisoners l.diff_property l.ect6 
test (l.diff_property = 0) 
test (l.ect6 = 0) 
test (l.diff_property = l.ect6 = 0) 



*** specific analysis**

*** long run estimate***

** incarceration effect on crime without lag***

eststo total: reg log_TOTALCRIME_rate log_Prisoners
predict ect1, res
eststo violent: reg log_Totalviolent log_Prisoners
predict ect3, res
eststo property: reg log_Totalproperty log_Prisoners
predict ect5, res
esttab, aic bic title(incarceration effect on crime) mtitle("total" "violent" "property")


** incarceration effect on crime with lag***

eststo total: reg log_TOTALCRIME_rate l.log_Prisoners
predict ect1, res
eststo violent: reg log_Totalviolent l.log_Prisoners
predict ect3, res
eststo property: reg log_Totalproperty l.log_Prisoners
predict ect5, res
esttab, aic bic title(incarceration effect on crime) mtitle("total" "violent" "property")

** effect of crime on incarceration without lag***

eststo total: reg log_Prisoners log_TOTALCRIME_rate 
predict ect2, res
eststo violent: reg log_Prisoners log_Totalviolent 
predict ect4, res
eststo property: reg log_Prisoners log_Totalproperty 
predict ect6, res
esttab, aic bic title(crime effect on incarceration) mtitle("total" "violent" "property")


** effect of crime on incarceration with lag***

eststo total: reg log_Prisoners l.log_TOTALCRIME_rate
predict ect2, res
eststo violent: reg log_Prisoners l.log_Totalviolent
predict ect4, res
eststo property: reg log_Prisoners l.log_Totalproperty 
predict ect6, res
esttab, aic bic title(crime effect on incarceration) mtitle("total" "violent" "property")


** short run estimate**


eststo total: reg diff_totalcrime l.diff_totalcrime l.diff_prisoners l.ect1 
test (l.diff_prisoners = 0) 
test (l.ect1 = 0) 
test (l.diff_prisoners = l.ect1 = 0) 
eststo violent: reg diff_violent l.diff_violent l.diff_prisoners l.ect3 
test (l.diff_prisoners = 0) 
test (l.ect3 = 0) 
test (l.diff_prisoners = l.ect3 = 0) 
eststo property: reg diff_property l.diff_property l.diff_prisoners l.ect5
test (l.diff_prisoners = 0) 
test (l.ect5 = 0) 
test (l.diff_prisoners = l.ect5 = 0) 
esttab, aic bic title(crime effect on incarceration) mtitle("total" "violent" "property")



eststo total: reg diff_prisoners l.diff_prisoners l.diff_totalcrime l.ect2
test (l.diff_totalcrime = 0) 
test (l.ect2 = 0) 
test (l.diff_totalcrime = l.ect2 = 0) 
eststo violent: reg diff_prisoners l.diff_prisoners l.diff_violent l.ect4
test (l.diff_violent = 0) 
test (l.ect4 = 0) 
test (l.diff_violent = l.ect4 = 0) 
eststo property: reg diff_prisoners l.diff_prisoners l.diff_property l.ect6
test (l.diff_property = 0) 
test (l.ect6 = 0) 
test (l.diff_property = l.ect6 = 0) 
esttab, aic bic title(crime effect on incarceration) mtitle("total" "violent" "property")



***

var log_TOTALCRIME_rate log_Prisoners, lags(1/3)


*** economic impact of crime***
*** long run***

** total crime & GDP***

eststo Total: reg log_TOTALCRIME_rate log_GDP
predict ect7, res
eststo GDP: reg log_GDP log_TOTALCRIME_rate
predict ect8, res
esttab, aic bic title(relationship between total crime and economy) mtitle("Total" "GDP")

eststo Total: reg log_TOTALCRIME_rate  l.log_GDP
predict ect7, res
eststo GDP: reg log_GDP l.log_TOTALCRIME_rate
predict ect8, res
esttab, aic bic title(relationship between total crime and economy) mtitle("Total" "GDP")


** violent crime & GDP***

eststo violent: reg log_Totalviolent log_GDP
predict ect9, res
eststo GDP: reg log_GDP log_Totalviolent 
predict ect10, res
esttab, aic bic title(relationship between violrnt crime and economy) mtitle("violent" "GDP")

eststo violent: reg log_Totalviolent l.log_GDP
predict ect9, res
eststo GDP: reg log_GDP l.log_Totalviolent 
predict ect10, res
esttab, aic bic title(relationship between violent crime and economy) mtitle("violent" "GDP")


** property crime & GDP***

eststo property: reg log_Totalproperty log_GDP
predict ect11, res
eststo GDP: reg log_GDP log_Totalproperty
predict ect12, res
esttab, aic bic title(relationship between property crime and economy) mtitle("property" "GDP")

eststo property: reg log_Totalproperty l.log_GDP
predict ect11, res
eststo GDP: reg log_GDP l.log_Totalproperty 
predict ect12, res
esttab, aic bic title(relationship between property crime and economy) mtitle("property" "GDP")

**short run**

** total crime & GDP***

eststo Total: reg diff_totalcrime l.diff_totalcrime l.diff_GDP l.ect7 
test (l.diff_GDP = 0) 
test (l.ect7 = 0) 
test (l.diff_GDP = l.ect7 = 0) 
eststo GDP: reg diff_GDP l.diff_GDP l.diff_totalcrime l.ect8
test (l.diff_totalcrime = 0) 
test (l.ect8 = 0) 
test (l.diff_totalcrime = l.ect8 = 0) 
esttab, aic bic title(relationship between total crime and economy) mtitle("Total" "GDP")


** violent crime & GDP***

eststo violent: reg diff_violent l.diff_violent l.diff_GDP l.ect9 
test (l.diff_GDP = 0) 
test (l.ect9 = 0) 
test (l.diff_GDP = l.ect9 = 0) 
eststo GDP: reg diff_GDP l.diff_GDP l.diff_violent l.ect10
test (l.diff_violent = 0) 
test (l.ect10 = 0) 
test (l.diff_violent = l.ect10 = 0) 
esttab, aic bic title(relationship between violent crime and economy) mtitle("violent" "GDP")


** property crime & GDP***

eststo property: reg diff_property l.diff_property l.diff_GDP l.ect11
test (l.diff_GDP = 0) 
test (l.ect11 = 0) 
test (l.diff_GDP = l.ect11 = 0) 
eststo GDP: reg diff_GDP l.diff_GDP l.diff_property l.ect12
test (l.diff_property  = 0) 
test (l.ect12 = 0) 
test (l.diff_property  = l.ect12 = 0) 
esttab, aic bic title(relationship between property crime and economy) mtitle("property" "GDP")



** cumulative***

cumul log_TOTALCRIME_rate , gen(k)
line k log_TOTALCRIME_rate

***analysis time series***

tsmktim time, start(1960) 
tsset time 

**or**

generate time2= y(1960)+_n-1
format time2 %ty
tsset time2

** dummy variable for policy***

generate d=(t>=tm(1984m1)) 
generate d_crimedecline=(time>=1982) 


*** forecasting crime rate condictional on incarceration rate**
** AR for P
** MA for q
** ac and pac functions ***
** use pac for p and ac for q**

corrgram log_TOTALCRIME_rate
corrgram diff_totalcrime


corrgram log_Prisoners 
corrgram diff_prisoners

ac log_TOTALCRIME_rate /* determinng order q*/
pac log_TOTALCRIME_rate

ac log_Prisoners 
pac log_Prisoners


ac diff_totalcrime
pac diff_totalcrime, srv

ac diff_prisoners
pac diff_prisoners, srv



corrgram diff_totalcrime

** fitting arima (p, d, q) model***

arima  log_TOTALCRIME_rate , arima(2,1,2) bfgs
estat ic
predict res1, re
arima  log_TOTALCRIME_rate , arima(2,1,1) bfgs
estat ic
predict res2, re

** or***

arima  diff_totalcrime , arima(2,0,2) bfgs
estat ic
predict res1, re
arima  diff_totalcrime , arima(2,0,1) bfgs
estat ic
predict res2, re


** Diagnostic of the model**

ac res1 /* using ac plot*/
pac res1 /* using pac plot*/

ac res2 /* using ac plot*/
pac res2 /* using pac plot*/

arima  diff_prisoners, arima(4,0,0) bfgs
estat ic
predict res3, re
arima  diff_prisoners, arima(1,0,0) bfgs
estat ic
predict res4, re

** Diagnostic of the model**

ac res3 /* using ac plot*/
pac res3  /* using pac plot*/

ac res4  /* using ac plot*/
pac res4  /* using pac plot*/

dfuller res1  /*testing stationarity of the residual*/
dfuller res2  /*testing stationarity of the residual*/
dfuller res3  /*testing stationarity of the residual*/
dfuller res4  /*testing stationarity of the residual*/

** whiet noise test**

wntestq res1, lag(40)
wntestq res2, lag(40)
wntestq res3, lag(40)
wntestq res4, lag(40)

****forecatsing crime rate and incarceration ***

eststo ar11c: arima  d.log_TOTALCRIME_rate, arima(2,0,2) nolog
eststo ar12c: arima  d.log_TOTALCRIME_rate, arima(2,0,1) nolog
eststo ar13c: arima  d.log_Prisoners,  arima(4,0,0) nolog
eststo ar14c: arima  d.log_Prisoners,  arima(1,0,0) nolog
esttab, aic bic title(forecasting incarceration & crime) mtitle("ar11c" "ar12c" "ar13c" "ar14c")


eststo ar11c: arima  log_TOTALCRIME_rate, arima(2,1,2) nolog
eststo ar12c: arima  log_TOTALCRIME_rate, arima(2,1,1) nolog
eststo ar13c: arima  log_Prisoners,  arima(4,1,0) nolog
eststo ar14c: arima  log_Prisoners,  arima(1,1,0) nolog
esttab, aic bic title(forecasting incarceration & crime) mtitle("ar11c" "ar12c" "ar13c" "ar14c")


** forecasting  crime rate conditional on incarceration***


arima d.log_TOTALCRIME_rate d.log_Prisoners if tin(, 2014), ar(1/2) ma(1/2) nolog 
predict crime_new, xb
predict crime_new1, xb dynamic (y(2015))

tsline crime_new, ti("ARIMA(2,2) model of effect of incarceration on Crime rate")
tw (tsline crime_new2, yaxis(2)) (tsline crime_new), ti("ARIMA(2,2) model of effect of incarceration on Crime rate")

**OR***
arima log_TOTALCRIME_rate log_Prisoners if tin(, 2008), arima(2,1,2) nolog 
predict resd_1, res 

predict crime_new, y
predict crime_new2, y dynamic (y(2008))

tsline log_TOTALCRIME_rate crime_new2, ti("ARIMA(2,1,2) model of incarceration effect on Crime Rate")
tw (tsline resd_1, yaxis(2)) (tsline crime_new2), ti("ARIMA(2,1,2) model of effect of incarceration on Crime Rate")

***  ARMILA model for forecasting***
arima log_TOTALCRIME_rate log_Prisoners if tin(, 2008), arima(2,1,2) nolog 
label var log_TOTALCRIME_rate"Actual"

predict double crime_new2 if tin(2002,), y
label var crime_new2 "static forecast" 

predict double crime_new3 if tin(2002,), dynamic(y(2008)) y 
label var crime_new3 "dynamic forecast" 

tw (tsline crime_new2 crime_new3 if !mi(crime_new2)) /// 
(scatter log_TOTALCRIME_rate year if !mi(crime_new2), c(i)), scheme(s2mono) /// 
ti("Static and dynamic ex ante forecasts of crime rate-ARIMA(2,1,2)") /// 
 t2("Forecast horizon: 2009-2014") legend(rows(1))


 
arima log_TOTALCRIME_rate log_Prisoners if tin(, 2008), arima(2,1,1) nolog 

predict double crime_new2 if tin(2002,), y
label var crime_new2 "static forecast" 

predict double crime_new3 if tin(2002,), dynamic(y(2008)) y 
label var crime_new3 "dynamic forecast" 

tw (tsline crime_new2 crime_new3 if !mi(crime_new2)) /// 
(scatter log_TOTALCRIME_rate year if !mi(crime_new2), c(i)), scheme(s2mono) /// 
ti("Static and dynamic ex ante forecasts of crime rate-ARIMA(2,1,1)model") /// 
 t2("Forecast horizon: 2009-2014") legend(rows(1))

 
 ** univariate forecast***
arima log_TOTALCRIME_rate if tin(, 2008), arima(2,1,2) nolog 

predict double crime_new2 if tin(2002,), y
label var crime_new2 "static forecast" 

predict double crime_new3 if tin(2002,), dynamic(y(2008)) y 
label var crime_new3 "dynamic forecast" 

tw (tsline crime_new2 crime_new3 if !mi(crime_new2)) /// 
(scatter log_TOTALCRIME_rate year if !mi(crime_new2), c(i)), scheme(s2mono) /// 
ti("Static and dynamic ex ante forecasts of crime rate-ARIMA(2,1,2)") /// 
 t2("Forecast horizon: 2009-2014") legend(rows(1))

 
 
 arima log_TOTALCRIME_rate if tin(, 2008), arima(2,1,2) nolog 
 
 predict double crime_new2 , y
label var crime_new2 "static forecast" 
 
 predict double crime_new3, dynamic(y(2009)) y 
label var crime_new3 "dynamic forecast"
 
 list year  crime_new3 if tin(2009, 2014)
 
 tsline log_TOTALCRIME_rate log_TOTALCRIME_rate if tin(2009, 2014)
 
 
 
 
** fitting seasonal arima**

arima log_TOTALCRIME_rate,  sarima(2,1,1,12) nolog 


arima log_TOTALCRIME_rate,  sarima(2,1,1,12) 



 ** regression approach for forecasting***
reg log_TOTALCRIME_rate l.log_TOTALCRIME_rate l.log_Prisoners,r
estimates store linear_1

forecast linear_1


predict double crime_new2 if tin(2002,), xb
label var crime_new2 "static forecast" 

predict double crime_new3 if tin(2002,), dynamic(y(2008)) y 
label var crime_new3 "dynamic forecast" 


** or**
predict crime_new, y dynamic (y(2015))

tsline log_TOTALCRIME_rate crime_new, ti("ARIMA(2,1,2) model of Crime Rate")


tw (tsline resd_1, yaxis(2)) (tsline crime_new), ti("ARIMA(2,1,2) model of Crime Rate")

** vec model***
vec log_TOTALCRIME_rate  log_GDP



**** impulse response between GDP and Crime rate***

var diff_totalcrime diff_GDP, lags(1/4) dfk small
vargranger  


varlmar, mlag(4)
varstable,  graph
varnorm

irf creat IRF, step(20) set (myirf) replace
irf graph oirf, impulse(diff_totalcrime) response(diff_GDP) yline(0, lcolor(black)) xlabel(0(4)20) byopts(yrescale)
irf graph oirf, impulse(diff_GDP) response(diff_totalcrime) yline(0, lcolor(black)) xlabel(0(4)20) byopts(yrescale)


*** OR***
irf creat IRF, step(20) set (myirf) replace
irf graph oirf, irf (impulse) impulse(diff_totalcrime)  response(diff_GDP) yline(0, lcolor(black)) xlabel(0(4)20) byopts(yrescale)
irf graph oirf, irf (impulse) impulse(diff_GDP)  response(diff_totalcrime) yline(0, lcolor(black)) xlabel(0(4)20) byopts(yrescale)

***OR**

irf creat IRF, set(irfs) step(20) replace
irf graph oirf, impulse(diff_totalcrime) response(diff_GDP)
irf graph oirf, impulse(diff_GDP) response(diff_totalcrime)


** using varbasic**
varbasic diff_totalcrime diff_GDP, lags(1/4)  irf step(20) 




**** impulse response between incarceration and Crime rate***

** estimating forecats error variances***

var diff_totalcrime diff_prisoners, lags(1/4) dfk small

irf set results4
irf create ordera, step (20)
irf create orderb, order( diff_totalcrime diff_prisoners) step(20)

irf table oirf fevd, impulse(diff_totalcrime) response (diff_prisoners) noci std
irf table oirf fevd, impulse(diff_prisoners) response (diff_totalcrime) noci std

OR

irf ctable (ordera diff_totalcrime diff_prisoners oirf fevd) (orderb diff_totalcrime diff_prisoners oirf fevd), noci std

** estimating forecats error variance decomposition***

irf ctable (ordera diff_prisoners  diff_totalcrime fevd) (orderb diff_prisoners  diff_totalcrime fevd), individual

irf ctable (ordera diff_totalcrime diff_prisoners fevd) (orderb diff_totalcrime diff_prisoners fevd)

irf ctable (ordera diff_prisoners  diff_totalcrime fevd) (orderb diff_prisoners  diff_totalcrime fevd)





var diff_totalcrime diff_prisoners, lags(1/4) dfk small
vargranger  
varlmar  
varnorm 



varlmar, mlag(4)
varstable,  graph
varnorm

fcast compute  

irf creat IRF, set(irfs) step(20) replace
irf graph oirf, impulse(diff_totalcrime) response(diff_prisoners)
irf graph oirf, impulse(diff_prisoners) response(diff_totalcrime)





var diff_violent diff_prisoners, lags(1/4) dfk small
vargranger  


varlmar, mlag(4)
varstable,  graph
varnorm

irf creat IRF, set(irfs) step(20) replace
irf graph oirf, impulse(diff_violent) response(diff_prisoners)
irf graph oirf, impulse(diff_prisoners) response(diff_violent)


var diff_property diff_prisoners, lags(1/4) dfk small
vargranger  


varlmar, mlag(4)
varstable,  graph
varnorm

irf creat IRF, set(irfs) step(20) replace
irf graph oirf, impulse(diff_property) response(diff_prisoners)
irf graph oirf, impulse(diff_prisoners) response(diff_property)





** using varbasic**
varbasic diff_totalcrime diff_prisoners, lags(1/4)  irf step(20) 


** forecasting**
  
var diff_totalcrime diff_prisoners, lags(1/4)
fcast compute m2, step(6) /* six years forecast*/
fcast graph m2diff_totalcrime m2diff_prisoners, observed


 
var log_TOTALCRIME_rate log_Prisoners, lags(1/4)
fcast compute m2, step(6) /* six years forecast*/
fcast graph m2log_TOTALCRIME_rate m2log_Prisoners, observed





















