
*************************************************************************************************************
*																											*
*  ***Heterogeneity in life expectancy versus in realized longevity: Implications for pension design***		*
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

import excel "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By state, income quartile and sex\Simulation - Gompertz.xlsx", sheet("Simulation to Stata") firstrow

dropmiss, force

export excel using "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Code\Data simulation\By state, income quartile and sex\Distribution - Gompertz.xlsx", firstrow(variables) replace