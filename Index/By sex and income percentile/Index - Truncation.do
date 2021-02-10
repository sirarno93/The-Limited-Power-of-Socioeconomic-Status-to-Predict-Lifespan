
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

scalar B = 1

drop if Age < 55

scalar min = 40
scalar max = 120

scalar alpha = 0.8

*** Denominator ***

preserve
{
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

*** To know the retirement age ***

forvalues m = `=min'(1) `=max' {
rename S`m'_TotalDeviation Age_`m'
}

gen Retirement_age = "40"
gen D = Age_40

qui foreach v of var Age_40 - Age_120 {
       replace Retirement_age = "`v'" if `v' < D
       replace Retirement_age = Retirement_age + " or `v'" if `v' == D
       replace D = `v' if `v' < D
 }
 
dis as text "With only one retirement age, an error aversion of " as result `=B' as text " and a proportion of life spent working " as result `=alpha' as text ", the social planner would set the retirement age at " as result `=alpha' as text " * " as result Retirement_age[1] as text "."

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

scalar Index_sex = Numerator_1/Denominator

dis Index_sex

*** To know the retirement age by sex ***

foreach j in F M {

forvalues m = `=min'(1) `=max' {
rename S`j'_`m'_TotalDeviation Age_`m'_for_sex_`j' 
}

gen Retirement_age_`j' = "40"
gen D_`j' = Age_40_for_sex_`j' 

qui foreach v of var Age_40_for_sex_`j' - Age_120_for_sex_`j' {
       replace Retirement_age_`j' = "`v'" if `v' < D_`j'
       replace Retirement_age_`j' = Retirement_age_`j' + " or `v'" if `v' == D_`j'
       replace D_`j' = `v' if `v' < D_`j'
 }
 
dis as text "With one retirement age by sex, an error aversion of " as result `=B' as text " and a proportion of life spent working " as result `=alpha' as text ", the social planner would set the retirement age at " as result `=alpha' as text " * " as result Retirement_age_`j'[1] as text "."
}
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

scalar Index_perc = Numerator_3/Denominator

dis Index_perc

*** To know the retirement age by percentile ***

forvalues i = 1(1)100 {

forvalues m = `=min'(1) `=max' {
rename S`i'_`m'_TotalDeviation Age_`m'_for_percentile_`i'
}

gen Retirement_age_`i' = "40"
gen D_`i' = Age_40_for_percentile_`i'

qui foreach v of var Age_40_for_percentile_`i' - Age_120_for_percentile_`i' {
       replace Retirement_age_`i' = "`v'" if `v' < D_`i'
       replace Retirement_age_`i' = Retirement_age_`i' + " or `v'" if `v' == D_`i'
       replace D_`i' = `v' if `v' < D_`i'
 }
 
dis as text "With one retirement age by percentile, an error aversion of " as result `=B' as text " and a proportion of life spent working " as result `=alpha' as text ", the social planner would set the retirement age at " as result `=alpha' as text " * " as result Retirement_age_`i'[1] as text "."
}
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

scalar Index_perc_sex = Numerator_4/Denominator

dis Index_perc_sex

*** To know the retirement age by sex and by percentile ***

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)100 {
foreach j in F M {
drop P`m'_WeightDeviation`i'_`j' 
}
}
}

foreach j in F M {
forvalues i = 1(1)100 {
forvalues m = `=min'(1) `=max' {
rename S`i'_`j'_`m'_TotalDeviation Age_`m'_for_perc_`i'_and_sex_`j'  
}

gen Retirement_age_`i'_`j' = "40"
gen D_`i'_`j' = Age_40_for_perc_`i'_and_sex_`j' 


qui foreach v of var Age_40_for_perc_`i'_and_sex_`j'  - Age_120_for_perc_`i'_and_sex_`j'  {
       replace Retirement_age_`i'_`j' = "`v'" if `v' < D_`i'_`j'
       replace Retirement_age_`i'_`j' = Retirement_age_`i'_`j' + " or `v'" if `v' == D_`i'_`j'
       replace D_`i'_`j' = `v' if `v' < D_`i'_`j'
 }
 
dis as text "With one retirement age by sex & percentile, an error aversion of " as result `=B' as text " and a proportion of life spent working " as result `=alpha' as text ", the social planner would set the retirement age at " as result `=alpha' as text " * " as result Retirement_age_`i'_`j'[1] as text "."

}
}
restore
}

dis Index_sex
dis Index_perc
dis Index_perc_sex

