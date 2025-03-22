

** effect of SEGAP***

** White_black gap***

reg gcs_mn_wbg rural suburb town perfl perrl perell perspeced perblk single_momblk baplusblk snapblk povertyblk unempblk seswhtblk i.year i.sedafipsname2 
mixed gcs_mn_wbg rural suburb town perfl perrl perell perspeced perblk  single_momblk baplusblk snapblk povertyblk unempblk seswhtblk || sedafipsname2:  || year:


reg gcs_mn_wbg rural suburb town perfrl perell perspeced perblk single_momblk baplusblk povertyblk unempblk seswhtblk i.year i.sedafipsname2 
mixed gcs_mn_wbg rural suburb town perfrl perell perspeced perblk single_momblk baplusblk povertyblk unempblk seswhtblk || sedafipsname2:  || year:


corr rural suburb town perfrl perell perspeced perblk single_momblk baplusblk povertyblk unempblk seswhtblk

corr seswhtblk unempblk povertyblk baplusblk single_momblk perblk perfrl perell perspeced rural suburb town


**White_Asian gap***

reg gcs_mn_wag rural suburb town perfl perrl perell perspeced perasn  single_momasn baplusasn snapasn povertyasn unempasn seswhtasn i.year i.sedafipsname2 
mixed gcs_mn_wag rural suburb town perfl perrl perell perspeced perasn single_momasn baplusasn snapasn povertyasn unempasn seswhtasn || sedafipsname2:  || year:


reg gcs_mn_wag rural suburb town perfrl perell perspeced perasn  single_momasn baplusasn povertyasn unempasn seswhtasn i.year i.sedafipsname2 
mixed gcs_mn_wag rural suburb town perfrl perell perspeced perasn  single_momasn baplusasn povertyasn unempasn seswhtasn || sedafipsname2:  || year:


corr rural suburb town perfrl perell perspeced perasn  single_momasn baplusasn povertyasn unempasn seswhtasn

corr seswhtasn unempasn povertyasn baplusasn single_momasn  perasn perfrl perell perspeced rural suburb town

**White_Hispanic gap**

reg gcs_mn_whg rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seswhthsp i.year i.sedafipsname2 
mixed gcs_mn_whg rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seswhthsp || sedafipsname2:  || year:


reg gcs_mn_whg rural suburb town perfrl perell perspeced perhsp single_momhsp baplushsp povertyhsp unemphsp seswhthsp i.year i.sedafipsname2 
mixed gcs_mn_whg rural suburb town perfrl perell perspeced perhsp single_momhsp baplushsp povertyhsp unemphsp seswhthsp || sedafipsname2:  || year:

corr rural suburb town perfrl perell perspeced perhsp single_momhsp baplushsp povertyhsp unemphsp seswhthsp


corr seswhthsp unemphsp povertyhsp baplushsp single_momhsp perhsp perfrl perell perspeced rural suburb town 


**White_Native American gap**

reg gcs_mn_wng rural suburb town perfl perrl perell perspeced pernam single_momnam baplusnam snapnam povertynam unempnam seswhtnam i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced pernam single_momnam baplusnam snapnam povertynam unempnam seswhtnam || sedafipsname2:  || year:



reg gcs_mn_wng rural suburb town perfl perell perspeced pernam single_momnam baplusnam povertynam unempnam seswhtnam i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perell perspeced pernam single_momnam baplusnam  povertynam unempnam seswhtnam || sedafipsname2:  || year:

corr rural suburb town perfl perell perspeced pernam single_momnam baplusnam povertynam unempnam seswhtnam


sum rural suburb town perfl perrl perell perspeced perblk single_momblk baplusblk snapblk povertyblk unempblk seswhtblk perasn  single_momasn baplusasn snapasn povertyasn unempasn seswhtasn perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seswhthsp pernam single_momnam baplusnam snapnam povertynam unempnam seswhtnam


sum gcs_mn_wbg gcs_mn_wag gcs_mn_whg gcs_mn_wng


** effect of SES**

** White_black gap***

reg gcs_mn_wbg rural suburb town perfl perrl perell perspeced perblk single_momblk baplusblk snapblk povertyblk unempblk sesblk i.year i.sedafipsname2 
mixed gcs_mn_wbg rural suburb town perfl perrl perell perspeced perblk  single_momblk baplusblk snapblk povertyblk unempblk sesblk || sedafipsname2:  || year:

**White_Asian gap***

reg gcs_mn_wag rural suburb town perfl perrl perell perspeced perasn  single_momasn baplusasn snapasn povertyasn unempasn sesasn i.year i.sedafipsname2 
mixed gcs_mn_wag rural suburb town perfl perrl perell perspeced perasn single_momasn baplusasn snapasn povertyasn unempasn sesasn || sedafipsname2:  || year:


**White_Hispanic gap**

reg gcs_mn_whg rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seshsp i.year i.sedafipsname2 
mixed gcs_mn_whg rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seshsp || sedafipsname2:  || year:


**White_Native American gap**

reg gcs_mn_wng rural suburb town perfl perrl perell perspeced pernam single_momnam baplusnam snapnam povertynam unempnam sesnam i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced pernam single_momnam baplusnam snapnam povertynam unempnam sesnam || sedafipsname2:  || year:

histogram gcs_mn_wbg, addplot (kdensity gcs_mn_wbg)   xtitle("White-Black Achievement Gap") ytitle("Frequency")
histogram gcs_mn_wag
histogram gcs_mn_whg
histogram gcs_mn_wng


hist gcs_mn_wbg, frequency xtitle("White-Black Achievement Gap") ytitle("Frequency")
hist gcs_mn_wag, frequency xtitle("White-Asian Achievement Gap") ytitle("Frequency")
hist gcs_mn_whg, frequency xtitle("White-Hispanic Achievement Gap") ytitle("Frequency")


kdensity gcs_mn_wbg
kdensity gcs_mn_wag
kdensity gcs_mn_whg

sum gcs_mn_wht gcs_mn_blk gcs_mn_asn gcs_mn_hsp gcs_mn_nam

histogram gcs_mn_wht, normal 
histogram gcs_mn_blk, normal 
histogram gcs_mn_asn, normal 
histogram gcs_mn_hsp, normal 
histogram gcs_mn_nam, normal 

npregress kernel gcs_mn_wbg seswhtblk, vce(bootstrap, reps(100) seed(123))
npgraph


graph hbox gcs_mn_wbg gcs_mn_wag gcs_mn_whg gcs_mn_wng


** lorez curve**
**whit_black**
lorenz estimate gcs_mn_wbg
lorenz graph, aspectratio(1) xlabel(, grid)

**whit_Asian**
lorenz estimate gcs_mn_wag
lorenz graph, aspectratio(1) xlabel(, grid)

**whit_Hispanic**
lorenz estimate gcs_mn_whg
lorenz graph, aspectratio(1) xlabel(, grid)

**whit_Native American**
lorenz estimate gcs_mn_wng
lorenz graph, aspectratio(1) xlabel(, grid)

** White achievement***

reg gcs_mn_wht rural suburb town perfl perrl perell perspeced perwht single_momwht bapluswht snapwht povertywht unempwht seswht i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced perwht single_momwht bapluswht snapwht povertywht unempwht seswht  || sedafipsname2:  || year:


** Black achievement***

reg gcs_mn_blk rural suburb town perfl perrl perell perspeced perblk single_momblk baplusblk snapblk povertyblk unempblk sesblk i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced perblk single_momblk baplusblk snapblk povertyblk unempblk sesblk  || sedafipsname2:  || year:


** Asian achievement***

reg gcs_mn_asn rural suburb town perfl perrl perell perspeced perasn  single_momasn baplusasn snapasn povertyasn unempasn sesasn i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced perasn  single_momasn baplusasn snapasn povertyasn unempasn sesasn  || sedafipsname2:  || year:


** Hispanic achievement***

reg gcs_mn_hsp rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seshsp i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced perhsp single_momhsp baplushsp snaphsp povertyhsp unemphsp seshsp  || sedafipsname2:  || year:


** Native American achievement***

reg gcs_mn_nam rural suburb town perfl perrl perell perspeced pernam  single_momnam baplusnam snapnam povertynam unempnam sesnam i.year i.sedafipsname2 
mixed gcs_mn_wng rural suburb town perfl perrl perell perspeced pernam  single_momnam baplusnam snapnam povertynam unempnam sesnam  || sedafipsname2:  || year:


**************************
*******GENDER ANALYSIS****
**************************

** Estimated Male-Female Gap Estimate**

mixed gcs_mn_mfg rural suburb town perell perspeced  single_momall baplusall  povertyall unempall seswht sesblk seshsp sesasn || sedafipsname2:  || year: 

mixed gcs_mn_mfg rural suburb town perell perspeced  single_momall baplusall  povertyall unempall seswht sesblk seshsp sesasn || sedafipsname2:  || year: if subject2==1

mixed gcs_mn_mfg rural suburb town perell perspeced  single_momall baplusall  povertyall unempall seswht sesblk seshsp sesasn || sedafipsname2:  || year: if subject2==2



**female achievement**

mixed gcs_mn_fem rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year:

mixed gcs_mn_fem rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year: if subject2==1


mixed gcs_mn_fem rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year: if subject2==2

**male achievement**

mixed gcs_mn_mal  rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year:

mixed gcs_mn_mal  rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year: if subject2==1

mixed gcs_mn_mal  rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year: if subject2==2

*** Estimated Non-ECD-ECD Gap Estimate***

***Econ Disadvantaged (ECD)****

mixed gcs_mn_neg  rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn  || sedafipsname2:  || year:


sum gcs_mn_mfg gcs_mn_fem gcs_mn_mal rural suburb town perell perspeced single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn


corr rural suburb town perell perspeced  single_momall baplusall povertyall unempall seswht sesblk seshsp sesasn


graph hbox gcs_mn_mfg gcs_mn_fem gcs_mn_mal


graph box gcs_mn_mfg gcs_mn_fem gcs_mn_mal



histogram gcs_mn_mfg, addplot (kdensity gcs_mn_mfg)  xtitle("Male-Female Achievement Gap") 


histogram gcs_mn_mfg, addplot (kdensity gcs_mn_mfg)  xtitle("Male-Female Achievement Gap")  by(subject)


histogram gcs_mn_fem, addplot (kdensity gcs_mn_fem)  xtitle("Female Achievement") 

histogram gcs_mn_mal, addplot (kdensity gcs_mn_mal)  xtitle("Male Achievement") 


histogram gcs_mn_fem, addplot (kdensity gcs_mn_fem)  xtitle("Female Achievement")   by(subject)

histogram gcs_mn_mal, addplot (kdensity gcs_mn_mal)  xtitle("Male Achievement")   by(subject)


***pooled2***

reg gcs_mn_all gcs_mn_wht gcs_mn_blk gcs_mn_asn gcs_mn_hsp gcs_mn_nam rural suburb town perfl perrl perell perspeced  single_momall baplusall snapall povertyall unempall sesall i.year i.sedafipsname2 


** lorez curve**
**white_black**
lorenz estimate gcs_mn_wht
lorenz graph, aspectratio(1) xlabel(, grid)

**white_Asian**
lorenz estimate gcs_mn_asn
lorenz graph, aspectratio(1) xlabel(, grid)

**white_Hispanic**
lorenz estimate gcs_mn_hsp
lorenz graph, aspectratio(1) xlabel(, grid)

**white_Native American**
lorenz estimate gcs_mn_nam
lorenz graph, aspectratio(1) xlabel(, grid)



sum rural suburb town perfl perrl perell perspeced perwht single_momwht bapluswht snapwht povertywht unempwht seswht














