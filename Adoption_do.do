use "/Users/kogunda/Desktop/Full_Adoption/Adoption_meta_data3.dta", replace

sum
**********************************************************************************



* 1: Generate PCC from data

gen pcc_2 = t_value_impact/(t_value_impact^2 + df)^0.5
sum pcc pcc_2, d
compare pcc pcc_2

* Mostly equal - small differences due to rounding

gen Fisher_Z = 0.5* ln((1+pcc_2)/(1-pcc_2))
sum z_transf Fisher_Z,d 
compare z_transf Fisher_Z
* Mostly equal - small differences due to rounding

gen SE_Fisher_Z = 1/(sample_size-3)^0.5
sum se_z_transf SE_Fisher_Z,d
compare se_z_transf SE_Fisher_Z
* Mostly equal - small differences due to rounding


* Generate SE of PCC_2
gen SE_pcc_2 = ((1-pcc_2^2)/df)^0.5
sum se_pcc SE_pcc_2, d
* Mean and median of se_pcc and Se_PCC_2 are equal
compare se_pcc SE_pcc_2
* mostly equal - small differences due to rounding


* Prescision

gen precision2 = 1/SE_pcc_2
sum inverse_se precision2,d
* Fine

*** USE THE FOLLOWING
*** pcc_2; SE_pcc_2;  precision2;  Fisher_Z; SE_Fisher_Z;  precision_Z 



* 2: FUNNEL GRAPHS  ** WITH outliers - - using PCC_2

* All 
scatter precision2 pcc_2, xline(0.052) msymbol(D) msize(medlarge)

* economic
scatter precision2 pcc_2 if d_economc_measure==1, xline(0.094) msymbol(D) msize(medlarge)

* social
scatter precision2 pcc_2 if d_social_measure==1, xline(0.034) msymbol(D) msize(medlarge)

* productive
scatter precision2 pcc_2 if d_productive_measure==1, xline(0.035) msymbol(D) msize(medlarge)


* 2: FUNNEL GRAPHS  ** WITH outliers - - using Fisers Z

gen precision_Z = 1/SE_Fisher_Z

* All 
scatter precision_Z Fisher_Z, xline(0) msymbol(D) msize(medlarge)

* economic
scatter precision_Z Fisher_Z if d_economc_measure==1, xline(0) msymbol(D) msize(medlarge)

* social
scatter precision_Z Fisher_Z if d_social_measure==1, xline(0) msymbol(D) msize(medlarge)

* productive
scatter precision_Z Fisher_Z if d_productive_measure==1, xline(0) msymbol(D) msize(medlarge)


* Kernel density of pcc_2 (original)
kdensity pcc_2 if d_economc_measure==1

kdensity pcc_2 if d_social_measure==1

kdensity pcc_2 if d_productive_measure==1

** VISUAL RESULTS SO FAR INDICATE: THE 'EFFECT SIZE' in the PRODUCTIVE evidence pool is 
*** smaller that the effects sizes in the economic and socail pools.


** 3: OLS PET/FAT - with PCC
* All
reg t_value_impact precision2
dfbeta
sort _dfbeta_1
* Two observations are outliers

* exclude outliers
reg t_value_impact precision2 if abs(_dfbeta_1)<=1
* No difference!

reg t_value_impact precision2 if d_economc_measure==1 
dfbeta

* Exclude outliers
reg t_value_impact precision2 if d_economc_measure==1 & abs(_dfbeta_2)<=1


reg t_value_impact precision2 if d_social_measure==1 
dfbeta

reg t_value_impact precision2 if d_social_measure==1 & abs(_dfbeta_3)<=1
* Large difference

reg t_value_impact precision2 if d_productive_measure==1 
dfbeta

* Exclude outliers
reg t_value_impact precision2 if d_productive_measure==1 & abs(_dfbeta_4)<=1
* Huge difference - effect insignificant

* Run 3 models and get table
set more off
reg t_value_impact precision2 if d_economc_measure==1 & abs(_dfbeta_2)<=1, vce(cluster study_id)
estimates store economic

reg t_value_impact precision2 if d_social_measure==1 & abs(_dfbeta_3)<=1, vce(cluster study_id)
estimates store social

reg t_value_impact precision2 if d_productive_measure==1 & abs(_dfbeta_4)<=1, vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Inconsistency between productive (no effect) and economic (medium/strong effect.
* Casts doubt about the relaibility of the reported estimates for all 3 outcomes
* I don't mind about this - provided that we are prepared/willing to argue that this litearture is rubbish.
* If we are not prepared/able to do this, then people will say your meta-anal;ysis is rubbish!

* Now Try Fisher_z

gen t_value_pcc2 = pcc_2/SE_pcc_2
compare t_value_impact t_value_pcc2
* 70% equal - difference is very small
* use t-value_impact

gen t_value_Z = Fisher_Z/SE_Fisher_Z
compare t_value_impact t_value_Z
* No equality - difference is substantial 
* Use t_value_Z

set more off 
reg t_value_Z precision_Z if d_economc_measure==1 & abs(_dfbeta_2)<=1, vce(cluster study_id)
estimates store economic

reg t_value_Z precision_Z if d_social_measure==1 & abs(_dfbeta_3)<=1, vce(cluster study_id)
estimates store social

reg t_value_Z precision_Z if d_productive_measure==1 & abs(_dfbeta_4)<=1, vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Only economic_measure is significant.

* Use original t value
set more off
reg t_value_impact precision_Z if d_economc_measure==1 & abs(_dfbeta_2)<=1, vce(cluster study_id)
estimates store economic

reg t_value_impact precision_Z if d_social_measure==1 & abs(_dfbeta_3)<=1, vce(cluster study_id)
estimates store social

reg t_value_impact precision_Z if d_productive_measure==1 & abs(_dfbeta_4)<=1, vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Only economic measures is significant

* Use original t value - with outliers (if any)
set more off 
reg t_value_impact precision_Z if d_economc_measure==1 , vce(cluster study_id)
estimates store economic

reg t_value_impact precision_Z if d_social_measure==1 , vce(cluster study_id)
estimates store social

reg t_value_impact precision_Z if d_productive_measure==1 , vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Only economic measure is significant



* 4: Now try HIERARCHICAL model - EXCLUDING OUTLIERS 
	* 4.1: RANDOM INTERCEPTS ONLY
set more off
mixed t_value_impact precision2 if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id:,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_impact precision2 if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id:,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_impact precision2 if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id:,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Again productive is problematic


	* 4.2: RANDOM INTERCEPTS AND SLOPES
set more off
mixed t_value_impact precision2 if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_impact precision2 if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_impact precision2 if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)

* All significant and Large
* * this spec is prefeable to random intercepts only!
* bUT SEE WHAT HAPPENS WHEN USE fISHER'S z (4.3 AND 4.4 below)


* 4.3 Now try with Fisher's Z and t-Value_Z

mixed t_value_Z precision_Z if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_Z precision_Z if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_Z precision_Z if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Productive not signitficant!!
* results similar OLS with fisher_Z


* 4.4 Now try with Fisher's Z and t-Value_impact

mixed t_value_impact precision_Z if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_impact precision_Z if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_impact precision_Z if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)
* Productive not signitficant !! 
* results similar TO OLS with fisher_Z _ and Mixed with t_value_Z!!!

*///////////////////


* 4.3A


mixed t_value_Z precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year  if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_Z precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_Z precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)




*4.4A




mixed t_value_impact precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year  if d_economc_measure==1 & abs(_dfbeta_2)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store economic

mixed t_value_impact precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year  if d_social_measure==1 & abs(_dfbeta_3)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store social

mixed t_value_impact precision_Z d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year  if d_productive_measure==1 & abs(_dfbeta_4)<=1 || study_id: precision2,  ml /// 
cov(ind) stddeviations vce(cluster study_id)
estimates store productive

estout economic social productive, cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) /// 
stats (N N_clust k_f k_r df_m ll k_rs chi2 p converged ll_c chi2_c p_c) varwidth(25) modelwidth(10)



** statistics

sum d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year 

sum d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year if d_economc_measure==1

sum d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year if d_social_measure==1

sum d_working_paper d_conference_paper d_book_chapter d_thesis d_panel_data d_modern_varieties d_mechanization d_pest_mgt d_agronomic_practices d_experimental d_parametric d_matching d_esr_heckman d_did d_instrument_approach d_kernel d_nneigbour d_crops d_export_products  d_asia d_latin_america d_middle_east data_year if d_productive_measure==1

