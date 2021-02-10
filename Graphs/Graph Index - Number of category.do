
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
*************************************************************************************************************	clear all
set more off

set maxvar 32767  

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By income percentile and sex\Distribution - Chetty technique.xlsx", sheet("Observations") cellrange(A1:OJ81) firstrow clear


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

scalar min = 40
scalar max = 120

*** Categorie 1 ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Population = rowtotal(PF1-PM100)

forvalues m = `=min'(1) `=max' {
gen P`m'_Deviation = (abs(Age -`m'))^B * Population
}

forvalues m = `=min'(1) `=max' {
egen S`m'_Deviation = total(P`m'_Deviation) 
}

egen Categorie1 = rowmin(S*)

scalar Cat1 = Categorie1[1]

restore 
}

*** Categorie 2 (50-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_50F = rowtotal(PF1-PF50)
egen Perc_50M = rowtotal(PM1-PM50)
gen Perc_50 = Perc_50F + Perc_50M

drop Perc_50F Perc_50M

egen Perc_100F = rowtotal(PF51-PF100)
egen Perc_100M = rowtotal(PM51-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 50 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 50 100 {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

egen Categorie2_50 = rowmin(S_50*)
egen Categorie2_100 = rowmin(S_100*)

gen Categorie2 = Categorie2_100 + Categorie2_50

scalar Cat2 = Categorie2[1]

restore 
}

*** Categorie 3 (33-66-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_33F = rowtotal(PF1-PF33)
egen Perc_33M = rowtotal(PM1-PM33)
gen Perc_33 = Perc_33F + Perc_33M

drop Perc_33F Perc_33M

egen Perc_66F = rowtotal(PF34-PF66)
egen Perc_66M = rowtotal(PM34-PM66)
gen Perc_66 = Perc_66F + Perc_66M

drop Perc_66F Perc_66M

egen Perc_100F = rowtotal(PF67-PF100)
egen Perc_100M = rowtotal(PM67-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 33 66 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 33 66 100 {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

egen Categorie3_33 = rowmin(S_33*)
egen Categorie3_66 = rowmin(S_66*)
egen Categorie3_100 = rowmin(S_100*)

gen Categorie3 = Categorie3_100 + Categorie3_66 + Categorie3_33

scalar Cat3 = Categorie3[1]

restore 
}

*** Categorie 4 (25-50-75-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_25F = rowtotal(PF1-PF25)
egen Perc_25M = rowtotal(PM1-PM25)
gen Perc_25 = Perc_25F + Perc_25M

drop Perc_25F Perc_25M

egen Perc_50F = rowtotal(PF26-PF50)
egen Perc_50M = rowtotal(PM26-PM50)
gen Perc_50 = Perc_50F + Perc_50M

drop Perc_50F Perc_50M

egen Perc_75F = rowtotal(PF51-PF75)
egen Perc_75M = rowtotal(PM51-PM75)
gen Perc_75 = Perc_75F + Perc_75M

drop Perc_75F Perc_75M

egen Perc_100F = rowtotal(PF76-PF100)
egen Perc_100M = rowtotal(PM76-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 25 50 75 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 25 50 75 100  {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

egen Categorie4_25 = rowmin(S_25*)
egen Categorie4_50 = rowmin(S_50*)
egen Categorie4_75 = rowmin(S_75*)
egen Categorie4_100 = rowmin(S_100*)

egen Categorie4 = rowtotal(Categorie4*)

scalar Cat4 = Categorie4[1]

restore 
}

*** Categorie 5 (20-40-60-80-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_20F = rowtotal(PF1-PF20)
egen Perc_20M = rowtotal(PM1-PM20)
gen Perc_20 = Perc_20F + Perc_20M

drop Perc_20F Perc_20M

egen Perc_40F = rowtotal(PF21-PF40)
egen Perc_40M = rowtotal(PM21-PM40)
gen Perc_40 = Perc_40F + Perc_40M

drop Perc_40F Perc_40M

egen Perc_60F = rowtotal(PF41-PF60)
egen Perc_60M = rowtotal(PM41-PM60)
gen Perc_60 = Perc_60F + Perc_60M

drop Perc_60F Perc_60M

egen Perc_80F = rowtotal(PF61-PF80)
egen Perc_80M = rowtotal(PM61-PM80)
gen Perc_80 = Perc_80F + Perc_80M

drop Perc_80F Perc_80M

egen Perc_100F = rowtotal(PF81-PF100)
egen Perc_100M = rowtotal(PM81-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 20 40 60 80 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 20 40 60 80 100  {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in 20 40 60 80 100 {
egen Categorie5_`j' = rowmin(S_`j'*)
}

egen Categorie5 = rowtotal(Categorie5*)

scalar Cat5 = Categorie5[1]

restore 
}

*** Categorie 6 (16-33-49-66-82-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_16F = rowtotal(PF1-PF16)
egen Perc_16M = rowtotal(PM1-PM16)
gen Perc_16 = Perc_16F + Perc_16M

drop Perc_16F Perc_16M

egen Perc_33F = rowtotal(PF17-PF33)
egen Perc_33M = rowtotal(PM17-PM33)
gen Perc_33 = Perc_33F + Perc_33M

drop Perc_33F Perc_33M

egen Perc_49F = rowtotal(PF34-PF49)
egen Perc_49M = rowtotal(PM34-PM49)
gen Perc_49 = Perc_49F + Perc_49M

drop Perc_49F Perc_49M

egen Perc_66F = rowtotal(PF50-PF66)
egen Perc_66M = rowtotal(PM50-PM66)
gen Perc_66 = Perc_66F + Perc_66M

drop Perc_66F Perc_66M


egen Perc_82F = rowtotal(PF67-PF82)
egen Perc_82M = rowtotal(PM67-PM82)
gen Perc_82 = Perc_82F + Perc_82M

drop Perc_82F Perc_82M

egen Perc_100F = rowtotal(PF83-PF100)
egen Perc_100M = rowtotal(PM83-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in  16 33 49 66 82 100  {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 16 33 49 66 82 100  {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in 16 33 49 66 82 100 {
egen Categorie6_`j' = rowmin(S_`j'*)
}

egen Categorie6 = rowtotal(Categorie6*)

scalar Cat6 = Categorie6[1]

restore 
}

*** Categorie 7 (14-28-43-57-71-86-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_14F = rowtotal(PF1-PF14)
egen Perc_14M = rowtotal(PM1-PM14)
gen Perc_14 = Perc_14F + Perc_14M

drop Perc_14F Perc_14M

egen Perc_28F = rowtotal(PF15-PF28)
egen Perc_28M = rowtotal(PM15-PM28)
gen Perc_28 = Perc_28F + Perc_28M

drop Perc_28F Perc_28M

egen Perc_43F = rowtotal(PF29-PF43)
egen Perc_43M = rowtotal(PM29-PM43)
gen Perc_43 = Perc_43F + Perc_43M

drop Perc_43F Perc_43M

egen Perc_57F = rowtotal(PF44-PF57)
egen Perc_57M = rowtotal(PM44-PM57)
gen Perc_57 = Perc_57F + Perc_57M

drop Perc_57F Perc_57M

egen Perc_71F = rowtotal(PF58-PF71)
egen Perc_71M = rowtotal(PM58-PM71)
gen Perc_71 = Perc_71F + Perc_71M

drop Perc_71F Perc_71M

egen Perc_86F = rowtotal(PF72-PF86)
egen Perc_86M = rowtotal(PM72-PM86)
gen Perc_86 = Perc_86F + Perc_86M

drop Perc_86F Perc_86M

egen Perc_100F = rowtotal(PF87-PF100)
egen Perc_100M = rowtotal(PM87-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 14 28 43 57 71 86 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 14 28 43 57 71 86 100  {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in 14 28 43 57 71 86 100 {
egen Categorie7_`j' = rowmin(S_`j'*)
}

egen Categorie7 = rowtotal(Categorie7*)

scalar Cat7 = Categorie7[1]

restore 
}

*** Categorie 8 (12-25-37-50-62-75-87-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_12F = rowtotal(PF1-PF12)
egen Perc_12M = rowtotal(PM1-PM12)
gen Perc_12 = Perc_12F + Perc_12M

drop Perc_12F Perc_12M

egen Perc_25F = rowtotal(PF13-PF25)
egen Perc_25M = rowtotal(PM13-PM25)
gen Perc_25 = Perc_25F + Perc_25M

drop Perc_25F Perc_25M

egen Perc_37F = rowtotal(PF26-PF37)
egen Perc_37M = rowtotal(PM26-PM37)
gen Perc_37 = Perc_37F + Perc_37M

drop Perc_37F Perc_37M

egen Perc_50F = rowtotal(PF38-PF50)
egen Perc_50M = rowtotal(PM38-PM50)
gen Perc_50 = Perc_50F + Perc_50M

drop Perc_50F Perc_50M

egen Perc_62F = rowtotal(PF51-PF62)
egen Perc_62M = rowtotal(PM51-PM62)
gen Perc_62 = Perc_62F + Perc_62M

drop Perc_62F Perc_62M

egen Perc_75F = rowtotal(PF63-PF75)
egen Perc_75M = rowtotal(PM63-PM75)
gen Perc_75 = Perc_75F + Perc_75M

drop Perc_75F Perc_75M

egen Perc_87F = rowtotal(PF76-PF87)
egen Perc_87M = rowtotal(PM76-PM87)
gen Perc_87 = Perc_87F + Perc_87M

drop Perc_87F Perc_87M

egen Perc_100F = rowtotal(PF88-PF100)
egen Perc_100M = rowtotal(PM88-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 12 25 37 50 62 75 87 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 12 25 37 50 62 75 87 100 {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in 12 25 37 50 62 75 87 100 {
egen Categorie8_`j' = rowmin(S_`j'*)
}

egen Categorie8 = rowtotal(Categorie8*)

scalar Cat8 = Categorie8[1]

restore 
}

*** Categorie 9 (11-22-33-44-55-66-77-88-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_11F = rowtotal(PF1-PF11)
egen Perc_11M = rowtotal(PM1-PM11)
gen Perc_11 = Perc_11F + Perc_11M

drop Perc_11F Perc_11M

egen Perc_22F = rowtotal(PF12-PF22)
egen Perc_22M = rowtotal(PM12-PM22)
gen Perc_22 = Perc_22F + Perc_22M

drop Perc_22F Perc_22M

egen Perc_33F = rowtotal(PF23-PF33)
egen Perc_33M = rowtotal(PM23-PM33)
gen Perc_33 = Perc_33F + Perc_33M

drop Perc_33F Perc_33M

egen Perc_44F = rowtotal(PF34-PF44)
egen Perc_44M = rowtotal(PM34-PM44)
gen Perc_44 = Perc_44F + Perc_44M

drop Perc_44F Perc_44M

egen Perc_55F = rowtotal(PF45-PF55)
egen Perc_55M = rowtotal(PM45-PM55)
gen Perc_55 = Perc_55F + Perc_55M

drop Perc_55F Perc_55M	

egen Perc_66F = rowtotal(PF56-PF66)
egen Perc_66M = rowtotal(PM56-PM66)
gen Perc_66 = Perc_66F + Perc_66M

drop Perc_66F Perc_66M	

egen Perc_77F = rowtotal(PF67-PF77)
egen Perc_77M = rowtotal(PM67-PM77)
gen Perc_77 = Perc_77F + Perc_77M

drop Perc_77F Perc_77M	

egen Perc_88F = rowtotal(PF78-PF88)
egen Perc_88M = rowtotal(PM78-PM88)
gen Perc_88 = Perc_88F + Perc_88M

drop Perc_88F Perc_88M	

egen Perc_100F = rowtotal(PF89-PF100)
egen Perc_100M = rowtotal(PM89-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 11 22 33 44 55 66 77 88 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 11 22 33 44 55 66 77 88 100  {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in  11 22 33 44 55 66 77 88 100  {
egen Categorie9_`j' = rowmin(S_`j'*)
}

egen Categorie9 = rowtotal(Categorie9*)

scalar Cat9 = Categorie9[1]

restore 
}

*** Categorie 10 (10-20-30-40-50-60-70-80-90-100) ***
{
preserve 

foreach j in F M {
forvalues i = 1(1)100 {
gen P`j'`i' = C`j'`i' * `j'`i'
}
}

drop C* F* M*

egen Perc_10F = rowtotal(PF1-PF10)
egen Perc_10M = rowtotal(PM1-PM10)
gen Perc_10 = Perc_10F + Perc_10M

drop Perc_10F Perc_10M

egen Perc_20F = rowtotal(PF11-PF20)
egen Perc_20M = rowtotal(PM11-PM20)
gen Perc_20 = Perc_20F + Perc_20M

drop Perc_20F Perc_20M

egen Perc_30F = rowtotal(PF21-PF30)
egen Perc_30M = rowtotal(PM21-PM30)
gen Perc_30 = Perc_30F + Perc_30M

drop Perc_30F Perc_30M

egen Perc_40F = rowtotal(PF31-PF40)
egen Perc_40M = rowtotal(PM31-PM40)
gen Perc_40 = Perc_40F + Perc_40M

drop Perc_40F Perc_40M

egen Perc_50F = rowtotal(PF41-PF50)
egen Perc_50M = rowtotal(PM41-PM50)
gen Perc_50 = Perc_50F + Perc_50M

drop Perc_50F Perc_50M

egen Perc_60F = rowtotal(PF51-PF60)
egen Perc_60M = rowtotal(PM51-PM60)
gen Perc_60 = Perc_60F + Perc_60M

drop Perc_60F Perc_60M

egen Perc_70F = rowtotal(PF61-PF70)
egen Perc_70M = rowtotal(PM61-PM70)
gen Perc_70 = Perc_70F + Perc_70M

drop Perc_70F Perc_70M

egen Perc_80F = rowtotal(PF71-PF80)
egen Perc_80M = rowtotal(PM71-PM80)
gen Perc_80 = Perc_80F + Perc_80M

drop Perc_80F Perc_80M

egen Perc_90F = rowtotal(PF81-PF90)
egen Perc_90M = rowtotal(PM81-PM90)
gen Perc_90 = Perc_90F + Perc_90M

drop Perc_90F Perc_90M

egen Perc_100F = rowtotal(PF91-PF100)
egen Perc_100M = rowtotal(PM91-PM100)
gen Perc_100 = Perc_100F + Perc_100M

drop Perc_100F Perc_100M

forvalues m = `=min'(1) `=max' {
foreach j in 10 20 30 40 50 60 70 80 90 100 {
gen P`m'_Deviation`j' = (abs(Age -`m'))^B * Perc_`j'
}
}

forvalues m = `=min'(1) `=max' {
foreach j in 10 20 30 40 50 60 70 80 90 100 {
egen S_`j'_`m'_Deviation = total(P`m'_Deviation`j') 
}
}

foreach j in 10 20 30 40 50 60 70 80 90 100 {
egen Categorie10_`j' = rowmin(S_`j'_*)
}

egen Categorie10 = rowtotal(Categorie10*)

scalar Cat10 = Categorie10[1]

restore 
}

***Coefficient***

forvalues i = 1(1)10 {
scalar Coef_`i' = Cat`i'/Cat1
}

gen Coefficient = 1 in 1/10

keep Coefficient
drop in 11/l

forvalues i = 1(1)10 {
replace Coefficient = Coef_`i' in `=`i''
}

gen Category = [_n]
gen Index = Coefficient 

twoway connected Index Category, scheme(s1mono) 

graph export "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Picture\Index_by_category.png", as(png) replace

gen FirstDifference = Coefficient[_n]-Coefficient[_n-1]
twoway connected FirstDifference Category, scheme(s1mono)
