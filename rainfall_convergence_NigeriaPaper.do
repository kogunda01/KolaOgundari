 use "C:\Users\ogund\Downloads\Bola\Annual_data_Rainfall.dta" , replace

xtset state_new year

tab state_new

tab region_new

///Panel Unit Root Test///

///first generation test///


///  Levin-Lin-Chu test from xtunitroot test///

xtunitroot llc lograinfall, lags(1)
xtunitroot llc diffrain, lags(1)

///  Harris-Tzavalis test from xtunitroot test///

xtunitroot ht lograinfall
xtunitroot ht diffrain

///  Breitung test from xtunitroot test///

xtunitroot breitung lograinfall, lags(1)
xtunitroot breitung diffrain, lags(1)

///  Im-Pesaran-Shin test from xtunitroot test///

xtunitroot ips lograinfall, lags(1)
xtunitroot ips diffrain, lags(1)

///   Fisher-type tests  from xtunitroot test///

xtunitroot fisher lograinfall, dfuller lags(1)
xtunitroot fisher diffrain, dfuller lags(1)

/// OR///

xtunitroot fisher lograinfall, pperron lags(1)
xtunitroot fisher diffrain, pperron lags(1)

///Hadri Lagrange multiplier stationarity test from xtunitroot test///  

xtunitroot hadri lograinfall
xtunitroot hadri diffrain


/// estimating volatility ///

gen Volatility= (((lograinfall- lag_rainfall)^2/ lag_rainfall) ^0.5)*100

volatility_1 =volatility/100

// unit root test///
xtreg Volatility year ,fe
estimates store fixed

xtreg Volatility year ,re
estimates store random

estimates table fixed random, star stats(N r2 r2_a)
hausman fixed random

// or ///
xtreg volatility_1 year ,fe
estimates store fixed

xtreg volatility_1 year ,re
estimates store random

estimates table fixed random, star stats(N r2 r2_a)
hausman fixed random




///cross-section dependence after xtreg///

//Pesearan test//

xtreg volatility_1 year, fe

xtcsd, pesaran abs



xtreg volatility_1 year,fe
xtcd2



///OR///

// Wooldridge’s test of serial correlation//

xtserial  volatility_1 year  , output



**gamma convergence***

egen ssd_rain = sd(lograinfall ), by (year)

egen sd_rain = sd(lograinfall ), by (state_new)

qbys state_new year: egen meanrain = mean( lograinfall )

gen CV_rain= ssd_rain/ meanrain


xtgls volatility_1 year , panels(correlated) 

xtreg volatility_1 year, fe

reg volatility_1 year,r


xtgls volatility_1 year, panels(correlated) corr(ar1)

xtgls volatility_1 year i.region_new, panels(correlated) corr(ar1)


xtgls ssd_rain year i.region_new, panels(correlated) corr(ar1)

xtgls ssd_rain year , panels(correlated) corr(ar1)

xtsktest volatility_1 year, reps(500) seed(123)







xtreg CV_rain year, fe

reg CV_rain year, r

xtgls CV_rain year,corr(ar1)

xtgls CV_rain year, panels(correlated)

xtgls CV_rain year, panels(hetero) corr(ar1)


// kdensity///

kdensity CV_rain if (region_new ==1), plot(kdensity CV_rain if (region_new ==2)||kdensity CV_rain if (region_new ==3)||kdensity CV_rain if (region_new ==4)||kdensity CV_rain if (region_new ==5) ||kdensity CV_rain if (region_new ==6)) legend(ring(0) pos(2)label(1 "NorthCentral") label(2 "NorthEast") label(3 "NorthWest") label(4 "SouthEast") label(5 "SouthSouth") label(6 "SouthWest"))                                      

histogram CV_rain,  freq  by ( region_new)

graph bar (mean) CV_rain , over( region_new )

xtline rainfall


xtline CV_rain


binscatter CV_rain year, line(qfit) ytitle(CV_Rain) xtitle(Year)



///twoway 
twoway (scatter CV_rain year , msymbol(Oh))  (lfit CV_rain year), by( region_new)

twoway (scatter CV_rain year , msymbol(Oh))  (lfit CV_rain year)



