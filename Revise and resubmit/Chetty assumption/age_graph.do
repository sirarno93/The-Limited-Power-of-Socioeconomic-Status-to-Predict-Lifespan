clear all
set more off

set obs 81
gen Age = [_n+39]


***concave
gen Concave = round(-10+10*sqrt(-23+Age))
***convexe
gen Convex = round(exp(Age/22.5)+30) if Age <= 80
replace Convex = round(exp(Age/30)+50.5) if Age > 80
***linear
gen Linear = round(Age*0.8125)

tsset Age

tsline C* L, scheme(s1mono) lwidth(medthick medthick medthick) xlabel(30 40 60 80 100 120) ylabel(30 40 60 80 100 120) lcolor(gs0 gs10 gs5) lpattern(solid solid  dash  ) aspectratio(1)

graph export "C:\Users\baurin\Documents\UCL Doctorat\Formation\Thèse\Papier 2 définitif\Picture\concave_convex_linear.png", as(png) replace
