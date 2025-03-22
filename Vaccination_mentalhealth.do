

** economic activities***
** work onsite**
probit workonsite recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st  [pw=pweight]

probit workonsite recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==0  [pw=pweight] //white
probit workonsite recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==1  [pw=pweight] //black
probit workonsite recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==2  [pw=pweight] //Asian
probit workonsite recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==3  [pw=pweight] //Other_races
probit workonsite recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rhispanic==1  [pw=pweight] //Hispanic


**telework***
probit telework recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st  [pw=pweight]

probit telework recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==0  [pw=pweight] //white
probit telework recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==1  [pw=pweight] //black
probit telework recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==2  [pw=pweight] //Asian
probit telework recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==3  [pw=pweight] //Other_races
probit telework recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rhispanic==1  [pw=pweight] //Hispanic

***in store shopping***
probit inshopping recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st  [pw=pweight]

probit inshopping recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==0  [pw=pweight] //white
probit inshopping recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==1  [pw=pweight] //black
probit inshopping recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==2  [pw=pweight] //Asian
probit inshopping recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==3  [pw=pweight] //Other_races
probit inshopping recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rhispanic==1  [pw=pweight] //Hispanic

** work loss**
probit wrklossrv recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if wrklossrv !=-99 [pw=pweight]

probit wrklossrv recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==0  [pw=pweight] //white
probit wrklossrv recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==1  [pw=pweight] //black
probit wrklossrv recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==2  [pw=pweight] //Asian
probit wrklossrv recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==3  [pw=pweight] //Other_races
probit wrklossrv recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rhispanic==1  [pw=pweight] //Hispanic


*** food sufficiency level***
ologit curfoodsuf recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st  [pw=pweight]

ologit curfoodsuf recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if rrace==0  [pw=pweight] //white
ologit curfoodsuf recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if rrace==1  [pw=pweight] //black
ologit curfoodsuf recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==2  [pw=pweight] //Asian
ologit curfoodsuf recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rrace==3  [pw=pweight] //Other_races
ologit curfoodsuf recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  rhispanic==1  [pw=pweight] //Hispanic


*** mental health services in the last seven days***
probit mh_svcs recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 [pw=pweight]

probit mh_svcs recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 & rrace==0  [pw=pweight] //white
probit mh_svcs recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 & rrace==1  [pw=pweight] //black
probit mh_svcs recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 & rrace==2  [pw=pweight] //Asian
probit mh_svcs recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 & rrace==3  [pw=pweight] //Other_races
probit mh_svcs recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st if  down !=1 & rhispanic==1  [pw=pweight] //Hispanic


** treatment effect****


probit recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE  [pw=pweight]
predict double ps if e(sample)
tabstat ps, by(recvdvacc) stats(N mean median min max)


teffects aipw (workonsite rhispanic rrace eeduc ms egenid_birth income AGE est_st trend, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit)

tebalance summarize

mat M = r(table)
coefplot matrix(M[,1]), noci xline(0) xline(-0.25 0.25, lpattern(dash)) title("Standardized differences")
graph export stdif.png, replace
coefplot matrix(M[,3]), noci xline(1) title("Variance ratios")
graph export var.png, replace


*******************************************************************************************************************


teffects aipw (workonsite rhispanic rrace eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit), pstolerance(1e-50)
teffects overlap, ptl(1)
graph export overl.png, replace

tebalance overid, nolog


*******************************************************************************************************************

teffects aipw (telework rhispanic rrace eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend , probit)

tebalance summarize

mat M = r(table)
coefplot matrix(M[,1]), noci xline(0) xline(-0.25 0.25, lpattern(dash)) title("Standardized differences")
graph export stdif.png, replace
coefplot matrix(M[,3]), noci xline(1) title("Variance ratios")
graph export var.png, replace


teffects aipw (inshopping rhispanic rrace eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit)

teffects aipw (wrklossrv rhispanic rrace eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit)

teffects aipw (mh_svcs rhispanic rrace eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit)

teffects aipw (curfoodsuf rhispanic rrace eeduc ms egenid_birth income AGE est_st, poisson ) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend, probit)


** by race/ethnicity 

probit recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st [pw=pweight]

teffects aipw (workonsite eeduc ms egenid_birth income AGE est_st, probit ) (recvdvacc  eeduc ms egenid_birth income AGE trend, probit)

tebalance summarize

mat M = r(table)
coefplot matrix(M[,1]), noci xline(0) xline(-0.25 0.25, lpattern(dash)) title("Standardized differences")
graph export stdif.png, replace
coefplot matrix(M[,3]), noci xline(1) title("Variance ratios")
graph export var.png, replace


teffects aipw (telework  eeduc ms egenid_birth income AGE, probit ) (recvdvacc  eeduc ms egenid_birth income AGE trend est_st, probit)

teffects aipw (inshopping  eeduc ms egenid_birth income AGE, probit ) (recvdvacc  eeduc ms egenid_birth income AGE trend est_st, probit)

teffects aipw (wrklossrv  eeduc ms egenid_birth income AGE, probit ) (recvdvacc  eeduc ms egenid_birth income AGE trend est_st, probit)

teffects aipw (mh_svcs  eeduc ms egenid_birth income AGE, probit ) (recvdvacc  eeduc ms egenid_birth income AGE trend est_st, probit)

teffects aipw (curfoodsuf  eeduc ms egenid_birth income AGE, poisson ) (recvdvacc  eeduc ms egenid_birth income AGE trend est_st, probit)




**PSM***
** pooled estimated***
psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) com  // nearest neighbor-NN 


psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) noreplacement // nearest neighbor-NN 

psgraph



** race/ethnicity**
psmatch2  recvdvacc i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) com  // nearest neighbor-NN

psgraph

tebalance summarize
tebalance overid,nolog
tebalance summarize, baseline









***************************************
psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) neighbor (1) caliper (0.04) com  //  caliper

psgraph

psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) kernel k(tricube) com bwidth (0.05) // kernel 

psgraph

psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) radius caliper (0.05) com // radius caliper

psgraph

psmatch2  recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st,  out(workonsite telework inshopping wrklossrv mh_svcs curfoodsuf) cal(0.10) com // Mahalanobis matching with caliper

psgraph


pstest i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE, treated (recvdvacc ) both


*** NNM**



teffects nnmatch (workonsite i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st) (recvdvacc)


teffects psmatch  (workonsite) (recvdvacc i.rhispanic i.rrace i.eeduc i.ms i.egenid_birth i.income AGE trend i.est_st), nn (1) 




************************************
*************************************

label define getvacrv9 0"vaccinated" 1"Definately get a vaccine" 2"Probably get a vaccine" 3"Unsure about getting a vaccine"  4" probably not get a vaccine" 5" Definately not get a vaccine"   
label values getvacrv getvacrv9
tab getvacrv




