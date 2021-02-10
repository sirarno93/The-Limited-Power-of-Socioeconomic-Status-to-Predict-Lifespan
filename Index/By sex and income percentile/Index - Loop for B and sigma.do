
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
clear all
set more off

set maxvar 32767  


import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By income percentile and sex\Distribution - Chetty technique.xlsx", sheet("Sheet1") cellrange(A1:OJ81) firstrow clear


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

scalar Bmin = 1
scalar Bmax = 10
scalar Binterval = 1

scalar smin = 0
scalar smax = 100
scalar sinterval = 25

***!!! smax, smin and () in the loop should be an integer; otherwise problem

forvalues N = `=Bmin'(`=Binterval')`=Bmax' {

scalar B = `N'

scalar min = 40
scalar max = 120

forvalues s = `=smin'(`=sinterval')`=smax'{

scalar s = (`s'/100)

*For the name of the index defined after s should be an integer; so it is why it is not defined as 1.5 directly

*** Denominator ***

preserve
{
forvalues m = `=min'(1) `=max' {
gen P`m'_Deviation = (abs(Age -`m'))^B
replace P`m'_Deviation = s*((abs(Age -`m'))^B) if Age > `m'

foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`j'`i' = P`m'_Deviation * C`j'`i' * `j'`i'
}
}
}

forvalues m = `=min'(1) `=max' {
egen P`m'_RowTotalDeviation = rowtotal(P`m'_WeightDeviation*)
}

forvalues m = `=min'(1) `=max' {
egen S`m'_TotalDeviation = total(P`m'_RowTotalDeviation)
}

egen Denominat = rowmin(S*)

scalar Denominator = Denominat[1]

restore
}

*** Numerator with one retirement age by sex ***

preserve 
{

forvalues m = `=min'(1) `=max' {
gen P`m'_Deviation = (abs(Age -`m'))^B
replace P`m'_Deviation = s*((abs(Age -`m'))^B) if Age > `m'

foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`j'`i' =  P`m'_Deviation  * C`j'`i'*`j'`i'
}
}
}

foreach j in F M {
forvalues m = `=min'(1) `=max' {
egen P`m'_RowTotalDeviation`j' = rowtotal(P`m'_WeightDeviation`j'*)
}
}

foreach j in F M {
forvalues m = `=min'(1) `=max' {
egen S`j'_`m'_TotalDeviation = total(P`m'_RowTotalDeviation`j')
}
}

egen Numerator_F = rowmin(SF*)
egen Numerator_M = rowmin(SM*)

scalar Numerator_1 = Numerator_F[1] + Numerator_M[1]

scalar Index_sex_N`N'_s`s' = Numerator_1/Denominator

restore 
}

*** Numerator with one retirement age by percentile ***

preserve 
{
forvalues m = `=min'(1) `=max' {
gen P`m'_Deviation = (abs(Age -`m'))^B
replace P`m'_Deviation = s*((abs(Age -`m'))^B) if Age >`m'

foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`i'_`j' = P`m'_Deviation * C`j'`i'*`j'`i'
}
}
}

forvalues i = 1(1)100 {
forvalues m = `=min'(1) `=max' {
egen P`m'_RowTotalDeviation`i' = rowtotal(P`m'_WeightDeviation`i'_*)
}
}

{
***Need place to add more variables -> delete old ones
forvalues m = `=min'(1) `=max' {
foreach j in F M {
forvalues i = 1(1)100 {
drop P`m'_WeightDeviation`i'_`j' 
}
}
}
}

forvalues i = 1(1)100 {
forvalues m = `=min'(1) `=max' {
egen S`i'_`m'_TotalDeviation = total(P`m'_RowTotalDeviation`i')
}
}

forvalues i = 1(1)100 {
egen Numerator_perc`i' = rowmin(S`i'_*)
}

egen Numerator_percentile = rowtotal(Numerator_perc*)

scalar Numerator_3 = Numerator_percentile[1]

scalar Index_perc_N`N'_s`s' = Numerator_3/Denominator

restore
}

*** Numerator with one retirement age by sex and by percentile ***

preserve
{
forvalues m = `=min'(1) `=max' {
gen P`m'_Deviation = (abs(Age -`m'))^B
replace P`m'_Deviation = s*((abs(Age -`m'))^B) if Age > `m'

foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`i'_`j' = P`m'_Deviation  * C`j'`i'*`j'`i'
}
}
}

{
***Need place for more variables -> delete old ones
foreach j in F M {
forvalues i = 1(1)100 {
drop C`j'`i' `j'`i'
}
}
}

forvalues i = 1(1)100 {
foreach j in F M {
forvalues m = `=min'(1) `=max' {
egen S`i'_`j'_`m'_TotalDeviation = total(P`m'_WeightDeviation`i'_`j')
}
}
}

foreach j in F M {
forvalues i = 1(1)100 {
egen Numerator_perc`i'_`j' = rowmin(S`i'_`j'*)
}
}

egen Numerator_perc_sex = rowtotal(Numerator_perc*)

scalar Numerator_4 = Numerator_perc_sex[1]

scalar Index_perc_sex_N`N'_s`s' = Numerator_4/Denominator

restore
}
}
}


forvalues N = `=Bmin'(`=Binterval')`=Bmax' {

forvalues s = `=smin'(`=sinterval')`=smax'{

dis "Index_sex_B`N'_s`s' est " Index_sex_N`N'_s`s'
dis "Index_perc_B`N'_s`s' est " Index_perc_N`N'_s`s' 
dis "Index_perc_sex_B`N'_s`s' est " Index_perc_sex_N`N'_s`s'
}
}
