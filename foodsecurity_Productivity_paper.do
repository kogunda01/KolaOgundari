use "/Users/kogunda/Desktop/food_WITHOUT.dta", clear 

table country_code

table countries

table year


tsset COUNTRY_ID year


gen D_80= year ==1980
gen D_81= year ==1981
gen D_82= year ==1982
gen D_83= year ==1983
gen D_84= year ==1984
gen D_85= year ==1985
gen D_86= year ==1986
gen D_87= year ==1987
gen D_88= year ==1988
gen D_89= year ==1989
gen D_90= year ==1990
gen D_91= year ==1991
gen D_92= year ==1992
gen D_93= year ==1993
gen D_94= year ==1994
gen D_95= year ==1995
gen D_96= year ==1996
gen D_97= year ==1997
gen D_98= year ==1998
gen D_99= year ==1999
gen D_2000= year ==2000
gen D_2001= year ==2001
gen D_2002= year ==2002
gen D_2003= year ==2003
gen D_2004= year ==2004
gen D_2005= year ==2005
gen D_2006= year ==2006
gen D_2007= year ==2007
gen D_2008= year ==2008
gen D_2009= year ==2009


gen COUNTRY_ID=country_code*1



label define country_num 1 "Angola" 2 "Benin" 3 "Botswana" 4 "Burkina Faso" 5 "Burundi" 6 "Cameroon" 7 "Cape Verde" 8 "Central African Republic" 9 "Chad" 10 "Comoros" 11 "Congo" 12 "Côte d'Ivoire " 13 "Ethiopia" 14 "Gabon" 15 "Gambia" 16 "Ghana" 17 "Guinea" 18 "Guinea-Bissau" 19 "Kenya" 20 "Lesotho" 21 "Liberia" 22 "Madagascar"23 "Malawi" 24 "Mali" 25 "Mauritania" 26 "Mauritius" 27 "Mozambique" 28 "Nambia" 29 "Niger" 30 "Nigeria" 31 "Rwanda" 32 "Sao Tome and Principe" 33 "Senegal" 34 "Sierra Leone" 35 "South Africa" 36 "Swaziland" 37 "Togo" 38 "Uganda" 39 "United Republic Tanzania" 40 "Zambia" 41 "Zimbabwe" 

label values COUNTRY_ID country_num 


tsset COUNTRY_ID year

// dependent variables//

calorie 

protein 

total_food_produce 

total_food_consume

sum  total_food_produce total_food_consume calorie protein food_aid_received  democracy_fh trade_openness agric_productivity life_expectancy population_014 population_64 share_arable_land cereal_yield urban_population population_female GDP_Growth Population_Growth


// fixed effect model//

xtreg  log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtreg  log_calorie GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtreg  log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female,fe


xtreg  log_protein GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtreg  log_calorie GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtreg  log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female,fe



//FGLS estimates//

xtgls   log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)

xtgls   log_calorie GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)

xtgls   log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, panels(correlated) corr(ar1)


xtgls   log_protein GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)

xtgls   log_calorie GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)

xtgls   log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, panels(correlated) corr(ar1)



// Wooldridge’s test of serial correlation//

xtserial  log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, output

xtserial  log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, output

xtserial  log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female,output



xtserial  log_protein GDP_Growth life_expectancy log_Agric_Productivity   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, output

xtserial  log_protein GDP_Growth life_expectancy log_Agric_Productivity   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, output

xtserial  log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population  population_female,output


// Pesaran test of serial correlation//

xtreg  log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtcsd, pesaran abs


xtreg  log_calorie GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe

xtcsd, pesaran abs



xtreg  log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female,fe
xtcsd, pesaran abs



xtreg  log_protein GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe
xtcsd, pesaran abs


xtreg  log_calorie GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female,fe
xtcsd, pesaran abs


xtreg  log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female,fe
xtcsd, pesaran abs



//greapgh//


xtline tfp_growth


binscatter log_foodavailable  tfp_growth, line(qfit)

binscatter log_calorie  tfp_growth, line(qfit)

binscatter log_protein  tfp_growth, line(qfit)




kernreg log_foodavailable  tfp_growth, bwidth(0.65) kercode(4) npoint(100)


lpoly log_foodavailable  tfp_growth


twoway (lowess log_foodavailable  tfp_growth, bwidth(0.2)) (scatter log_foodavailable  tfp_growth)



twoway (tsline log_foodavailable  tfp_growth)



//FGLS estimates with marginal effects graph//

xtgls   log_protein GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)


xtgls   log_calorie GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)

xtgls   log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)


xtgls   log_protein GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)

xtgls   log_calorie GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)


xtgls   log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, panels(correlated) corr(ar1)
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)



xtgls   log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, panels(correlated) corr(ar1)

estimates store food_supply

xtgls   log_calorie GDP_Growth life_expectancy log_Agric_Productivity  democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)

estimates store calorie_supply

coefplot (food_supply) (calorie_supply, axis(2)), drop(?cons) xtitle(food_supply) xtitle(calorie_supply, axis(2))


 

//Re_estimation//


twoway (scatter log_foodavailable tfp_growth) (lfit log_foodavailable tfp_growth)


twoway (scatter log_calorie tfp_growth) (lfit log_calorie tfp_growth)


twoway (scatter log_protein tfp_growth) (lfit log_protein tfp_growth)




semipar log_foodavailable GDP_Growth life_expectancy tfp_growth  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, nonpar(tfp_growth) xtitle(tfp_growth) ci 


semipar log_calorie GDP_Growth life_expectancy tfp_growth  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, nonpar(tfp_growth) xtitle(tfp_growth) ci 


semipar log_protein GDP_Growth life_expectancy tfp_growth  democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female, nonpar(tfp_growth) xtitle(tfp_growth) ci 



*****************************************************
* Dynamic specification with xtabond2 & tfp_growth
*****************************************************





xtabond2  log_foodavailable l.log_foodavailable GDP_Growth life_expectancy log_Agric_Productivity democracy_fh  trade_openness   population_014 population_64 urban_population population_female ,  gmm(GDP_Growth life_expectancy tfp_growth, collapse) iv( democracy_fh trade_openness  population_014 population_64 urban_population population_female, eq(dif)) two h(2)

xtabond2  log_calorie l.log_calorie democracy_fh GDP_Growth life_expectancy log_Agric_Productivity trade_openness   population_014 population_64 urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64  urban_population population_female, eq(dif)) two h(2)

xtabond2  log_protein l.log_protein democracy_fh GDP_Growth life_expectancy log_Agric_Productivity trade_openness   population_014 population_64  urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64 urban_population population_female, eq(dif)) two h(2)





xtabond2  log_foodavailable l.log_foodavailable GDP_Growth life_expectancy log_Cereal_Yield democracy_fh  trade_openness   population_014 population_64 urban_population population_female ,  gmm(GDP_Growth life_expectancy tfp_growth, collapse) iv( democracy_fh trade_openness  population_014 population_64 urban_population population_female, eq(dif)) two h(2)

xtabond2  log_calorie l.log_calorie democracy_fh GDP_Growth life_expectancy log_Cereal_Yield trade_openness   population_014 population_64 urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64  urban_population population_female, eq(dif)) two h(2)

xtabond2  log_protein l.log_protein democracy_fh GDP_Growth life_expectancy log_Cereal_Yield trade_openness   population_014 population_64  urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64 urban_population population_female, eq(dif)) two h(2)












xtabond2  log_foodavailable l.log_foodavailable GDP_Growth life_expectancy tfp_growth democracy_fh  trade_openness   population_014 population_64 urban_population population_female ,  gmm(GDP_Growth life_expectancy tfp_growth, collapse) iv( democracy_fh trade_openness  population_014 population_64 urban_population population_female, eq(dif)) two h(2)

xtabond2  log_calorie l.log_calorie democracy_fh GDP_Growth life_expectancy tfp_growth trade_openness   population_014 population_64 urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64  urban_population population_female, eq(dif)) two h(2)

xtabond2  log_protein l.log_protein democracy_fh GDP_Growth life_expectancy tfp_growth trade_openness   population_014 population_64  urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64 urban_population population_female, eq(dif)) two h(2)




****************************** 
*with two lags
*******************************

xtabond2  log_foodavailable l(1/2).log_foodavailable GDP_Growth life_expectancy tfp_growth democracy_fh  trade_openness   population_014 population_64 urban_population population_female ,  gmm(GDP_Growth life_expectancy tfp_growth, collapse) iv( democracy_fh trade_openness  population_014 population_64 urban_population population_female, eq(dif)) two h(2)


xtabond2  log_calorie l(1/2).log_calorie democracy_fh GDP_Growth life_expectancy tfp_growth trade_openness   population_014 population_64 urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64  urban_population population_female, eq(dif)) two h(2)



xtabond2  log_protein l(1/2).log_protein democracy_fh GDP_Growth life_expectancy tfp_growth trade_openness   population_014 population_64  urban_population population_female, gmm(GDP_Growth   life_expectancy tfp_growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64 urban_population population_female, eq(dif)) two h(2)




*****************************************************
* Linear specification with xtgls and tfp_growth
*****************************************************



xtgls   log_protein GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)


xtgls   log_calorie GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female, panels(correlated) corr(ar1)


xtgls   log_foodavailable GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 urban_population population_female, panels(correlated) corr(ar1)



*********************************************************
* Dynamic specification with xtabond2 & Agric_TFP_Growth
**********************************************************



xtabond2  log_foodavailable l.log_foodavailable GDP_Growth life_expectancy Agric_TFP_Growth democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female ,  gmm(GDP_Growth life_expectancy Agric_TFP_Growth, collapse) iv( democracy_fh trade_openness  population_014 population_64 share_arable_land urban_population population_female, eq(dif)) two h(2)


xtabond2  log_calorie l.log_calorie democracy_fh GDP_Growth life_expectancy Agric_TFP_Growth trade_openness   population_014 population_64 urban_population population_female, gmm(GDP_Growth   life_expectancy Agric_TFP_Growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64  urban_population population_female, eq(dif)) two h(2)


xtabond2  log_protein l.log_protein democracy_fh GDP_Growth life_expectancy Agric_TFP_Growth trade_openness   population_014 population_64  urban_population population_female, gmm(GDP_Growth   life_expectancy Agric_TFP_Growth, collapse) iv(democracy_fh  trade_openness   population_014 population_64 urban_population population_female, eq(dif)) two h(2)


*****************************************************
* Linear specification with xtgls and Agric_TFP_Growth
*****************************************************


xtgls   log_protein GDP_Growth life_expectancy Agric_TFP_Growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female , panels(correlated) corr(ar1)


xtgls   log_calorie GDP_Growth life_expectancy Agric_TFP_Growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female , panels(correlated) corr(ar1)


xtgls   log_foodavailable GDP_Growth life_expectancy Agric_TFP_Growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female , panels(correlated) corr(ar1)




*** fixed effect two-way model ******


xtreg  log_foodavailable GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year, fe

reg  log_foodavailable GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year i.COUNTRY_ID 


xtreg  log_calorie  GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year, fe

reg  log_calorie GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year i.COUNTRY_ID 


xtreg  log_protein GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year, fe

reg  log_protein GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female i.year i.COUNTRY_ID 





**************************************************************************
* Linear specification with xtgls and tfp_growth : with two ways effect
**************************************************************************



xtgls   log_foodavailable GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64 urban_population population_female i.year, panels(correlated) corr(ar1)


xtgls   log_calorie GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female i.year, panels(correlated) corr(ar1)


xtgls   log_protein GDP_Growth life_expectancy tfp_growth   democracy_fh  trade_openness   population_014 population_64  urban_population population_female i.year, panels(correlated) corr(ar1)



**************************************
* Distrobution of RSCORES for Protein
**************************************

global Cond if _bx2

rscore log_protein  Agric_TFP_Growth GDP_Growth life_expectancy democracy_fh  trade_openness  population_014 population_64 share_arable_land urban_population population_female , model(re)  xlist(GDP_Growth life_expectancy   democracy_fh  trade_openness   population_014 population_64 share_arable_land urban_population population_female)


***************************************
* IV estimation
***************************************


reg tfp_growth GDP_Growth  life_expectancy  democracy_fh  population_014 population_64 share_arable_land urban_population population_female temperature 

reg Agric_TFP_Growth GDP_Growth life_expectancy  democracy_fh  population_014 population_64 share_arable_land urban_population population_female temperature




reg trade_openness GDP_Growth life_expectancy  democracy_fh    population_014 population_64 share_arable_land urban_population population_female temperature 

predict res_trade, res

*** endogenous test**

reg  log_protein trade_openness GDP_Growth life_expectancy  democracy_fh   population_014 population_64 share_arable_land urban_population population_female temperature res_trade 


reg  log_calorie trade_openness GDP_Growth life_expectancy  democracy_fh   population_014 population_64 share_arable_land urban_population population_female temperature res_trade 


reg  log_foodavailable trade_openness GDP_Growth life_expectancy  democracy_fh   population_014 population_64 share_arable_land urban_population population_female temperature res_trade 


** exogenity test***

reg res_trade GDP_Growth life_expectancy  democracy_fh   population_014 population_64 share_arable_land urban_population population_female temperature


