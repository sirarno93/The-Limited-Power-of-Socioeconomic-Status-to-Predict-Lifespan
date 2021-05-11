
*************************************************************************************************************
*																											*
* 	 ***Should we differentiate the retirement age by socioeconoic status? A tagging problem*** 			*
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

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By state, income quartile and sex\Distribution - Chetty technique.xlsx", sheet("Sheet1") cellrange(A1:AEJ81) firstrow clear

forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
egen TQ`i'`j'`k' = total(Q`i'`j'`k')
gen Q`i'`j'`k'b = Q`i'`j'`k'/TQ`i'`j'`k'
drop Q`i'`j'`k'
rename Q`i'`j'`k'b Q`i'`j'`k'
}
}
}

drop T*

gen Age = 39+[_n]

scalar B = 1

scalar min = 50
scalar max = 100


///withdraw * to the one you want 

***concave
*gen Age_ind = round(-10+10*sqrt(-23+Age))
***convexe
*gen Age_ind = round(exp(Age/22.5)+30) if Age <= 80
*replace Age_ind = round(exp(Age/30)+50.5) if Age > 80

 
*** Denominator ***

preserve
{
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen MQ`i'`j'`k' = CQ`i'`j'`k' * Q`i'`j'`k'
drop CQ`i'`j'`k'   Q`i'`j'`k'
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen P`m'_WeightDeviation`i'`j'`k' = (abs(Age_ind -`m'))^B * MQ`i'`j'`k' 
}
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


*** Numerator with one retirement age by state ***

preserve 
{
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen MQ`i'`j'`k' = CQ`i'`j'`k' * Q`i'`j'`k'
drop CQ`i'`j'`k'   Q`i'`j'`k'
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen P`m'_WeightDeviation`k'_`j'`i' = (abs(Age_ind -`m'))^B * MQ`i'`j'`k' 
}
}
}
}

foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
forvalues m = `=min'(1) `=max' {
egen P`m'_RowTotalDeviation`k' = rowtotal(P`m'_WeightDeviation`k'_*)
}
}

foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
forvalues m = `=min'(1) `=max' {
egen S`k'_`m'_TotalDeviation = total(P`m'_RowTotalDeviation`k')
}
}

foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
egen Numerator_`k' = rowmin(S`k'_*)
}

egen Total_numerator = rowtotal(Numerator_*)

scalar Numerator_state = Total_numerator

scalar Index_state = Numerator_state/Denominator

dis Index_state

*** To know the retirement age by sex ***

foreach j of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 

forvalues m = `=min'(1) `=max' {
rename S`j'_`m'_TotalDeviation Age_`m'_for_state_`j' 
}

gen Retirement_age_`j' = " `=min' "
gen D_`j' = Age_`=min'_for_state_`j' 

qui foreach v of var Age_`=min'_for_state_`j' - Age_`=max'_for_state_`j' {
       replace Retirement_age_`j' = "`v'" if `v' < D_`j'
       replace Retirement_age_`j' = Retirement_age_`j' + " or `v'" if `v' == D_`j'
       replace D_`j' = `v' if `v' < D_`j'
 }
 
dis as text "With one retirement age by state, an error aversion of " as result `=B' as text ", the social planner would set the retirement age at " as result    Retirement_age_`j'[1] as text "."
}
restore 
}

*** Numerator with one retirement age by state and by sex ***

preserve 
{
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen MQ`i'`j'`k' = CQ`i'`j'`k' * Q`i'`j'`k'
drop CQ`i'`j'`k'   Q`i'`j'`k'
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen P`m'_WeightDeviation`k'_`j'`i' = (abs(Age_ind -`m'))^B * MQ`i'`j'`k' 
}
}
}
}

foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
forvalues m = `=min'(1) `=max' {
egen P`m'_RowTotalDeviation`k'`j' = rowtotal(P`m'_WeightDeviation`k'_`j'*)
}
}
}

foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
forvalues m = `=min'(1) `=max' {
egen S`k'`j'_`m'_TotalDeviation = total(P`m'_RowTotalDeviation`k'`j')
}
}
}

foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
egen Numerator_`k'`j' = rowmin(S`k'`j'_*)
}
}

egen Total_numerator = rowtotal(Numerator_*)

scalar Numerator_state_sex = Total_numerator

scalar Index_state_sex = Numerator_state_sex/Denominator

dis Index_state_sex

*** To know the retirement age by sex and by state ***

foreach s in F M {
foreach j of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 

forvalues m = `=min'(1) `=max' {
rename S`j'`s'_`m'_TotalDeviation Age_`m'_for_state_`j'_and_sex_`s' 
}

gen Retirement_age_`j'_`s' = " `=min' "
gen D_`j'_`s' = Age_`=min'_for_state_`j'_and_sex_`s'

qui foreach v of var Age_`=min'_for_state_`j'_and_sex_`s' - Age_`=max'_for_state_`j'_and_sex_`s' {
       replace Retirement_age_`j'_`s' = "`v'" if `v' < D_`j'_`s'
       replace Retirement_age_`j'_`s' = Retirement_age_`j'_`s' + " or `v'" if `v' == D_`j'_`s'
       replace D_`j'_`s' = `v' if `v' < D_`j'_`s'
 }
 
dis as text "With one retirement age by state and by sex, an error aversion of " as result `=B'   as text ", the social planner would set the retirement age at "  as result Retirement_age_`j'_`s'[1] as text "."
}
}
restore 
}

*** Numerator with one retirement age by state, by quartile and by sex ***

preserve 
{
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen MQ`i'`j'`k' = CQ`i'`j'`k' * Q`i'`j'`k'
drop CQ`i'`j'`k'   Q`i'`j'`k'
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
gen P`m'_WeightDeviation`k'_`j'`i'_ = (abs(Age_ind -`m'))^B * MQ`i'`j'`k' 
}
}
}
}

***need more place to add variables -> delete old ones
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
drop MQ`i'`j'`k' 
}
}
}

forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
forvalues m = `=min'(1) `=max' {
egen S`k'`j'`i'_`m'_TotalDeviation = total(P`m'_WeightDeviation`k'_`j'`i'_)
drop P`m'_WeightDeviation`k'_`j'`i'_
}
}
}
}

forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
egen Numerator_`k'`j'`i' = rowmin(S`k'`j'`i'_*)
}
}
}

egen Total_numerator = rowtotal(Numerator_*)

scalar Numerator_state_sex_quart = Total_numerator

scalar Index_state_sex_quart = Numerator_state_sex_quart/Denominator

dis Index_state_sex_quart

*** To know the retirement age by state, quartile and sex ***

forvalues q = 1(1)4{
foreach s in F M {
foreach j of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 

forvalues m = `=min'(1) `=max' {
rename S`j'`s'`q'_`m'_TotalDeviation Age_`m'_state_`j'_sex_`s'_quart_`q' 
}

gen Retirement_age_`j'_`s'_`q' = " `=min' "
gen D_`j'_`s'_`q' = Age_`=min'_state_`j'_sex_`s'_quart_`q'

qui foreach v of var Age_`=min'_state_`j'_sex_`s'_quart_`q' - Age_`=max'_state_`j'_sex_`s'_quart_`q' {
       replace Retirement_age_`j'_`s'_`q'  = "`v'" if `v' < D_`j'_`s'_`q' 
       replace Retirement_age_`j'_`s'_`q'  = Retirement_age_`j'_`s'_`q'  + " or `v'" if `v' == D_`j'_`s'_`q' 
       replace D_`j'_`s'_`q'  = `v' if `v' < D_`j'_`s'_`q' 
 }
 
dis as text "With one retirement age by state, by quartile and by sex, an error aversion of " as result `=B' as text ", the social planner would set the retirement age at "  as result Retirement_age_`j'_`s'_`q'[1] as text "."
}
}
}
restore 
}

dis Index_state
dis Index_state_sex
dis Index_state_sex_quart