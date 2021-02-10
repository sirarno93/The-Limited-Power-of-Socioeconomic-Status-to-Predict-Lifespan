
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

set maxvar  32767  


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


forvalues N = `=Bmin'(1)`=Bmax' {

scalar B = `N'

scalar min = 40
scalar max = 120

*** Denominator ***
{
preserve 

forvalues m = `=min'(1) `=max' {
foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`j'`i' = (abs(Age -`m'))^B * C`j'`i' * `j'`i'
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
foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`j'`i' = (abs(Age -`m'))^B * C`j'`i'*`j'`i'
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

scalar Index_sex_`N' = Numerator_1/Denominator

restore 
}

*** Numerator with one retirement age by percentile ***

preserve 
{
forvalues m = `=min'(1) `=max' {
foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`i'_`j' = (abs(Age -`m'))^B * C`j'`i'*`j'`i'
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

scalar Index_perc_`N' = Numerator_3/Denominator

restore
}

*** Numerator with one retirement age by sex and by percentile ***

preserve
{
forvalues m = `=min'(1) `=max' {
foreach j in F M {
forvalues i = 1(1)100 {
gen P`m'_WeightDeviation`i'_`j' = (abs(Age -`m'))^B * C`j'`i'*`j'`i'
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

scalar Index_perc_sex_`N' = Numerator_4/Denominator


restore
}

}


forvalues i = `=Bmin'(1)`=Bmax' {
dis "Index_sex_`i' est " Index_sex_`i'
dis "Index_perc_`i' est " Index_perc_`i'
dis "Index_perc_sex_`i' est " Index_perc_sex_`i'
}
