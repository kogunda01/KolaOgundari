use   "C:\Users\ogund\OneDrive\Documents\Ongoingworks\crime_incarceration\Panel\GDP_CRIME_Panel.dta", replace

sum

#delimit ;
label define state1 1 "Alabama"  2 "Alaska" 3 "Arizona" 4 "Arkansas" 5 "California"  6 "Colorado"  7 "Connecticut" 8 "Delaware" 
   9 "District of Columbia" 10 "Florida" 11 "Georgia" 12 "Hawaii" 13 "Idaho" 14" Illinois" 15 "Indiana" 16 "Iowa" 17 "Kansas" 
   18 "Kentucky" 19 "Louisiana" 20 "Maine" 21 "Maryland" 22 "Massachusetts" 23 "Michigan" 24 "Minnesota" 25 "Mississippi" 26 "Missouri" 
   27 "Montana"  28 "Nebraska" 29 "Nevada" 30 "New Hampshire" 31 "New Jersey" 32 "New Mexico" 33 "New York" 34 "North Carolina" 35 "North Dakota" 36 "Ohio"
   37 "Oklahoma" 38 "Oregon" 39 "Pennsylvania" 40 "Rhode Island" 41"South Carolina" 42 "South Dakota" 43 "Tennessee" 44 "Texas" 45 "Utah" 46 "Vermont"
   47 "Virginia" 48 "Washington" 49 "West Virginia" 50 "Wisconsin" 51 "Wyoming";
#delimit cr
   label values state_id state1
   
tsset  state_id year

gen D_Northeast=.

replace  D_Northeast =1 if new_stateID==30 /*New Hampshire*/
replace  D_Northeast =1 if new_stateID==20 /*Maine*/
replace  D_Northeast =1 if new_stateID==33 /*New Hampshire*/
replace  D_Northeast =1 if new_stateID==46 /*New Hampshire*/
replace  D_Northeast =1 if new_stateID==39 /*New Hampshire*/
replace  D_Northeast =1 if new_stateID==9  /*District of Columbia*/
replace  D_Northeast =1 if new_stateID==21 /*Maryland*/
replace  D_Northeast =1 if new_stateID==8  /*Delaware*/
replace  D_Northeast =1 if new_stateID==31 /*New Jersey*/
replace  D_Northeast =1 if new_stateID==7  /*Connecticut*/
replace  D_Northeast =1 if new_stateID==40 /*Rhode Island*/
replace  D_Northeast =1 if new_stateID==22 /*Massachusetts*/

replace  D_Northeast =0 if D_Northeast ==.

tab D_Northeast


gen D_South=.

replace  D_South= 1 if new_stateID== 44 /* Texas*/
replace  D_South= 1 if new_stateID== 37
replace  D_South= 1 if new_stateID== 4
replace  D_South= 1 if new_stateID== 19
replace  D_South= 1 if new_stateID== 25
replace  D_South= 1 if new_stateID== 1
replace  D_South= 1 if new_stateID== 43
replace  D_South= 1 if new_stateID== 18
replace  D_South= 1 if new_stateID== 11
replace  D_South= 1 if new_stateID== 10
replace  D_South= 1 if new_stateID== 41
replace  D_South= 1 if new_stateID== 34
replace  D_South= 1 if new_stateID== 47
replace  D_South= 1 if new_stateID== 49

replace  D_South =0 if D_South ==.

tab D_South

gen D_MidWest=.

replace  D_MidWest= 1 if new_stateID== 35 /* North Dakota*/
replace  D_MidWest= 1 if new_stateID== 42 /* South Dakota*/
replace  D_MidWest= 1 if new_stateID== 24
replace  D_MidWest= 1 if new_stateID== 50
replace  D_MidWest= 1 if new_stateID== 23
replace  D_MidWest= 1 if new_stateID== 15
replace  D_MidWest= 1 if new_stateID== 28
replace  D_MidWest= 1 if new_stateID== 17
replace  D_MidWest= 1 if new_stateID== 26
replace  D_MidWest= 1 if new_stateID== 14
replace  D_MidWest= 1 if new_stateID== 16
replace  D_MidWest= 1 if new_stateID== 36

replace  D_MidWest =0 if D_MidWest ==.

tab D_MidWest



gen D_West=.

replace  D_West= 1 if new_stateID== 48 /* Washington*/
replace  D_West= 1 if new_stateID== 38 /* Oregon*/
replace  D_West= 1 if new_stateID== 5
replace  D_West= 1 if new_stateID== 3
replace  D_West= 1 if new_stateID== 32
replace  D_West= 1 if new_stateID== 6
replace  D_West= 1 if new_stateID== 45
replace  D_West= 1 if new_stateID== 29
replace  D_West= 1 if new_stateID== 13
replace  D_West= 1 if new_stateID== 27
replace  D_West= 1 if new_stateID== 51
replace  D_West= 1 if new_stateID== 2
replace  D_West= 1 if new_stateID== 12

replace  D_West =0 if D_West ==.

tab D_West


replace D_West= 4 if D_West==1
replace D_MidWest= 3 if D_MidWest==1
replace D_South= 2 if D_South==1

gen REGIONS= D_Northeast+ D_South+ D_MidWest+D_West


tab REGIONS

label define Regions 1 "Northeast"  2 "South" 3 "MidWest" 4 "West"
label values REGIONS Regions



replace countrycode=state_id if state_id==""
   
   
   gen countrycode=state_id
   
graph bar (mean) total_crime_rate,  over( state_id )   
   
   
   
   
*** unit root test**
xtunitroot llc logGDP, lags(1)
xtunitroot llc logCRIME, lags(1)
xtunitroot llc logViolent, lags(1)
xtunitroot llc logProperty, lags(1)

xtunitroot ht logGDP
xtunitroot ht logCRIME
xtunitroot ht logViolent
xtunitroot ht logProperty

xtunitroot breitung logGDP, lags(1)
xtunitroot breitung logCRIME, lags(1)
xtunitroot breitung logViolent, lags(1)
xtunitroot breitung logProperty, lags(1)

xtunitroot ips logGDP, lags(1)
xtunitroot ips logCRIME, lags(1)
xtunitroot ips logViolent, lags(1)
xtunitroot ips logProperty, lags(1)

xtunitroot fisher logGDP, dfuller lags(1)
xtunitroot fisher logCRIME, dfuller lags(1)
xtunitroot fisher logViolent, dfuller lags(1)
xtunitroot fisher logProperty, dfuller lags(1)

xtunitroot hadri logGDP
xtunitroot hadri logCRIME
xtunitroot hadri logViolent
xtunitroot hadri logProperty



xtunitroot llc d.logGDP, lags(1)
xtunitroot llc d.logCRIME, lags(1)
xtunitroot llc d.logViolent, lags(1)
xtunitroot llc d.logProperty, lags(1)

xtunitroot ht d.logGDP
xtunitroot ht d.logCRIME
xtunitroot ht d.logViolent
xtunitroot ht d.logProperty

xtunitroot breitung d.logGDP, lags(1)
xtunitroot breitung d.logCRIME, lags(1)
xtunitroot breitung d.logViolent, lags(1)
xtunitroot breitung d.logProperty, lags(1)

xtunitroot ips d.logGDP, lags(1)
xtunitroot ips d.logCRIME, lags(1)
xtunitroot ips d.logViolent, lags(1)
xtunitroot ips d.logProperty, lags(1)

xtunitroot fisher d.logGDP, dfuller lags(1)
xtunitroot fisher d.logCRIME, dfuller lags(1)
xtunitroot fisher d.logViolent, dfuller lags(1)
xtunitroot fisher d.logProperty, dfuller lags(1)

xtunitroot hadri d.logGDP
xtunitroot hadri d.logCRIME
xtunitroot hadri d.logViolent
xtunitroot hadri d.logProperty



** estimating panel VAR models***

pvar  logCRIME logGDP, fd instlags(1/3) gmmstyle lags(2)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logCRIME)  step(20)  oirf mc(200)
pvarirf , impulse(logCRIME)  response(logGDP)  step(20)  oirf mc(200)


pvar  logCRIME logGDP, fd instlags(1/4) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logCRIME)  step(20)  oirf mc(200)
pvarirf , impulse(logCRIME)  response(logGDP)  step(20)  oirf mc(200)


pvar  logCRIME logGDP, fd instlags(1/5) gmmstyle lags(4)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logCRIME)  step(20)  oirf mc(200)  byoption(yrescale)
pvarirf , impulse(logCRIME)  response(logGDP)  step(20)  oirf mc(200)  byoption(yrescale)

pvar  logCRIME logGDP, fd instlags(1/6) gmmstyle lags(5)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logCRIME)  step(20)  oirf mc(200)
pvarirf , impulse(logCRIME)  response(logGDP)  step(20)  oirf mc(200)



** crime & GDP***

pvarsoc logCRIME logGDP, maxlag(4) pvaropts(instl(1/5))

pvar  logCRIME logGDP, fd instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logCRIME)  step(20)  oirf mc(200)
pvarirf , impulse(logCRIME)  response(logGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(logGDP)  response(logCRIME)  step(20)
pvarfevd, mc(200)impulse(logCRIME)  response(logGDP)  step(20)


** violent crime and GDP***

pvarsoc logViolent logGDP, maxlag(4) pvaropts(instl(1/5))


pvar  logViolent logGDP, fd instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logViolent)  step(20)  oirf mc(200)
pvarirf , impulse(logViolent)  response(logGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(logGDP)  response(logViolent)  step(20)
pvarfevd, mc(200)impulse(logViolent) response(logGDP)  step(20)


** property crime and GDP***

pvarsoc logProperty logGDP, maxlag(4) pvaropts(instl(1/5))


pvar  logProperty logGDP, fd instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(logGDP)  response(logProperty)  step(20)  oirf mc(200)
pvarirf , impulse(logProperty)  response(logGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(logGDP)  response(logProperty)  step(20)
pvarfevd, mc(200)impulse(logProperty)  response(logGDP)  step(20)


 
 
 
 
 
 ** 5 years average estimate***
 
 

** model selection**


pvarsoc dlogCRIME dlogGDP, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogViolent dlogGDP, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogProperty dlogGDP, maxlag(4) pvaropts(instl(1/5))


pvarsoc dlogCRIME dlogGDP if REGIONS==1, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogCRIME dlogGDP if REGIONS==2, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogCRIME dlogGDP if REGIONS==3, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogCRIME dlogGDP if REGIONS==4, maxlag(4) pvaropts(instl(1/5))


pvarsoc dlogViolent dlogGDP if REGIONS==1, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogViolent dlogGDP if REGIONS==2, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogViolent dlogGDP if REGIONS==3, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogViolent dlogGDP if REGIONS==4, maxlag(4) pvaropts(instl(1/5))

 
pvarsoc dlogProperty dlogGDP if REGIONS==1, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogProperty dlogGDP if REGIONS==2, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogProperty dlogGDP if REGIONS==3, maxlag(4) pvaropts(instl(1/5))
pvarsoc dlogProperty dlogGDP if REGIONS==4, maxlag(4) pvaropts(instl(1/5))

  
 
** crime & GDP***

pvar  dlogCRIME dlogGDP, instlags(1/4) gmmstyle lags(1) overid
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogCRIME)  step(20)  oirf mc(200)
pvarirf , impulse(dlogCRIME)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogCRIME)  step(10)
pvarfevd, mc(200)impulse(dlogCRIME)  response(dlogGDP)  step(10)

** northeast**
pvar  dlogCRIME dlogGDP if REGIONS==1, instlags(1/4) gmmstyle lags(1)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogCRIME)  step(20)  oirf mc(200) title("Northeast")
pvarirf , impulse(dlogCRIME)  response(dlogGDP)  step(20)  oirf mc(200) title("Northeast")
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogCRIME)  step(10)
pvarfevd, mc(200)impulse(dlogCRIME)  response(dlogGDP)  step(10)

**South**
pvar  dlogCRIME dlogGDP if REGIONS==2, instlags(1/4) gmmstyle lags(1)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogCRIME)  step(20)  oirf mc(200) title("South")
pvarirf , impulse(dlogCRIME)  response(dlogGDP)  step(20)  oirf mc(200) title("South")
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogCRIME)  step(10)
pvarfevd, mc(200)impulse(dlogCRIME)  response(dlogGDP)  step(10)

**midwest**
 
pvar  dlogCRIME dlogGDP if REGIONS==3, instlags(1/4) gmmstyle lags(1)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogCRIME)  step(20)  oirf mc(200) title("Midwest")
pvarirf , impulse(dlogCRIME)  response(dlogGDP)  step(20)  oirf mc(200) title("Midwest")
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogCRIME)  step(10)
pvarfevd, mc(200)impulse(dlogCRIME)  response(dlogGDP)  step(10)

** west***
pvar  dlogCRIME dlogGDP if REGIONS==4, instlags(1/4) gmmstyle lags(1)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogCRIME)  step(20)  oirf mc(200) title("West")
pvarirf , impulse(dlogCRIME)  response(dlogGDP)  step(20)  oirf mc(200) title("West")
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogCRIME)  step(10)
pvarfevd, mc(200)impulse(dlogCRIME)  response(dlogGDP)  step(10)





** violent crime and GDP***

pvar  dlogViolent dlogGDP, instlags(1/4) gmmstyle lags(1) overid
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogViolent)  step(20)  oirf mc(200)
pvarirf , impulse(dlogViolent)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogViolent)  step(10)
pvarfevd, mc(200)impulse(dlogViolent)  response(dlogGDP)  step(10)

** northeast**

pvar  dlogViolent dlogGDP if REGIONS==1, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogViolent)  step(20)  oirf mc(200)
pvarirf , impulse(dlogViolent)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogViolent)  step(12)
pvarfevd, mc(200)impulse(dlogViolent)  response(dlogGDP)  step(12)

**South**

pvar  dlogViolent dlogGDP if REGIONS==2, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogViolent)  step(20)  oirf mc(200)
pvarirf , impulse(dlogViolent)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogViolent)  step(12)
pvarfevd, mc(200)impulse(dlogViolent)  response(dlogGDP)  step(12)

**midwest**
 
pvar  dlogViolent dlogGDP if REGIONS==3, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogViolent)  step(20)  oirf mc(200)
pvarirf , impulse(dlogViolent)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogViolent)  step(12)
pvarfevd, mc(200)impulse(dlogViolent)  response(dlogGDP)  step(12)

** west***
pvar  dlogViolent dlogGDP if REGIONS==4, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogViolent)  step(20)  oirf mc(200)
pvarirf , impulse(dlogViolent)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogViolent)  step(12)
pvarfevd, mc(200)impulse(dlogViolent)  response(dlogGDP)  step(12)


** property crime and GDP***

pvar  dlogProperty dlogGDP, instlags(1/4) gmmstyle lags(1) vce(robust) overid
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogProperty)  step(20)  oirf mc(200)
pvarirf , impulse(dlogProperty)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogProperty)  step(10)
pvarfevd, mc(200)impulse(dlogProperty)  response(dlogGDP)  step(10)

 

 ** northeast**

pvar  dlogProperty dlogGDP if REGIdONS==1, instlags(1/5) gmmstyle lags(1)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogProperty)  step(20)  oirf mc(200)
pvarirf , impulse(dlogProperty)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogProperty)  step(12)
pvarfevd, mc(200)impulse(dlogProperty)  response(dlogGDP)  step(12)


 
**South**

pvar  dlogProperty dlogGDP if REGIONS==2, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogProperty)  step(20)  oirf mc(200)
pvarirf , impulse(dlogProperty)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogProperty)  step(12)
pvarfevd, mc(200)impulse(dlogProperty)  response(dlogGDP)  step(12)


 
**midwest**
 
pvar  dlogProperty dlogGDP if REGIONS==3, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogProperty)  step(20)  oirf mc(200)
pvarirf , impulse(dlogProperty)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogProperty)  step(12)
pvarfevd, mc(200)impulse(dlogProperty)  response(dlogGDP)  step(12)


 
** west***
pvar  dlogProperty dlogGDP if REGIONS==4, instlags(1/5) gmmstyle lags(3)
pvargranger
pvarstable,  graph
pvarirf , impulse(dlogGDP)  response(dlogProperty)  step(20)  oirf mc(200)
pvarirf , impulse(dlogProperty)  response(dlogGDP)  step(20)  oirf mc(200)
pvarfevd, mc(200)impulse(dlogGDP)  response(dlogProperty)  step(12)
pvarfevd, mc(200)impulse(dlogProperty)  response(dlogGDP)  step(12)


 
 
 
 
** graphs**

histogram total_crime_rate, freq normal

histogram gdp, freq normal



histogram total_crime_rate,  freq  by ( REGIONS)

histogram violent_crime_rate ,  freq normal

histogram property_crime_rate,  freq  normal

graph bar (mean) total_crime_rate , over( REGIONS )

graph bar (mean) violent_crime_rate , over( REGIONS )

graph bar (mean) property_crime_rate, over( REGIONS )


** violine plot**

vioplot total_crime_rate , title("CRIME RATES") 


vioplot total_crime_rate , over( REGIONS )title("CRIME RATE") 

vioplot violent_crime_rate , title("VIOLENT CRIME RATES") 

vioplot property_crime_rate , title("PROPERTY CRIME RATES") 


** GDP**

histogram gdp,  freq  by ( REGIONS)

vioplot gdp , over( REGIONS )title("GDP") 



** kednsity***



twoway kdensity total_crime_rate || kdensity gdp

twoway kdensity logCRIME || kdensity logGDP 

twoway kdensity logCRIME || kdensity logViolent || kdensity logProperty 


kdensity logCRIME if (REGIONS==1), plot(kdensity logCRIME if (REGIONS==2)||kdensity logCRIME if (REGIONS==3)||kdensity logCRIME if (REGIONS==4)) legend(ring(0) pos(2)label(1 "Northeast") label(2 "South") label(3 "Midwest") label(4 "West") )     

kdensity logViolent if (REGIONS==1), plot(kdensity logViolent if (REGIONS==2)||kdensity logViolent if (REGIONS==3)||kdensity logViolent if (REGIONS==4)) legend(ring(0) pos(2)label(1 "Northeast") label(2 "South") label(3 "Midwest") label(4 "West") )      

kdensity logProperty if (REGIONS==1), plot(kdensity logProperty if (REGIONS==2)||kdensity logProperty if (REGIONS==3)||kdensity logProperty if (REGIONS==4)) legend(ring(0) pos(2)label(1 "Northeast") label(2 "South") label(3 "Midwest") label(4 "West") )      



kdensity logGDP if (REGIONS==1), plot(kdensity logGDP if (REGIONS==2)||kdensity logGDP if (REGIONS==3)||kdensity logGDP if (REGIONS==4)) legend(ring(0) pos(2)label(1 "Northeast") label(2 "South") label(3 "Midwest") label(4 "West") )      



** panel plots**

xtline logCRIME


binscatter logCRIME logGDP, line(qfit) ytitle(ALL CRIME) xtitle(GDP)



twoway scatter logCRIME logGDP, mcolor(*.6) ||
lfit logCRIME logGDP ||
lowess logCRIME logGDP


twoway (scatter logCRIME logGDP) (lfit logCRIME logGDP) 


xtpmg d.logCRIME d.logGDP, lr(l.logCRIME logGDP) ec(ec) replace dfe cluster(state_id)         

xtpmg d.logGDP d.logCRIME, lr(l.logGDP logCRIME) ec(ec) replace dfe cluster(state_id)  



xtpmg d.logCRIME d.logGDP, lr(l.logCRIME logGDP) ec(ec) replace pmg        
xtpmg d.logGDP d.logCRIME, lr(l.logGDP logCRIME) ec(ec) replace pmg  full      
       
xtpmg d.logCRIME d.logGDP, lr(l.logCRIME logGDP) ec(ec) replace mg       
xtpmg d.logGDP d.logCRIME, lr(l.logGDP logCRIME) ec(ec) replace mg 


 xtmg logCRIME logGDP, trend  robust full
 xtmg logGDP logCRIME, trend  robust  full
   
   
 xtmg logCRIME logGDP,  robust cce full 
 xtmg logGDP logCRIME,  robust cce full
 
 
 xtmg logCRIME logGDP, trend  cce res(cce_res) robust
 
 
 ** graphs***
 
 
*** plots***

twoway (scatter logCRIME logGDP) (lfit logCRIME  logGDP), by (state)
twoway (scatter logCRIME logGDP) (lfit logCRIME  logGDP) 
twoway (scatter logGDP logCRIME) (lfit logGDP logCRIME)




graph matrix logCRIME logGDP, maxes(ylab(#4, grid) xlab(#4, grid))


graph matrix logCRIME logGDP, by(state) xsize(5)


graph matrix logCRIME logGDP , half



collapse (mean) total_crime_rate gdp, by(state)
br
twoway (scatter total_crime_rate gdp, sort mlabel (state))
clear


collapse (mean) logCRIME logGDP, by(state)
br
twoway (scatter logCRIME logGDP, sort mlabel (state))
clear


collapse (mean) log_TFP LogGDP, by(country)
br
twoway (scatter log_TFP LogGDP, sort mlabel (country))
clear

 
 ** club convergence***
 
pfilter logCRIME , method(hp) trend(logCRIME2) smooth(400)
logtreg logCRIME2, kq(0.333)
psecta logCRIME2, name(state) kq(0.333) gen(club)


 
pfilter logViolent , method(hp) trend(logViolent2) smooth(400)
logtreg logViolent2, kq(0.333)
psecta logViolent2, name(state) kq(0.333) gen(club2)



pfilter logProperty, method(hp) trend(logProperty2) smooth(400)
logtreg logProperty2, kq(0.333)
psecta logProperty2, name(state) kq(0.333) gen(club3)


** beta convergence***

xtreg diffCrime lagCrime,fe

xtreg diffviolent lagViolent ,fe

xtreg diffproperty lagProperty ,fe




egen SDCRIME=sd(logCRIME), by ( year)
egen SDViolent=sd(logViolent), by (year)
egen SDProperty=sd(logProperty), by (year)

egen varCRIME =var(logCRIME), by (year)




xtreg SDCRIME year,fe
xtreg SDViolent year,fe
xtreg SDProperty year,fe



