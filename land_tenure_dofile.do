use ""/Users/kogunda/Desktop/project_ning.dta"", replace

sum  age gender edu_year hhs membr_cooperative experience _variety irrigation  total_production land_interited land_own land_rent seed_amount fertilizer_kg agro_chemical labour_cost

//creating variable at mean//


gen agro_chemical= pesticide_liter+ herbicide_liter


gen new_production=  total_production/84.55

gen new_agrochem= agro_chemical/40.94

gen new_fertilizer= fertilizer_kg/4896.23

gen new_seed=seed_amount/870.119

gen new_labour=labour_cost/2203.167

sum  land_interited if  land_interited>0

sum  land_own if  land_own >0

sum  land_rent if land_rent >0

gen new_Inheritedland= land_interited/ 2.871154

gen new_ownland= land_own/4.665591

gen new_renland= land_rent/5.140559

// variables in logarithm//

gen log_prod=log( new_production)

gen log_agrochem=log( new_agrochem)

gen log_ferti=log( new_fertilizer)

gen log_seed=log( new_seed)

gen log_labour=log( new_labour)

gen log_inherinted=log( new_Inheritedland)

replace  log_inherinted=0 if  log_inherinted==.

gen log_own=log( new_ownland)

replace  log_own=0 if  log_own==.

gen log_rent=log( new_renland)

replace  log_rent=0 if  log_rent==.

//creating second order of the varibales//

gen sqr_chem=0.5* log_agrochem^2

gen sqr_fert=0.5* log_ferti ^2

gen sqr_seed=0.5* log_seed ^2

gen sqr_labor=0.5* log_labour ^2

gen sqr_inherit=0.5* log_inherinted ^2

gen sqr_own=0.5* log_own ^2

gen sqr_rent=0.5* log_rent ^2


gen Agro_Fert= log_agrochem* log_ferti

gen Agro_Seed= log_agrochem* log_seed

gen Agro_labor= log_agrochem* log_labour

gen Agro_inherit= log_agrochem* log_inherinted

gen Agro_own= log_agrochem* log_own

gen Agro_rent= log_agrochem* log_rent

gen fert_seed= log_ferti* log_seed

gen fert_labor= log_ferti* log_labour

gen fert_inherit= log_ferti* log_inherinted

gen fert_own= log_ferti* log_own

gen fert_rent= log_ferti* log_rent

gen seed_labour= log_seed* log_labour

gen seed_inherit= log_seed* log_inherinted

gen seed_own= log_seed*  log_own

gen seed_rent= log_seed* log_rent

gen labor_inherit= log_labour* log_inherinted

gen labor_own= log_labour*  log_own

gen labor_rent= log_labour* log_rent

gen inherit_own= log_inherinted* log_own

gen inherit_rent= log_inherinted* log_rent

gen own_rent= log_own* log_rent


//estimation of frontier production function//

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs experience membr_cooperative irrigation _variety)

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent, u( gender edu_year hhs experience membr_cooperative irrigation _variety)

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety)

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety) v(log_inherinted log_own log_rent)

frontier  log_prod- own_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety log_inherinted log_own log_rent) v(log_inherinted log_own log_rent)



frontier  log_prod-log_rent  D_Heritance D_Owned D_rent

frontier  log_prod-log_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs experience membr_cooperative irrigation _variety)

frontier  log_prod-log_rent  D_Heritance D_Owned D_rent, u( gender edu_year hhs experience membr_cooperative irrigation _variety)

frontier  log_prod-log_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety)

frontier  log_prod-log_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety) v(log_inherinted log_own log_rent)

frontier  log_prod-log_rent  D_Heritance D_Owned D_rent, u(age gender edu_year hhs  membr_cooperative irrigation _variety log_inherinted log_own log_rent) v(log_inherinted log_own log_rent)




//main estimation//


// translog//
frontier log_prod D_Heritance D_Owned D_rent log_agrochem-own_rent, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)
predict te_1a,te






sum  te_1

sum  te_1 if  D_Heritance==1 & D_Owned==1 &  D_rent==1
sum  te_1 if  D_Heritance==1 & D_Owned==1 &  D_rent==0
sum  te_1 if  D_Heritance==1 & D_Owned==0 &  D_rent==1
sum  te_1 if  D_Heritance==0 & D_Owned==1 &  D_rent==1
sum  te_1 if  D_Heritance==0 & D_Owned==0 &  D_rent==1
sum  te_1 if  D_Heritance==0 & D_Owned==1 &  D_rent==0
sum  te_1 if  D_Heritance==1 & D_Owned==0 &  D_rent==0



histogram  te_1 if  D_Heritance==1 & D_Owned==1 &  D_rent==1, normal 
histogram  te_1 if  D_Heritance==1 & D_Owned==1 &  D_rent==0, normal 
histogram  te_1 if  D_Heritance==1 & D_Owned==0 &  D_rent==1, normal 
histogram  te_1 if  D_Heritance==0 & D_Owned==1 &  D_rent==1, normal 
histogram  te_1 if  D_Heritance==0 & D_Owned==0 &  D_rent==1, normal 
histogram  te_1 if  D_Heritance==0 & D_Owned==1 &  D_rent==0, normal 
histogram  te_1 if  D_Heritance==1 & D_Owned==0 &  D_rent==0, normal 



sum TOTAL_LAND

sum  TOTAL_LAND if  D_Heritance==1 & D_Owned==1 &  D_rent==1
sum  TOTAL_LAND if  D_Heritance==1 & D_Owned==1 &  D_rent==0
sum  TOTAL_LAND if  D_Heritance==1 & D_Owned==0 &  D_rent==1
sum  TOTAL_LAND if  D_Heritance==0 & D_Owned==1 &  D_rent==1
sum  TOTAL_LAND if  D_Heritance==0 & D_Owned==0 &  D_rent==1
sum  TOTAL_LAND if  D_Heritance==0 & D_Owned==1 &  D_rent==0
sum  TOTAL_LAND if  D_Heritance==1 & D_Owned==0 &  D_rent==0


sum  total_production if  D_Heritance==1 & D_Owned==1 &  D_rent==1
sum  total_production if  D_Heritance==1 & D_Owned==1 &  D_rent==0
sum  total_production if  D_Heritance==1 & D_Owned==0 &  D_rent==1
sum  total_production if  D_Heritance==0 & D_Owned==1 &  D_rent==1
sum  total_production if  D_Heritance==0 & D_Owned==0 &  D_rent==1
sum  total_production if  D_Heritance==0 & D_Owned==1 &  D_rent==0
sum  total_production if  D_Heritance==1 & D_Owned==0 &  D_rent==0


kernreg total_production TOTAL_LAND, bwidth(0.65) kercode(4) npoint(100)

twoway (scatter total_production TOTAL_LAND) (lfit total_production TOTAL_LAND)

twoway (scatter te_1 TOTAL_LAND) (lfit te_1 TOTAL_LAND)

twoway (scatter total_production te_1) (lfit total_production te_1)


//cobb-douglass//
frontier log_prod D_Heritance D_Owned D_rent log_agrochem-log_rent, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)
predict te_2,te


//inefficiency effect//
frontier log_prod D_Heritance D_Owned D_rent log_agrochem-own_rent,  vhet(log_inherinted log_own log_rent)

//heterogenity test//
frontier log_prod D_Heritance D_Owned D_rent log_agrochem-own_rent, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) 

frontier log_prod D_Heritance D_Owned D_rent log_agrochem-own_rent

frontier log_prod D_Heritance D_Owned D_rent log_agrochem-own_rent, uhet(gender edu_year experience _variety membr_cooperative) vhet(log_inherinted log_own log_rent)

frontier log_prod D_Heritance log_agrochem-own_rent, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)

frontier log_prod  log_agrochem-log_labour sqr_chem-sqr_labor Agro_Fert Agro_Seed Agro_labor fert_seed fert_labor seed_labour, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)


frontier log_prod D_Heritance D_Owned D_rent log_agrochem-log_rent, uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)

 
//another //

frontier log_prod- log_labour sqr_chem- sqr_labor Agro_Fert- Agro_labor fert_seed fert_labor seed_labour , uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)
predict te_3,te


frontier log_prod- log_labour sqr_chem- sqr_labor Agro_Fert- Agro_labor fert_seed fert_labor seed_labour , uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) 


frontier log_prod- log_labour sqr_chem- sqr_labor Agro_Fert- Agro_labor fert_seed fert_labor seed_labour , uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vhet(log_inherinted log_own log_rent)


frontier log_prod- log_labour , uhet(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) 




** news estimates***

sfcross log_prod log_agrochem log_ferti log_seed log_labour log_inherinted log_own log_rent D_Heritance D_Owned D_rent,usigma(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vsigma(log_inherinted log_own log_rent) 



sfcross log_prod log_agrochem log_ferti log_seed log_labour log_inherinted log_own log_rent D_Heritance D_Owned D_rent,emean(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vsigma(log_inherinted log_own log_rent) distribution(tnormal)



sfcross log_prod log_agrochem log_ferti log_seed log_labour log_inherinted log_own log_rent D_Heritance D_Owned D_rent sqr_chem-own_rent,usigma(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vsigma(log_inherinted log_own log_rent) distribution(tnormal)


sfcross log_prod log_agrochem log_ferti log_seed log_labour log_inherinted log_own log_rent D_Heritance D_Owned D_rent sqr_chem-own_rent,emean(gender edu_year experience _variety membr_cooperative log_inherinted log_own log_rent) vsigma(log_inherinted log_own log_rent) distribution(tnormal)



predict jlms, jlms ci

predict bc, bc ci

mean gender_V-log_rent_V


sum  jlms

sum  jlms if  D_Heritance==1 & D_Owned==1 &  D_rent==1
sum  jlms if  D_Heritance==1 & D_Owned==1 &  D_rent==0
sum  jlms if  D_Heritance==1 & D_Owned==0 &  D_rent==1
sum  jlms if  D_Heritance==0 & D_Owned==1 &  D_rent==1
sum  jlms if  D_Heritance==0 & D_Owned==0 &  D_rent==1
sum  jlms if  D_Heritance==0 & D_Owned==1 &  D_rent==0
sum  jlms if  D_Heritance==1 & D_Owned==0 &  D_rent==0













































