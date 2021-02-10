
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

*******************Variance Total**************

egen l_a = rowtotal(CF1-CM100)
scalar la = l_a


egen Tot_pop = rowtotal(Population_F1 - Population_M100)
replace Tot_pop =round(Tot_pop)
su Age [fweight = Tot_pop]
scalar ea = r(mean)

gen step1 = Tot_pop*(Age-ea)^2
egen total = total(step1)
gen v = total/la

dis v 

***or more simply:***
*su Age [fweight = Tot_pop]
*dis r(Var)

******************Between***********************

foreach j in F M {
forvalues i = 1(1)100 {
egen Tot_pop_`j'`i' = total(Population_`j'`i')
scalar la_`j'`i' = Tot_pop_`j'`i'
}
}

foreach j in F M {
forvalues i = 1(1)100 {
replace Population_`j'`i' = round(Population_`j'`i')
su Age [fweight = Population_`j'`i']
scalar ea_`j'`i' = r(mean)
}
}

foreach j in F M {
forvalues i = 1(1)100 {
gen step1_`j'`i' = la_`j'`i' * (ea_`j'`i'-ea)^2
}
}

egen Sum = rowtotal(step1_F1-step1_M100)

gen between = Sum/la

dis between

*** *****************Within *** *****************

foreach j in F M {
forvalues i = 1(1)100 {
replace Population_`j'`i' = round(Population_`j'`i')
su Age [fweight = Population_`j'`i']
scalar var_`j'`i' = r(Var)
}
}

egen Tot_pop2 = total(Tot_pop)

foreach j in F M {
forvalues i = 1(1)100 {
gen Part_Pop_`j'`i' = Tot_pop_`j'`i'/Tot_pop2
}
}


foreach j in F M {
forvalues i = 1(1)100 {
gen Var_`j'`i' =  Part_Pop_`j'`i'  * var_`j'`i' 
}
}

egen within = rowtotal(Var_*)

scalar BG = (between/v)*100
scalar WG = (within/v)*100

****************************************************

dis as text "The between component represents " as result "`=BG'" as text "% and the within group represents " as result "`=WG'" as text " %."