use "C:\Users\ogund\OneDrive\Desktop\Students\New folder\Merged2.dta", clear

describe
tab wrkloss
tab expctloss
tab expctloss anywork
tab anywork
tab ui_apply
tab ui_recv
tab childfood
tab foodsufrsn1
tab foodconf
tab tenure
tab privhlth
tab pubhlth
save "C:\Users\ogund\OneDrive\Desktop\Week18.dta", replace
drop scram expctloss anywork kindwork rsnnowrk tw_start unemppay ui_recv tui_numper ssa_recv ssa_apply ssapgm1 ssapgm2 ssapgm3 ssapgm4 ssapgm5 ssalikely ssaexpct1 ssaexpct2 ssaexpct3 ssaexpct4 ssaexpct5 ssadecisn expns_dif chnghow1 chnghow2 chnghow3 chnghow4 chnghow5 chnghow6 chnghow7 chnghow8 chnghow9 chnghow10 chnghow11 chnghow12 whychngd1 whychngd2 whychngd3 whychngd4 whychngd5 whychngd6 whychngd7 whychngd8 whychngd9 whychngd10 whychngd11 whychngd12 whychngd13 spndsrc1 spndsrc2 spndsrc3 spndsrc4 spndsrc5 spndsrc6 spndsrc7 spndsrc8 fewrtrips fewrtrans plndtrips cncldtrps foodsufrsn1 foodsufrsn2 foodsufrsn3 foodsufrsn4 foodsufrsn5 wherefree1 wherefree2 wherefree3 wherefree4 wherefree5 wherefree6 wherefree7 snapmnth1 snapmnth2 snapmnth3 snapmnth4 snapmnth5 snapmnth6 snapmnth7 snapmnth8 snapmnth9 snapmnth10 snapmnth11 snapmnth12 tspndfood tspndprpd foodconf anxious worry interest down delay notget mh_svcs mh_notget livqtr tbedrooms rentcur mortcur mortconf evict forclose comp1 comp2 comp3 intrnt1 intrnt2 intrnt3 tnum_ps psplans1 psplans2 psplans3 psplans4 psplans5 psplans6 pschng1 pschng2 pschng3 pschng4 pschng5 pschng6 pschng7 pswhychg1 pswhychg2 pswhychg3 pswhychg4 pswhychg5 pswhychg6 pswhychg7 pswhychg8 pswhychg9
describe
count




drop prifoodsuf hlthstatus

***now**

drop scram expctloss anywork kindwork rsnnowrk tw_start ui_recv ssa_recv ssa_apply ssapgm1 ssapgm2 ssapgm3 ssapgm4 ssapgm5 ssalikely ssaexpct1 ssaexpct2 ssaexpct3 ssaexpct4 ssaexpct5 ssadecisn expns_dif chnghow1 chnghow2 chnghow3 chnghow4 chnghow5 chnghow6 chnghow7 chnghow8 chnghow9 chnghow10 chnghow11 chnghow12 whychngd1 whychngd2 whychngd3 whychngd4 whychngd5 whychngd6 whychngd7 whychngd8 whychngd9 whychngd10 whychngd11 whychngd12 whychngd13 spndsrc1 spndsrc2 spndsrc3 spndsrc4 spndsrc5 spndsrc6 spndsrc7 spndsrc8 fewrtrips fewrtrans plndtrips foodsufrsn1 foodsufrsn2 foodsufrsn3 foodsufrsn4 foodsufrsn5 wherefree1 wherefree2 wherefree3 wherefree4 wherefree5 wherefree6 wherefree7 tspndfood tspndprpd anxious worry interest down delay notget mh_svcs mh_notget livqtr rentcur mortcur mortconf evict forclose comp1 comp2 comp3 intrnt1 intrnt2 intrnt3 tnum_ps psplans1 psplans2 psplans3 psplans4 psplans5 psplans6 pschng1 pschng2 pschng3 pschng4 pschng5 pschng6 pschng7 pswhychg1 pswhychg2 pswhychg3 pswhychg4 pswhychg5 pswhychg6 pswhychg7 pswhychg8 pswhychg9 recvdvacc- hadcovid eip- eipspnd13




replace compavail =10 if compavail==1
replace compavail =20 if compavail==2
replace compavail =30 if compavail==3
replace compavail =40 if compavail==4
replace compavail =50 if compavail==5


replace compavail =5 if compavail==10
replace compavail =4 if compavail==20
replace compavail =3 if compavail==30
replace compavail =2 if compavail==40
replace compavail =1 if compavail==50




replace intrntavail =10 if intrntavail==1
replace intrntavail =20 if intrntavail==2
replace intrntavail =30 if intrntavail==3
replace intrntavail =40 if intrntavail==4
replace intrntavail =50 if intrntavail==5


replace intrntavail =5 if intrntavail==10
replace intrntavail =4 if intrntavail==20
replace intrntavail =3 if intrntavail==30
replace intrntavail =2 if intrntavail==40
replace intrntavail =1 if intrntavail==50





replace curfoodsuf =10 if curfoodsuf==1
replace curfoodsuf =20 if curfoodsuf==2
replace curfoodsuf =30 if curfoodsuf==3
replace curfoodsuf =40 if curfoodsuf==4


replace curfoodsuf =4 if curfoodsuf==10
replace curfoodsuf =3 if curfoodsuf==20
replace curfoodsuf =2 if curfoodsuf==30
replace curfoodsuf =1 if curfoodsuf==40




tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.rhispanic i.rrace i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region year [pw= hweight] , ll(0)



tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.rhispanic i.rrace i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region year [pw= hweight] , ll(0)




tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region [pw= hweight] if rrace==1, ll(0)

tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region [aw= hweight] if rrace==2, ll(0)

tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region [aw= hweight] if rrace==3, ll(0)

tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region [aw= hweight] if rrace==4, ll(0)

tobit tstdy_hrs i.schlhrs tech_index i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.wrkloss i.curfoodsuf i.region [aw= hweight] if rhispanic==1, ll(0)



*** new estimation full sample**

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.rhispanic i.rrace i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight], tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)
outreg2 using results1b, word append

**plots** 
quiet margins, dydx(tech_index) predict(ycen) at(tech_index = (0(2)70))
marginsplot, noci plotopts(msymbol(none)) plotregion(margin(zero)) title("")ytitle("Marginal effects on Study Hours ") 





** save results into log file****
log using "My Results.txt", replace 

** race /ethinicity specific***

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight] if rrace==0, tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)
outreg2 using results, word replace

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight] if rrace==1, tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)
outreg2 using results1g, word 

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight] if rrace==2, tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)
outreg2 using results1e, word 

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight] if rrace==3, tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)

outreg2 using results1e, word append

nehurdle tstdy_hrs i.schlhrs tech_index1 i.income Age i.egender i.eeduc i.ms  thhld_numkid thhld_numadlt i.curfoodsuf i.region [pw= hweight] if rhispanic==1, tobit nolog vce(robust)
**APE of the variables***
margins, dydx(*) predict(ycen)
outreg2 using results1g, word append

**plots** 
quiet margins, dydx(tech_index) predict(ycen) at(tech_index = (0(2)70))
marginsplot, noci plotopts(msymbol(none)) plotregion(margin(zero)) title("")ytitle("Marginal effects on Study Hours ") 







replace year =2020 if year==13
replace year =2020 if year==14
replace year =2020 if year==15
replace year =2020 if year==16
replace year =2020 if year==17
replace year =2020 if year==18
replace year =2020 if year==19
replace year =2020 if year==20
replace year =2020 if year==21
replace year =2021 if year==22
replace year =2021 if year==23
replace year =2021 if year==24
replace year =2021 if year==25
replace year =2021 if year==26
replace year =2021 if year==27



label define incoms 0 " Less than $25,000"  1 "$25,000 - $34,999 " 2 "$35,000 - $49,999 " 3 "$50,000 - $74,999 " 4 "$75,000 - $99,999 " 5 "$100,000 - $149,999 " 6 "$150,000 - $199,999 " 7 "$200,000 and above "
label values income incoms


label define gender2 1 "Male"  0 "Female" 
label values egender gender2


label define ed 0 "Less than high school"  1 "Some high school"  2 "High School/ GED" 3 " Some College/In progress " 4 "Associate degree" 5 "Bachelor degree" 6 "Postgraduate degree" 
label values eeduc ed


label define hispani3 1 "Hispanic"  0 "Non-Hispanic" 
label values rhispanic hispani3


label define RAC2 0 "White"  1 "Black" 2 "Asian" 3 "Other_races" 
label values rrace RAC2

label define REGION3 0 "NorthEast"  1 "South" 2 "Midwest" 3 "West"
label values region REGION3


label define schlhrs23 0 "None"  1 "1 day" 2 "2-3 days" 3 " 4 or more days"  
label values schlhrs schlhrs23



label define intrntavail2 5 "Always available"  4 "Usually available" 3 "Sometimes available" 2 " Rarely available" 1 " Never available"  
label values intrntavail intrntavail2


label define compavail2 5 "Always available"  4 "Usually available" 3 "Sometimes available" 2 " Rarely available" 1 " Never available"  
label values compavail compavail2


label define ms1 1 "Married"  0 "Not married" 
label values ms ms1


label define teach10 1 "In person class cancelled"  0 "Not cancelled" 
label values teach1 teach10

label define teach20 1 "In person moved to online "  0 "Not moved to online" 
label values teach2 teach20

label define teach30 1 "In person turned to send in materials"  0 "Not cancelled" 
label values teach3 teach30

label define teach40 1 "In person class cancelled"  0 "Not cancelled" 
label values teach4 teach40

label define teach50 1 "In person class cancelled"  0 "Not cancelled" 
label values teach5 teach50



** data transformation***




replace curfoodsuf =10 if curfoodsuf==1
replace curfoodsuf =20 if curfoodsuf==0


replace curfoodsuf =1 if curfoodsuf==20
replace curfoodsuf =0 if curfoodsuf==10



replace rhispanic =10 if rhispanic==1
replace rhispanic =20 if rhispanic==0


replace rhispanic =1 if rhispanic==20
replace rhispanic =0 if rhispanic==10



replace schlhrs =10 if schlhrs==1
replace schlhrs =20 if schlhrs==2
replace schlhrs =30 if schlhrs==3
replace schlhrs =40 if schlhrs==4


replace schlhrs =0 if schlhrs==10
replace schlhrs =1 if schlhrs==20
replace schlhrs =2 if schlhrs==30
replace schlhrs =3 if schlhrs==40



replace income =10 if income==1
replace income =20 if income==2
replace income =30 if income==3
replace income =40 if income==4
replace income =50 if income==5
replace income =60 if income==6
replace income =70 if income==7
replace income =80 if income==8

replace income =0 if income==10
replace income =1 if income==20
replace income =2 if income==30
replace income =3 if income==40
replace income =4 if income==50
replace income =5 if income==60
replace income =6 if income==70
replace income =7 if income==80


replace region =10 if region==1
replace region =20 if region==2
replace region =30 if region==3
replace region =40 if region==4


replace region =0 if region==10
replace region =1 if region==20
replace region =2 if region==30
replace region =3 if region==40



replace eeduc =10 if eeduc==1
replace eeduc =20 if eeduc==2
replace eeduc =30 if eeduc==3
replace eeduc =40 if eeduc==4
replace eeduc =50 if eeduc==5
replace eeduc =60 if eeduc==6
replace eeduc =70 if eeduc==7

replace eeduc =0 if eeduc==10
replace eeduc =1 if eeduc==20
replace eeduc =2 if eeduc==30
replace eeduc =3 if eeduc==40
replace eeduc =4 if eeduc==50
replace eeduc =5 if eeduc==60
replace eeduc =6 if eeduc==70



replace rrace =10 if rrace==1
replace rrace =20 if rrace==2
replace rrace =30 if rrace==3
replace rrace =40 if rrace==4

replace rrace =0 if rrace==10
replace rrace =1 if rrace==20
replace rrace =2 if rrace==30
replace rrace =3 if rrace==40


***PCA***

pca compavail intrntavail
predict tech_index

gen tech_index1 = [tech_index-(-8.633762)]/[(0.5899819)-(-8.633762)]


**description**
putexcel (A1) = ("Output") C:\Users\ogund\OneDrive\Desktop\kola_23333.xlsx 

** summary statistics***

tab schlhrs [aw= hweight]
tab income  [aw= hweight]
sum Age thhld_numkid thhld_numadlt [aw= hweight]
tab egender  [aw= hweight]
tab eeduc [aw= hweight]
tab ms  [aw= hweight]
tab wrkloss [aw= hweight]
tab curfoodsuf  [aw= hweight]
tab region  [aw= hweight]
tab compavail  [aw= hweight]
tab intrntavail  [aw= hweight]

tab schlhrs [aw= hweight] if rrace==1
tab income  [aw= hweight]  if rrace==1
sum Age thhld_numkid thhld_numadlt [aw= hweight]  if rrace==1
tab egender  [aw= hweight]  if rrace==1
tab eeduc [aw= hweight]  if rrace==1
tab ms  [aw= hweight]  if rrace==1
tab wrkloss [aw= hweight]  if rrace==1
tab curfoodsuf  [aw= hweight]  if rrace==1
tab region  [aw= hweight]  if rrace==1
tab compavail  [aw= hweight]  if rrace==1
tab intrntavail  [aw= hweight]  if rrace==1


tab schlhrs [aw= hweight] if rrace==2
tab income  [aw= hweight]  if rrace==2
sum Age thhld_numkid thhld_numadlt [aw= hweight]  if rrace==2
tab egender  [aw= hweight]  if rrace==2
tab eeduc [aw= hweight]  if rrace==2
tab ms  [aw= hweight]  if rrace==2
tab wrkloss [aw= hweight]  if rrace==2
tab curfoodsuf  [aw= hweight]  if rrace==2
tab region  [aw= hweight]  if rrace==2
tab compavail  [aw= hweight]  if rrace==2
tab intrntavail  [aw= hweight]  if rrace==2


tab schlhrs [aw= hweight] if rrace==3
tab income  [aw= hweight]  if rrace==3
sum Age thhld_numkid thhld_numadlt [aw= hweight]  if rrace==3
tab egender  [aw= hweight]  if rrace==3
tab eeduc [aw= hweight]  if rrace==3
tab ms  [aw= hweight]  if rrace==3
tab wrkloss [aw= hweight]  if rrace==3
tab curfoodsuf  [aw= hweight]  if rrace==3
tab region  [aw= hweight]  if rrace==3
tab compavail  [aw= hweight]  if rrace==3
tab intrntavail  [aw= hweight]  if rrace==3


tab schlhrs [aw= hweight] if rrace==4
tab income  [aw= hweight]  if rrace==4
sum Age thhld_numkid thhld_numadlt [aw= hweight]  if rrace==4
tab egender  [aw= hweight]  if rrace==4
tab eeduc [aw= hweight]  if rrace==4
tab ms  [aw= hweight]  if rrace==4
tab wrkloss [aw= hweight]  if rrace==4
tab curfoodsuf  [aw= hweight]  if rrace==4
tab region  [aw= hweight]  if rrace==4
tab compavail  [aw= hweight]  if rrace==4
tab intrntavail  [aw= hweight]  if rrace==4



tab schlhrs  if rhispanic==1 [aw= hweight]
tab income  [aw= hweight]  if rhispanic==1
sum Age thhld_numkid thhld_numadlt [aw= hweight]  if rhispanic==1
tab egender  [aw= hweight]  if rhispanic==1
tab eeduc [aw= hweight]  if rhispanic==1
tab ms  [aw= hweight]  if rhispanic==1
tab wrkloss [aw= hweight]  if rhispanic==1
tab curfoodsuf  [aw= hweight]  if rhispanic==1
tab region  [aw= hweight]  if rhispanic==1
tab compavail  [aw= hweight]  if rhispanic==1
tab intrntavail  [aw= hweight]  if rhispanic==1



**graphs***
graph bar [aw= hweight], over( intrntavail , label(angle(forty_five) labsize(small))) over( rhispanic , label(angle(forty_five) labsize(small)))

graph bar [aw= hweight], over( compavail , label(angle(forty_five) labsize(small))) over( rhispanic , label(angle(forty_five) labsize(small)))


graph bar [aw= hweight], over( compavail , label(angle(forty_five) labsize(small))) over( rrace , label(angle(forty_five) labsize(small)))

graph bar [aw= hweight], over( intrntavail , label(angle(forty_five) labsize(small))) over( rrace , label(angle(forty_five) labsize(small)))




tabstat tech_index1  [aw= hweight ], by( rhispanic )

tabstat tech_index1 [aw= hweight ], by( rrace )


mean tech_index1 [aw= hweight] , over( rhispanic )
matrix list e(V)
test tech_index1@0.rhispanic = tech_index1@1.rhispanic

mean tech_index1 [aw= hweight] , over( rrace )
matrix list e(V)
test tech_index1@0.rrace = tech_index1@1.rrace
test tech_index1@0.rrace = tech_index1@2.rrace
test tech_index1@0.rrace = tech_index1@3.rrace



mean tech_index1 [aw= hweight] , over( income)
**#

tab tstdy_hrs [aw= hweight] 
tab tstdy_hrs [aw= hweight] if rrace==0
tab tstdy_hrs [aw= hweight] if rrace==1
tab tstdy_hrs [aw= hweight] if rrace==2
tab tstdy_hrs [aw= hweight] if rrace==3
tab tstdy_hrs [aw= hweight] if rhispanic==1



sum tech_index1 [pw= hweight] if rrace==0
sum tech_index1 [pw= hweight] if rrace==1
sum tech_index1 [pw= hweight] if rrace==2
sum tech_index1 [pw= hweight] if rrace==3
sum tech_index1 [pw= hweight] if rhispanic==1


** summary ***

tab schlhrs  [aw= hweight]
tab income  [aw= hweight]
sum Age [aw= hweight]
tab egender  [aw= hweight]
tab rhispanic [aw= hweight]
tab rrace  [aw= hweight]
tab eeduc  [aw= hweight]
tab ms   [aw= hweight]
sum thhld_numkid [aw= hweight]
sum thhld_numadlt  [aw= hweight]
tab curfoodsuf  [aw= hweight]
tab region  [aw= hweight]

tab schlhrs  [aw= hweight] if rrace==0
tab income  [aw= hweight]  if rrace==0
sum Age [aw= hweight]  if rrace==0
tab egender  [aw= hweight]  if rrace==0
tab eeduc  [aw= hweight]  if rrace==0
tab ms   [aw= hweight]  if rrace==0
sum thhld_numkid [aw= hweight]  if rrace==0
sum thhld_numadlt  [aw= hweight]  if rrace==0
tab curfoodsuf  [aw= hweight]  if rrace==0
tab region  [aw= hweight]  if rrace==0


tab schlhrs  [aw= hweight] if rrace==1
tab income  [aw= hweight]  if rrace==1
sum Age [aw= hweight]  if rrace==1
tab egender  [aw= hweight]  if rrace==1
tab eeduc  [aw= hweight]  if rrace==1
tab ms   [aw= hweight]  if rrace==1
sum thhld_numkid [aw= hweight]  if rrace==1
sum thhld_numadlt  [aw= hweight]  if rrace==1
tab curfoodsuf  [aw= hweight]  if rrace==1
tab region  [aw= hweight]  if rrace==1


tab schlhrs  [aw= hweight] if rrace==2
tab income  [aw= hweight]  if rrace==2
sum Age [aw= hweight]  if rrace==2
tab egender  [aw= hweight]  if rrace==2
tab eeduc  [aw= hweight]  if rrace==2
tab ms   [aw= hweight]  if rrace==2
sum thhld_numkid [aw= hweight]  if rrace==2
sum thhld_numadlt  [aw= hweight]  if rrace==2
tab curfoodsuf  [aw= hweight]  if rrace==2
tab region  [aw= hweight]  if rrace==2


tab schlhrs  [aw= hweight] if rrace==3
tab income  [aw= hweight]  if rrace==3
sum Age [aw= hweight]  if rrace==3
tab egender  [aw= hweight]  if rrace==3
tab eeduc  [aw= hweight]  if rrace==3
tab ms   [aw= hweight]  if rrace==3
sum thhld_numkid [aw= hweight]  if rrace==3
sum thhld_numadlt  [aw= hweight]  if rrace==3
tab curfoodsuf  [aw= hweight]  if rrace==3
tab region  [aw= hweight]  if rrace==3


tab schlhrs  [aw= hweight] if rhispanic==1
tab income  [aw= hweight]  if rhispanic==1
sum Age [aw= hweight]  if rhispanic==1
tab egender  [aw= hweight]  if rhispanic==1
tab eeduc  [aw= hweight]  if rhispanic==1
tab ms   [aw= hweight]  if rhispanic==1
sum thhld_numkid [aw= hweight]  if rhispanic==1
sum thhld_numadlt  [aw= hweight]  if rhispanic==1
tab curfoodsuf  [aw= hweight]  if rhispanic==1
tab region  [aw= hweight]  if rhispanic==1





**

matrix median = J(5, 3, .)
matrix coln median = median ll95 ul95
matrix rown median = 1 2 3 4 5
forv i = 1/5 {
      quietly centile tech_index1 if rrace== i'
      matrix median [ 'i',1] = r(c_1), r(lb_1), r(ub_1)
 }
matrix list median


mean tech_index1 , over( rrace )
estimates store mean
coefplot (mean) (matrix(median[,1]), ci((median[,2] median[,3]))), ytitle(race)






