use "C:\Users\ogund\OneDrive\Desktop\Does\vaccination_panel.dta", replace
clear all
macro drop _all
set more off

*-------------------------------------------------------
***************** Define global parameters*************
*-------------------------------------------------------

* dataset name
global dataSet vaccination_panel
* variable to be studied
global xVar lndose
* label of the variable
global xVarLabel Daily Vaccine Dose
* Names of cross-sectional units
global csUnitName Location2
* time unit identifier
global timeUnit Date

*-------------------------------------------------------
***************** Start log file************************
*-------------------------------------------------------

log using "${dataSet}_clubs.txt", text replace


*-------------------------------------------------------
***************** Import and set dataset  **************
*-------------------------------------------------------

** Load data
use "${dataSet}.dta"

* keep necessary variables
keep id ${csUnitName} ${timeUnit} ${xVar}

* set panel data
xtset id ${timeUnit}

*-------------------------------------------------------
***************** Apply PS convergence test  ***********
*-------------------------------------------------------

* run logt regression
putexcel set "${dataSet}_test.xlsx", sheet(logtTest) replace
    logtreg ${xVar},  kq(0.333)
ereturn list
matrix result0 = e(res)
putexcel A1 = matrix(result0), names nformat("#.##") overwritefmt

* run clustering algorithm
putexcel set "${dataSet}_test.xlsx", sheet(initialClusters) modify
    psecta ${xVar}, name(${csUnitName}) kq(0.333) gen(club_${xVar})
matrix b=e(bm)
matrix t=e(tm)
matrix result1=(b \ t)
matlist result1, border(rows) rowtitle("log(t)") format(%9.3f) left(4)
putexcel A1 = matrix(result1), names nformat("#.##") overwritefmt

* run clustering merge algorithm
putexcel set "${dataSet}_test.xlsx", sheet(mergingClusters) modify
    scheckmerge ${xVar},  kq(0.333) club(club_${xVar})
matrix b=e(bm)
matrix t=e(tm)
matrix result2=(b \ t)
matlist result2, border(rows) rowtitle("log(t)") format(%9.3f) left(4)
putexcel A1 = matrix(result2), names nformat("#.##") overwritefmt

* list final clusters
putexcel set "${dataSet}_test.xlsx", sheet(finalClusters) modify
    imergeclub ${xVar}, name(${csUnitName}) kq(0.333) club(club_${xVar}) gen(finalclub_${xVar})
matrix b=e(bm)
matrix t=e(tm)
matrix result3=(b \ t)
matlist result3, border(rows) rowtitle("log(t)") format(%9.3f) left(4)
putexcel A1 = matrix(result3), names nformat("#.##") overwritefmt

*-------------------------------------------------------
***************** Generate relative variable (for ploting)
*-------------------------------------------------------

** Generate relative variable (useful for ploting)
save "temporary1.dta",replace
use  "temporary1.dta"

collapse ${xVar}, by(${timeUnit})
gen  id=999999
append using "temporary1.dta"
sort id ${timeUnit}

gen ${xVar}_av = ${xVar} if id==999999
bysort ${timeUnit} (${xVar}_av): replace ${xVar}_av = ${xVar}_av[1]
gen re_${xVar} = 1*(${xVar}/${xVar}_av)
label var re_${xVar}  "Relative ${xVar}  (Average=1)"
drop ${xVar}_av
sort id ${timeUnit}

drop if id == 999999
rm "temporary1.dta"

* order variables
order ${csUnitName}, before(${timeUnit})
order id, before(${csUnitName})

* Export data to csv
export delimited using "${dataSet}_clubs.csv", replace
save "${dataSet}_clubs.dta", replace

*-------------------------------------------------------
***************** Plot the clubs  *********************
*-------------------------------------------------------

** All lines

xtline re_${xVar}, overlay legend(off) scale(1.6)  ytitle("${xVarLabel}", size(small)) yscale(lstyle(none)) ylabel(, noticks labcolor(gs10)) xscale(lstyle(none)) xlabel(, noticks labcolor(gs10))  xtitle("") name(allLines, replace)

graph save   "${dataSet}_allLines.gph", replace
graph export "${dataSet}_allLines.pdf", replace

** Indentified Clubs

summarize finalclub_${xVar}
return list
scalar nunberOfClubs = r(max)

forval i=1/`=nunberOfClubs' {
    xtline re_${xVar} if finalclub_${xVar} == `i', overlay title("Club `i'", size(small)) legend(off) scale(1.5) yscale(lstyle(none))  ytitle("${xVarLabel}", size(small)) ylabel(, noticks labcolor(gs10)) xtitle("") xscale(lstyle(none)) xlabel(, noticks labcolor(gs10))  name(club`i', replace)
    local graphs `graphs' club`i'
}
graph combine `graphs', ycommon
graph save   "${dataSet}_clubsLines.gph", replace
graph export "${dataSet}_clubsLines.pdf", replace

** Within-club averages

collapse (mean) re_${xVar}, by(finalclub_${xVar} ${timeUnit})
xtset finalclub_${xVar} ${timeUnit}
rename finalclub_${xVar} Club
xtline re_${xVar}, overlay scale(1.6) ytitle("${xVarLabel}", size(small)) yscale(lstyle(none)) ylabel(, noticks labcolor(gs10)) xscale(lstyle(none)) xlabel(, noticks labcolor(gs10))  xtitle("") name(clubsAverages, replace)

graph save   "${dataSet}_clubsAverages.gph", replace
graph export "${dataSet}_clubsAverages.pdf", replace

clear
use "${dataSet}_clubs.dta"

*-------------------------------------------------------
***************** Export list of clubs  ****************
*-------------------------------------------------------

summarize ${timeUnit}
scalar finalYear = r(max)
keep if ${timeUnit} == `=finalYear'

keep id ${csUnitName} finalclub_${xVar}
sort finalclub_${xVar} ${csUnitName}
export delimited using "${dataSet}_clubsList.csv", replace

*-------------------------------------------------------
***************** Close log file*************
*-------------------------------------------------------

log close

************************************************************************************
*****************************
************************************************************************************
xtset Location2 Date

lndose

gen DiffDose=d.lndose
gen lagDose=l.lndose

** beta-convergence***

xtreg DiffDose lagDose, re
xtreg DiffDose lagDose, fe


xtmg DiffDose lagDose, res(eMG)
xtmg DiffGINI_DISP lag_GINI_DISP, cce res(eCMGt)
drop eMG eCMGt

xtmg DiffGINI_MKT lag_GINI_MKT, res(eMG)
xtmg DiffGINI_MKT lag_GINI_MKT, cce res(eCMGt)
drop eMG eCMGt



xtgls DiffGINI_DISP lag_GINI_DISP, panels(correlated) corr(ar1)
xtgls DiffGINI_MKT lag_GINI_MKT, panels(correlated) corr(ar1)



** sigma convergence***


egen SD_DOSE = sd(lndose ), by ( Date)

qbys Location2  Date: egen meanDOSE = mean( lndose )

gen CV_DOSE= SD_DOSE/ meanDOSE



xtgls CV_DOSE  Date, panels(correlated) corr(ar1)

xtreg CV_DOSE  Date, fe
xtreg CV_DOSE  Date, re



** plots***

graph bar (mean) Administered_Daily , over( id )

boxpanel Administered_Daily  Date

