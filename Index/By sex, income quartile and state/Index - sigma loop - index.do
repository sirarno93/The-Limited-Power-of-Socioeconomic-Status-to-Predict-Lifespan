
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

scalar Bmin = 5
scalar Bmax = 5
scalar Binterval = 1

scalar smin = 0
scalar smax = 100
scalar sinterval = 25

***!!! smax, smin and () in the loop should be an integer; otherwise problem

forvalues N = `=Bmin'(`=Binterval')`=Bmax' {

scalar B = `N'

scalar min = 40
scalar max = 90
scalar alpha = 0.8

forvalues s = `=smin'(`=sinterval')`=smax'{

scalar s = (`s'/100)

*For the name of the index defined after s should be an integer; so it is why it is not defined as 1.5 directly


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
gen  P`m'_WeightDeviation`i'`j'`k' = (abs(Age -`m'))^B * MQ`i'`j'`k' 
}
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
qui replace P`m'_WeightDeviation`i'`j'`k' = s * P`m'_WeightDeviation`i'`j'`k' if Age > `m'
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
gen P`m'_WeightDeviation`k'_`j'`i' = (abs(Age -`m'))^B * MQ`i'`j'`k' 
}
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
qui replace P`m'_WeightDeviation`k'_`j'`i' = s * P`m'_WeightDeviation`k'_`j'`i' if Age > `m' 
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

scalar Index_state_N`N'_s`s' = Numerator_state/Denominator

 
 
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
gen P`m'_WeightDeviation`k'_`j'`i' =  (abs(Age -`m'))^B * MQ`i'`j'`k'  
}
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
qui replace P`m'_WeightDeviation`k'_`j'`i' = s *  P`m'_WeightDeviation`k'_`j'`i' if Age > `m'
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

scalar Index_state_sex_N`N'_s`s' = Numerator_state_sex/Denominator

 

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
gen P`m'_WeightDeviation`k'_`j'`i'_ =  (abs(Age -`m'))^B * MQ`i'`j'`k'  
}
}
}
}

forvalues m = `=min'(1) `=max' {
forvalues i = 1(1)4 {
foreach j in F M {
foreach k of numlist 1 2 4/6 8/13 15/42 44/51 53/56 { 
qui replace P`m'_WeightDeviation`k'_`j'`i'_ = s*P`m'_WeightDeviation`k'_`j'`i'_  if Age > `m'
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

scalar Index_state_sex_quart_N`N'_s`s' = Numerator_state_sex_quart/Denominator

  
restore 
}
}
}



forvalues N = `=Bmin'(`=Binterval')`=Bmax' {

forvalues s = `=smin'(`=sinterval')`=smax'{

dis "Index_state_B`N'_s`s' est " Index_state_N`N'_s`s'
 dis "Index_state_sex_B`N'_s`s' est "  Index_state_sex_N`N'_s`s'
dis "Index_state_sex_quart_`N'_s`s' est " Index_state_sex_quart_N`N'_s`s' 
}
}

