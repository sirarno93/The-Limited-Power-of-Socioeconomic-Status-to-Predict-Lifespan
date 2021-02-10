
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

cd "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Graphs\Graph USA"

shp2dta using s_11au16, database(usdb) coordinates(uscoord) genid(id) replace
use usdb
destring FIPS, gen(id_2)
drop if id_2 == 24 & id == 57
save, replace

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Graphs\Graph USA\Retirement age usa.xlsx", sheet("Feuil1") clear firstrow

rename state id_2

merge 1:1 id_2 using usdb 
drop if _merge!=3
keep if id!=1 & id!=56 & id!=13

save label.dta, replace

spmap retirement_b1 using uscoord, id(id)  legenda(off) label(data(label) label(retirement_b1 ) xcoord(LON) ycoord(LAT) size(*0.8..)) 

graph export "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Picture\Map_US_B1.png", as(png) replace

spmap retirement_b10 using uscoord, id(id)     legenda(off) label(data(label) label( retirement_b10 ) xcoord(LON) ycoord(LAT) size(*0.8..))

graph export "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Picture\Map_US_B10.png", as(png) replace