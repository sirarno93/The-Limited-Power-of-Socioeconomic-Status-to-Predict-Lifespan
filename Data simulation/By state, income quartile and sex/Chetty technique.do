
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

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By state, income quartile and sex\Simulation - Chetty technique.xlsx", sheet("Simulation to Stata") firstrow clear

dropmiss, force

export excel using "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By state, income quartile and sex\Distribution - Chetty technique.xlsx", replace