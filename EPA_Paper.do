** load the data***
use "C:\Users\ogund\OneDrive\Desktop\outcome_EAP.dta" clear

***Set random seed prior to psmatch2 to ensure replication***
set seed 339487731

*** Sort individuals randomly before matching***
generate sort_id = uniform()
sort sort_id


 ** labelling of the variables***
 
label define D_PARTICIPATION1 0 "Non-EAP" 1 "EAP" 
label values D_PARTICIPATION D_PARTICIPATION1
 
label define graduationflg3 0 "No Diploma" 1 " Diploma Received" 
label values graduationflg graduationflg3
 
label define hsfrplflg4 0 "Non-FRPL" 1 "FRPL" 
label values hsfrplflg hsfrplflg4

label define hsspedflg2  0 "Non-Special Edu." 1 "Special Edu." 
label values hsspedflg  hsspedflg2
 
label define hsellflg2  0 "Non-Enlish Language Learner" 1 "English Language Learner" 
label values hsellflg  hsellflg2
 
label define hshomelessflg2  0 "non-Homeless" 1 "Homeless" 
label values hshomelessflg  hshomelessflg2

label define hsdisabilityflg2  0 "Without Disability" 1 "With Disability" 
label values hsdisabilityflg  hsdisabilityflg2

label define hsmigrantflg2  0 "non-migrants" 1 "Migrants" 
label values hsmigrantflg  hsmigrantflg2

label define hslapstudentflg2  0 "Non-Learning Assistance Program" 1 "Learning Assistance Program" 
label values hslapstudentflg  hslapstudentflg2

label define hscollegeboundflg2  0 "Non-college Bound scholarship" 1 "college Bound scholarship" 
label values hscollegeboundflg  hscollegeboundflg2

label define militaryparentflg1 0 "Non-Military parent" 1 " Military Parent" 
label values militaryparentflg militaryparentflg1

label define gender1 0 "Female" 1 " Male" 
label values gender gender1

** data visualization***

graph bar, over( D_PARTICIPATION )
graph hbar, over( gender , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))
graph hbar, over( race , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))
graph hbar, over( graduationflg , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))
graph hbar, over( hsfrplflg , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))
graph hbar, over( enrollorganizationlevel2 , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))
graph hbar, over( achiveorganizationlevel2 , label(angle(forty_five) labsize(small))) over( D_PARTICIPATION , label(angle(forty_five) labsize(small)))

** test of t-differences between participants and non-particpant***
ttest finalgpa , by( D_PARTICIPATION )
ttest graduationflg , by( D_PARTICIPATION )

// PSM approach//
****************************************
*** matching with replacement*******
****************************************

logit D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,r

psmatch2 d_parti d_ms d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number   vcd_number   falam hakha gyune bogalay yangon, outcome (new_PCE new_PCI) neighbor (1) caliper (0.04) common

pstest d_ms d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number  tv_number vcd_number  motorcycle_number falam hakha gyune bogalay yangon, both graph

//manually constructe inverse propensity weighting //
pscore d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  pscore(mypscore)
replace mypscore = 1/mypscore if d_parti==1
replace mypscore = 1/(1-mypscore) if d_parti==0

reg INCOME_Dollar_per d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon d_parti [aw=mypscore], robust

reg EXPENDITURE_Dollar_per d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon d_parti [aw=mypscore], robust

ttest INCOME_Dollar_per, by (d_parti )

//psmacth2//

** matching with nearest neighbor-NN***

psmatch2 d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  out(INCOME_Dollar EXPENDITURE_Dollar) neighbor (1) caliper (0.04) com ate

** checking balancing of coverates***

pstest d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon, both graph

gen  Delta_percapita_income = INCOME_Dollar -_per_capita_income if _treated==1 &  _support==1

rbounds Delta_percapita_income, gamma(1(0.1)3)

gen Delta_percapi_expend=per_capita_expenditure-_per_capita_expenditure

rbounds Delta_percapi_expend, gamma(1(0.1)3)



pstest gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg, both atu




** matching with  radius caliper algorithm********

psmatch2 d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  out(INCOME_Dollar_per EXPENDITURE_Dollar_per) radius caliper (0.05) com ate

** checking balancing of coverates***
pstest d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon, both graph

gen  Delta_percapita_income = INCOME_Dollar -_per_capita_income if _treated==1 &  _support==1
rbounds Delta_percapita_income, gamma(1(0.1)3)


gen Delta_percapi_expend=EXPENDITURE_Dollar-_per_capita_expenditure
rbounds Delta_percapi_expend, gamma(1(0.1)3)


** matching with kernel algorithm****

psmatch2 d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  out(INCOME_Dollar_per EXPENDITURE_Dollar_per) kernel k(tricube) com bwidth (0.05) ate

pstest d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon, both graph
gen  Delta_percapita_income = INCOME_Dollar_per -_per_capita_income if _treated==1 &  _support==1
rbounds Delta_percapita_income, gamma(1(0.1)3)

gen Delta_percapi_expend=EXPENDITURE_Dollar-_per_capita_expenditure
rbounds Delta_percapi_expend, gamma(1(0.1)3)


**Mahalanobis matching with caliper**

psmatch2 d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  out(INCOME_Dollar_per EXPENDITURE_Dollar_per) cal(0.10) com bwidth (0.05) ate

pstest d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon, both graph
gen  Delta_percapita_income = INCOME_Dollar_per -_per_capita_income if _treated==1 &  _support==1
rbounds Delta_percapita_income, gamma(1(0.1)3)

gen Delta_percapi_expend=EXPENDITURE_Dollar-_per_capita_expenditure
rbounds Delta_percapi_expend, gamma(1(0.1)3)


**matching with caliper**

psmatch2 d_parti d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon,  out(INCOME_Dollar_per EXPENDITURE_Dollar_per) cal(0.20) com bwidth (0.05) ate

pstest d_gen edu_year hhs_number age_year d_ms lhs_acres d_occup crops_number bicycle_number falam hakha gyune bogalay yangon, both graph
gen  Delta_percapita_income = INCOME_Dollar_per -_per_capita_income if _treated==1 &  _support==1
rbounds Delta_percapita_income, gamma(1(0.1)3)

gen Delta_percapi_expend=EXPENDITURE_Dollar-_per_capita_expenditure
rbounds Delta_percapi_expend, gamma(1(0.1)3)


// PSM//

****************************************
*** matching with replacement*******
****************************************

*****************************
*** High School Performance***
*****************************

*** finalGDP****
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa) neighbor (1) caliper (0.04) com  // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa) cal(0.10) com  // Mahalanobis matching with caliper



psgraph


*** regular attendance***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) neighbor (1) caliper (0.04) com  // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) cal(0.10) com  // Mahalanobis matching with caliper

** without common support***

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) neighbor (1) caliper (0.04)  // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) kernel k(tricube) bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) radius caliper (0.05)   // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(regularattendanceflg) cal(0.10)  // Mahalanobis matching with caliper

drop _pscore- _pdif


**** absence count***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(studentabsencecnt) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(studentabsencecnt) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(studentabsencecnt) radius caliper (0.05) com // radius caliper


** part day unexcused**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(partdayunexcusedcnt) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(partdayunexcusedcnt) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(partdayunexcusedcnt) radius caliper (0.05) com // radius caliper


** full day unexcused**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(fulldayunexcusedcnt) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(fulldayunexcusedcnt) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(fulldayunexcusedcnt) radius caliper (0.05) com // radius caliper


*****************************
*** High School Outcomes***
*****************************

** high school graduation***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) cal(0.10) com // Mahalanobis matching with caliper


pstest gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg, both graph



** without common support***

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) neighbor (1) caliper (0.04)  // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) kernel k(tricube)  bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) radius caliper (0.05)   // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(graduationflg) cal(0.10) // Mahalanobis matching with caliper





** high school dropout***

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(dropoutflg) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(dropoutflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(dropoutflg) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(dropoutflg) cal(0.10) com // Mahalanobis matching with caliper



** GED graduation***

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg,  out(gedcompletionflg) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(gedcompletionflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(gedcompletionflg) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(gedcompletionflg) cal(0.10) com // Mahalanobis matching with caliper


*********************************************
*** Post Secondary enrollment and Outcomes***
*********************************************

** enrollment***


psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_enrollment) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_enrollment) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_enrollment) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_enrollment) cal(0.10) com // Mahalanobis matching with caliper



** achievement***


psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_achievment) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_achievment) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_achievment) radius caliper (0.05) com  // radius caliper

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  out(D_achievment) cal(0.10) com // Mahalanobis matching with caliper

************************************************************************************************************************************************************


psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment) neighbor (1) caliper (0.04) com ate // nearest neighbor-NN

psgraph

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment) kernel k(tricube) com bwidth (0.05) ate // kernel 

psgraph

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment) radius caliper (0.05) com ate // radius caliper

psgraph

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment) cal(0.10) com ate // Mahalanobis matching with caliper

psgraph

pstest gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg, both graph


** Descriptive analysis
sum gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg
sum finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment if D_PARTICIPATION==1
sum finalgpa regularattendanceflg studentabsencecnt graduationflg dropoutflg gedcompletionflg D_enrollment D_achievment if D_PARTICIPATION==0

** tables 
tab regularattendanceflg 
tab graduationflg
tab dropoutflg
tab gedcompletionflg 
tab D_enrollment 
tab D_achievment 
tab regularattendanceflg if D_PARTICIPATION==1
tab graduationflg if D_PARTICIPATION==1
tab dropoutflg if D_PARTICIPATION==1
tab gedcompletionflg if D_PARTICIPATION==1
tab D_enrollment if D_PARTICIPATION==1
tab D_achievment if D_PARTICIPATION==1
tab regularattendanceflg if D_PARTICIPATION==0
tab graduationflg if D_PARTICIPATION==0
tab dropoutflg if D_PARTICIPATION==0
tab gedcompletionflg if D_PARTICIPATION==0
tab D_enrollment if D_PARTICIPATION==0
tab D_achievment if D_PARTICIPATION==0
tab graduationflg if D_PARTICIPATION==1
tab gender if D_PARTICIPATION ==1
tab race if D_PARTICIPATION ==1
tab severity if D_PARTICIPATION ==1
tab hsfrplflg if D_PARTICIPATION ==1
tab hsspedflg if D_PARTICIPATION ==1
tab hsellflg if D_PARTICIPATION ==1
tab hshomelessflg if D_PARTICIPATION ==1
tab hsdisabilityflg if D_PARTICIPATION ==1
tab hsmigrantflg if D_PARTICIPATION ==1
tab hslapstudentflg if D_PARTICIPATION ==1
tab schoolmobilitycnt if D_PARTICIPATION ==1
tab hs504flg if D_PARTICIPATION ==1
tab gender if D_PARTICIPATION ==0
tab race if D_PARTICIPATION ==0
tab severity if D_PARTICIPATION ==0
tab hsfrplflg if D_PARTICIPATION ==0
tab hsspedflg if D_PARTICIPATION ==0
tab hsellflg if D_PARTICIPATION ==0
tab hshomelessflg if D_PARTICIPATION ==0
tab hsdisabilityflg if D_PARTICIPATION ==0
tab hsmigrantflg if D_PARTICIPATION ==0
tab hslapstudentflg if D_PARTICIPATION ==0
tab schoolmobilitycnt if D_PARTICIPATION ==0
tab hs504flg if D_PARTICIPATION ==0

************************************************************************************************************************************************************
****************************************
*** matching without replacement*******
****************************************
** high school graduation***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(graduationflg) neighbor (1) caliper (0.04) com ate noreplace 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg,  out(graduationflg) kernel k(tricube) com bwidth (0.05) ate noreplace 

********************************************************
*****manually constructe inverse propensity weighting***
********************************************************

pscore D_PARTICIPATION gender race severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg,  pscore(mypscore)

replace mypscore = 1/mypscore if D_PARTICIPATION==1

replace mypscore = 1/(1-mypscore) if D_PARTICIPATION==0

reg finalgpa D_PARTICIPATION gender race severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg [aw=mypscore], robust

logit graduationflg D_PARTICIPATION gender race severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt  hs504flg [aw=mypscore], robust

****************************************************

logistic D_PARTICIPATION gender race severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg
 
predict pscore

gen w_ate = D_PARTICIPATION/pscore + (1-D_PARTICIPATION)/(1-pscore)

** weighted regression approach using the pscore as a weight**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg

regress finalgpa D_PARTICIPATION [iweight=_weight] if _weight!=.


hettreatreg gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycntregularattendanceflg hs504flg, o(finalgpa) t(D_PARTICIPATION)

reg finalgpa D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt regularattendanceflg hs504flg, vce(robust)

quietly regress D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg militaryparentflg schoolmobilitycnt hs504flg, vce(robust) 
predict pscore

teffects ra (graduationflg  pscore) (D_PARTICIPATION), vce(robust) atet  //regression adjustment
teffects nnmatch (graduationflg  pscore) (D_PARTICIPATION), vce(robust) atet //nearest-neighbor matching


**doubly robust methods***

teffects ipwra (graduationflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet // inverse-probability weighting regression adjustment

teffects ipwra (finalgpa  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet

teffects ipwra (regularattendanceflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (studentabsencecnt  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (dropoutflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (D_enrollment  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (D_achievment  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (finalgpa  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (total_absence  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (fulldayunexcusedcnt  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (partdayunexcusedcnt  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (finalgpa  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet

tebalance summarize
tebalance overid,nolog
tebalance summarize, baseline

foreach var of varlist i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit {
 tebalance density `var', saving("$output\balance_`var'", replace)
 }


// PSM approach//
***************************************************************
*** matching with replacement*******
***************************************************************

***************************************************************
*** High School charateristics***
***************************************************************

*** regular attendance***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(regularattendanceflg) neighbor (1) caliper (0.04) com  // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(regularattendanceflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(regularattendanceflg) radius caliper (0.05) com  // radius caliper

** Diagnostic test***
pstest gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg, both atu


** full day unexcused**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(fulldayunexcusedcnt) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(fulldayunexcusedcnt) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg i.cohortyear,  out(fulldayunexcusedcnt) radius caliper (0.05) com // radius caliper


** half day unexcused absences**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(partdayexcusedcnt) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(partdayexcusedcnt) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg i.cohortyear,  out(partdayexcusedcnt) radius caliper (0.05) com // radius caliper

** all unexcused**

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(Total_unexcused) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(Total_unexcused) kernel k(tricube) com bwidth (0.05)  // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg i.cohortyear,  out(Total_unexcused) radius caliper (0.05) com // radius caliper


*****************************
*** High School Outcomes***
*****************************

** high school graduation***
psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt  hs504flg i.cohortyear,  out(graduationflg) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt  hs504flg i.cohortyear,  out(graduationflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt  hs504flg i.cohortyear,  out(graduationflg) radius caliper (0.05) com  // radius caliper

** Diagnostic test***
pstest gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg, both graph


** high school dropout***

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(dropoutflg) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(dropoutflg) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg i.cohortyear,  out(dropoutflg) radius caliper (0.05) com  // radius caliper


*********************************************
*** Post Secondary enrollment and Outcomes***
*********************************************

** enrollment***


psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(D_enrollment) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(D_enrollment) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(D_enrollment) radius caliper (0.05) com  // radius caliper


** achievement***


psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg  schoolmobilitycnt hs504flg i.cohortyear,  out(D_achievment) neighbor (1) caliper (0.04) com // nearest neighbor-NN

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(D_achievment) kernel k(tricube) com bwidth (0.05) // kernel 

psmatch2  D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear,  out(D_achievment) radius caliper (0.05) com  // radius caliper


**doubly robust methods another step***

logistic D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear
 
predict pscore

teffects ipwra (regularattendanceflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (fulldayunexcusedcnt  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (graduationflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet // inverse-probability weighting regression adjustment


teffects ipwra (dropoutflg  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment


teffects ipwra (D_enrollment  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (D_achievment  pscore, logit) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (Total_unexcused  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (total_absence  pscore) (D_PARTICIPATION i.race hsfrplflg hsellflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (regularattendanceflg  pscore, logit) (D_PARTICIPATION gender i.race  hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear), vce(robust) atet //inverse-probability weighting regression adjustment

teffects ipwra (regularattendanceflg  hsfrplflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit, logit) (D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear),  atet //inverse-probability weighting regression adjustment

teffects ipwra (total_absence  hsfrplflg hshomelessflg hslapstudentflg schoolmobilitycnt i.severit) (D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg hshomelessflg hsdisabilityflg hsmigrantflg hslapstudentflg schoolmobilitycnt hs504flg i.cohortyear), vce(robust)  atet //inverse-probability weighting regression adjustment

teffects ipwra (total_absence   pscore) (D_PARTICIPATION gender i.race i.severity hsfrplflg hsspedflg hsellflg  hsdisabilityflg hsmigrantflg hslapstudentflg  hs504flg i.cohortyear), vce(robust)  atet //inverse-probability weighting regression adjustment

tebalance summarize
tebalance overid,nolog
tebalance summarize, baseline


