
*************************************************************************************************************
*																											*
* 	 ***The limited power of socioeconomics status to predict lifespan: Implications for pension policy*** 	*
*																											*
*							***IRES, UCLouvain, Belgium***													*
*																											*
*						         ***Arno Baurin***															*
*																											*
*					       ***arno.baurin@uclouvain.be***													*
*																											*
*************************************************************************************************************	
***Formulas:
*https://pophealthmetrics.biomedcentral.com/articles/10.1186/1478-7954-10-3#Sec13
*Additional file 1: The file contains the following: Methods for the calculation and decomposition of Theil's index and the variance in lifespan variation, full results using the variance measure, and results comparing the usage of linked and unlinked Lithuanian data. (DOC 79 KB)

clear all
set more off

set maxvar 32767  

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By income percentile and sex\Distribution - Chetty technique.xlsx", sheet("Sheet1") cellrange(A1:OJ81) firstrow

foreach j in F M {
forvalues i = 1(1)100 {
egen T`j'`i' = total(`j'`i')
gen `j'`i'b = `j'`i'/T`j'`i'
drop `j'`i'
rename `j'`i'b `j'`i'
}  
}

drop T*

gen Age = 39+[_n]

foreach j in F M {
forvalues i = 1(1)100 {
gen Population_`j'`i' = C`j'`i' * `j'`i'
}
}

*******************Indice Theil**************

egen l_a = rowtotal(CF1-CM100)
scalar la = l_a

egen Tot_pop = rowtotal(Population_F1 - Population_M100)
replace Tot_pop =round(Tot_pop)
su Age [fweight = Tot_pop]
gen ea = r(mean)

gen xx = Age + 0.5
gen xx_ea = xx/ea
gen ln_xx_ea = ln(xx_ea)

gen dx = Tot_pop

gen step1 = dx * (xx_ea * ln_xx_ea)
egen total = total(step1)
gen T = total/la
gen T100 = T*100

dis T100 

******************Between***********************

***w
foreach j in F M {
forvalues i = 1(1)100 {
egen Tot_pop_`j'`i' = total(Population_`j'`i')
}
}

egen Tot_pop2 = total(Tot_pop)

foreach j in F M {
forvalues i = 1(1)100 {
gen W_`j'`i' = Tot_pop_`j'`i'/Tot_pop2
}
}


***ei 

foreach j in F M {
forvalues i = 1(1)100 {
replace Population_`j'`i' = round(Population_`j'`i')
su Age [fweight = Population_`j'`i']
gen ea_`j'`i' = r(mean)
}
}

foreach j in F M {
forvalues i = 1(1)100 {
gen ea_`j'`i'_ea = ea_`j'`i'/ea
}
}

foreach j in F M {
forvalues i = 1(1)100 {
gen ln_ea_`j'`i'_ea = ln(ea_`j'`i'_ea)
}
}


foreach j in F M {
forvalues i = 1(1)100 {
gen step1_`j'`i' = W_`j'`i' * ea_`j'`i'_ea * ln_ea_`j'`i'_ea 
}
}

egen Between = rowtotal(step1_F1-step1_M100)
gen Bet100 = Between * 100

dis Bet100

*** *****************Within *** *****************

foreach j in F M {
forvalues i = 1(1)100 {

gen l_a`j'`i' = C`j'`i'

replace Population_`j'`i' = round(Population_`j'`i')
su Age [fweight = Population_`j'`i']
gen ea`j'`i' = r(mean)

gen xx_ea`j'`i' = xx/ea`j'`i'
gen ln_xx_ea`j'`i' = ln(xx_ea`j'`i')

gen dx`j'`i' = Population_`j'`i'

gen step1`j'`i' = dx`j'`i' * (xx_ea`j'`i' * ln_xx_ea`j'`i')
egen total`j'`i' = total(step1`j'`i')
gen T`j'`i' = total`j'`i'/l_a`j'`i'
gen T100`j'`i' = T*100
}
}

foreach j in F M {
forvalues i = 1(1)100 {
gen step3`j'`i' = W_`j'`i'  * T`j'`i' * ea_`j'`i'_ea
}
}

egen Within = rowtotal(step3F1-step3M100)
gen With100 = Within * 100

dis With100

scalar BG = (Bet100/T100)*100
scalar WG = (With100/T100)*100

****************************************************

dis as text "The between component represents " as result "`=BG'" as text "% and the within group represents " as result "`=WG'" as text " %."
dis T100
dis Bet100
dis With100