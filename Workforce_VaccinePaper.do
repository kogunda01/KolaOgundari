use "C:\Users\ogund\OneDrive\Desktop\new_merged.dta" 
describe
tab hrmonth
tab hryear4
tab hrmonth hryear4
tab pemjnum
tab pehrusl1
drop if pehrusl1==-4
drop if pehrusl1==-1
tab pehrusl1
save "C:\Users\ogund\OneDrive\Desktop\new_merged.dta", replace
tab pehrusl1 if hryear4==2021
tab pehrusl1 if hryear4==2021
tab pehrusl1 if hryear4==2020
tab pemjnum

drop if hrmonth<3 & hryear4==2020

tab hrmonth hryear4


gen VACCINE=1 if hrmonth==12 & hryear4==2020
replace VACCINE= 1 if hryear4==2021
replace VACCINE= 0 if VACCINE==.

tab VACCINE

tab pehruslt VACCINE

***# of jobs***

tab pemjnum

tab pemjnum VACCINE


** # of hours working per week***
tab pehruslt

tab pehruslt VACCINE

*** regression****

reg pehruslt VACCINE i.gestfips modate [pw=pwsswgt],r 



reg pehruslt VACCINE lnAGE  i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate [pw=pwsswgt],  r






reg pehruslt VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate  [pw= pwfmwgt] if gereg==0,  vce(robust)
reg pehruslt VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate  [pw= pwfmwgt] if gereg==1,  vce(robust)
reg pehruslt VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate  [pw= pwfmwgt] if gereg==2,  vce(robust)
reg pehruslt VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate  [pw= pwfmwgt] if gereg==3,  vce(robust)


**APE of the variables***
margins, dydx(*) predict(ycen)


reg prhrusl VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt], r


poisson prhrusl VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt], r


poisson prhrusl VACCINE lnAGE  i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt] if gereg==0, r
poisson prhrusl VACCINE lnAGE  i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt] if gereg==1, r
poisson prhrusl VACCINE lnAGE  i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt] if gereg==2, r
poisson prhrusl VACCINE lnAGE  i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.gestfips modate [pw=pwfmwgt] if gereg==3, r






poisson pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips modate [pw=pwsswgt], r







reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt], vce(robust)

reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gereg==0, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gereg==1, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gereg==2, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gereg==3, vce(robust)


reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if race==0, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if race==1, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if race==2, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if pehspnon==1, vce(robust)





reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==1, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==2, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==3, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==4, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==5, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==6, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==7, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==8, vce(robust)
reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt] if gediv==9, vce(robust)



gen lnloghr=ln(1+pehruslt )

sum pehruslt prtage pemjnum [aw= pwsswgt] if VACCINE==0
tab income   [aw= pwsswgt]  if VACCINE==0
tab pemaritl [aw= pwsswgt] if VACCINE==0
tab pesex   [aw= pwsswgt]  if VACCINE==0
tab education  [aw= pwsswgt]  if VACCINE==0
tab race   [aw= pwsswgt]  if VACCINE==0
tab pehspnon   [aw= pwsswgt]  if VACCINE==0
tab pragna   [aw= pwsswgt]  if VACCINE==0
tab prcow1  [aw= pwsswgt]  if VACCINE==0



sum pehruslt prtage pemjnum [aw= pwsswgt] if VACCINE==1
tab income   [aw= pwsswgt]  if VACCINE==1
tab pemaritl [aw= pwsswgt] if VACCINE==1
tab pesex   [aw= pwsswgt]  if VACCINE==1
tab education  [aw= pwsswgt]  if VACCINE==1
tab race   [aw= pwsswgt]  if VACCINE==1
tab pehspnon   [aw= pwsswgt]  if VACCINE==1
tab pragna   [aw= pwsswgt]  if VACCINE==1
tab prcow1  [aw= pwsswgt]  if VACCINE==1





reg lnloghr VACCINE##pemjnum lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt], vce(robust)


reg lnloghr pemjnum lnAGE i.income i.pemaritl i.pesex i.education VACCINE##race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt], vce(robust)


reg lnloghr pemjnum lnAGE i.income i.pemaritl i.pesex i.education i.race VACCINE##pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt], vce(robust)


reg lnloghr pemjnum VACCINE lnAGE i.income i.pemaritl i.pesex i.education i.race i.pehspnon i.pragna i.prcow1 i.gestfips i.modate  [pw= pwsswgt], vce(robust)



kdensity pehruslt if (VACCINE ==0), plot(kdensity pehruslt if (VACCINE ==1) legend(ring(0) pos(2)label(0 "BEFORE VACCINATION") label(1 "DURING VACCINATION"))



kdensity pehruslt if (VACCINE ==0), plot(kdensity pehruslt if (VACCINE ==1) 



