****	This do file runs the regressions and does other necessary analysis		****
**** 	Included here: Tables 2 and 3, Tables A3 through A6						****
**** 	Included here: Figure 2 & 4, Figures A2 & A3, Figures A5 through A7		****


clear
set more off


use "${...}pak_1973_temp.dta", clear

global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.distpk


*Figure A6
reg 	sec_educ $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
coefplot, keep(*.treatage) xline(0.5) rename(*.treatage = *) vertical ///
levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) mfcolor(white) mlcolor(black)  msymbol(O) ///
		ytitle(Estimated probability of Completing Ten Years of Education, size(small))  ///
		yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		xtitle(Year of Birth - 19XX, size(medium))  ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabel(22*="51" 23*="50" 24*="49" 25*="48" 26*="47" 27*="46" 28*="45" ///
		29*="44" 30*="43" 31*="42" 32*="41" 33*="40" 34*="39" 35*="38" 36*="37" ///
		37*="36" 38*="35" 39*="34" 40*="33" 41*="32" 42*="31" 43*="30" 44*="29" ///
		45*="28" 46*="27" 47*="26" 48*="25" 49*="24" 50*="23") ///
		order(50* 49* 48* 47* 46* 45* 44* 43* 42* 41* 40* 39* 38* 37* 36* 35* 34* ///
		33* 32* 31* 30* 29* 28* 27* 26* 25* 24* 23* 22*)
graph export "${output}did_ci_sec.png", replace		

*Figure A7
reg 	prim_educ $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
coefplot, keep(*.treatage) xline(0.5) rename(*.treatage = *) vertical ///
levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) mfcolor(white) mlcolor(black)  msymbol(O) ///
		ytitle(Estimated probability of Completing Five Years of Education, size(small))  ///
		yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		xtitle(Year of Birth - 19XX, size(medium))  ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabel(22*="51" 23*="50" 24*="49" 25*="48" 26*="47" 27*="46" 28*="45" ///
		29*="44" 30*="43" 31*="42" 32*="41" 33*="40" 34*="39" 35*="38" 36*="37" ///
		37*="36" 38*="35" 39*="34" 40*="33" 41*="32" 42*="31" 43*="30" 44*="29" ///
		45*="28" 46*="27" 47*="26" 48*="25" 49*="24" 50*="23") ///
		order(50* 49* 48* 47* 46* 45* 44* 43* 42* 41* 40* 39* 38* 37* 36* 35* 34* ///
		33* 32* 31* 30* 29* 28* 27* 26* 25* 24* 23* 22*)
graph export "${output}did_ci_prim.png", replace	

*Figure A5
reg 	literate $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
coefplot, keep(*.treatage) xline(0.5) rename(*.treatage = *) vertical ///
levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) mfcolor(white) mlcolor(black)  msymbol(O) ///
		ytitle(Estimated probability of being Literate, size(small))  ///
		yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		xtitle(Year of Birth 19XX, size(medium))  ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabel(22*="51" 23*="50" 24*="49" 25*="48" 26*="47" 27*="46" 28*="45" ///
		29*="44" 30*="43" 31*="42" 32*="41" 33*="40" 34*="39" 35*="38" 36*="37" ///
		37*="36" 38*="35" 39*="34" 40*="33" 41*="32" 42*="31" 43*="30" 44*="29" ///
		45*="28" 46*="27" 47*="26" 48*="25" 49*="24" 50*="23") ///
		order(50* 49* 48* 47* 46* 45* 44* 43* 42* 41* 40* 39* 38* 37* 36* 35* 34* ///
		33* 32* 31* 30* 29* 28* 27* 26* 25* 24* 23* 22*)
graph export "${output}did_ci_lit.png", replace	



*Figure 2 				
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_sec		  

*Figure 2  						  
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_prim	
 
		
coefplot (results_sec, aseq(Ten Years of Education) \ ///
		results_prim, aseq(Five Years of Education) ), ///
		keep(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) omitted ///
		order(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) ///
		xline(0.5) vertical  ///
		levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) ///
		mfcolor(white) mlcolor(black) msymbol(O)  ///
		ytitle(Estimated probability of Completing X Years of Education, size(small))  ///
		xtitle (Birth Group Cohort - 19XX) yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabels(treat_2="47-51" treat_3="42-46" treat_4="37-41" ///
		treat_5="32-36" treat_6="27-31" treat_7="23-26") 
graph export "${output}did_ci_group.png", replace



					*****************************

*Figures A2 and A3
reg 	sec_educ $control $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & migrate==0, cluster(distpk)
est store results_1
		  
reg 	sec_educ $control $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & migrate==1, cluster(distpk)
est store results_2

reg 	prim_educ $control $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & migrate==0, cluster(distpk)
est store results_3
		  
reg 	prim_educ $control $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & migrate==1, cluster(distpk)
est store results_4
		  
coefplot (results_1, label(Natives) msymbol(O) mcolor(navy) ciopts(color(navy) recast(rcap))) ///
		(results_2, label(Migrants) msymbol(S) mcolor(orange) ciopts(color(orange) recast(rcap))), ///
		keep(agegroup_2 agegroup_3 agegroup_4 agegroup_5 agegroup_6 agegroup_7) omitted ///
		order(agegroup_7 agegroup_6 agegroup_5 agegroup_4 agegroup_3 agegroup_2) ///
		xline(0.5) vertical norecycle levels(99 95 90) mfcolor(white)  ///
		ytitle(Estimated probability of Completing Ten Years of Education, size(small))  ///
		xtitle (Birth Group Cohort - 19XX) yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabels(agegroup_2="47-51" agegroup_3="42-46" agegroup_4="37-41" ///
		agegroup_5="32-36" agegroup_6="27-31" agegroup_7="23-26") 
graph export "${output}did_trends_sec.png", replace	

coefplot (results_3, label(Natives) msymbol(O) mcolor(navy) ciopts(color(navy) recast(rcap))) ///
		(results_4, label(Migrants) msymbol(S) mcolor(orange) ciopts(color(orange) recast(rcap))), ///
		keep(agegroup_2 agegroup_3 agegroup_4 agegroup_5 agegroup_6 agegroup_7) omitted ///
		order(agegroup_7 agegroup_6 agegroup_5 agegroup_4 agegroup_3 agegroup_2) ///
		xline(0.5) vertical norecycle levels(99 95 90) mfcolor(white)  ///
		ytitle(Estimated probability of Completing Five Years of Education, size(small))  ///
		xtitle (Birth Group Cohort - 19XX) yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabels(agegroup_2="47-51" agegroup_3="42-46" agegroup_4="37-41" ///
		agegroup_5="32-36" agegroup_6="27-31" agegroup_7="23-26") 
graph export "${output}did_trends_prim.png", replace						



					*****************************

*Table 2

*Panel A
*Column 1					
reg 	sec_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
*Column 2
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 3
reg 	sec_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)		



					*****************************

*Panel B
*Column 1	
reg 	prim_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
		
*Column 2
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 3
reg 	prim_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)



					*****************************

*Table A4

*Column 1
reg 	inter_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 2
reg 	inter_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 3
reg 	inter_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)



					*****************************

*Table A3
*Column 1
reg 	literate $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 2
reg 	literate $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 3
reg 	literate $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)		



					*****************************


reg 	sec_educ $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)


reg 	prim_educ $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

reg 	literate $controlled $treated $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
				

***Now running placebo regressions				
use "${...}pak_1973_temp_placebo.dta", clear

*Table A6

*Panel A
*Column1
reg 	sec_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 2
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 3
reg 	sec_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

				
				
					**************

*Panel B
*Column 1					
reg 	prim_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 2
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
*Column 3
reg 	prim_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)


					*****************************
			
*Figure 4			
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_sec_placebo
		  
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_prim_placebo
		  
coefplot (results_sec_placebo, aseq(10 Years of Education) \ ///
		results_prim_placebo, aseq(5 Years of Education) ), ///
		keep(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) omitted ///
		order(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) ///
		xline(0.5) vertical  ///
		levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) ///
		mfcolor(white) mlcolor(black) msymbol(O)  ///
		ytitle(Estimated probability of Completing X Years of Education, size(small))  ///
		xtitle (Birth Group Cohort - 19XX) yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabels(treat_2="47-51" treat_3="42-46" treat_4="37-41" ///
		treat_5="32-36" treat_6="27-31" treat_7="23-26") 
graph export "${output}did_ci_group_placebo.png", replace				
		
		
		
************

**Heterogeneity by gender and location
use "${...}pak_1973_temp.dta", clear

*Table A5

*Panel A
*Column 1
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & sex==1, cluster(distpk)

*Column 2
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & sex==2, cluster(distpk)
				
				
*Column 3
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & urban==1, cluster(distpk)
				
		  
		  
*Column 4
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & urban==2, cluster(distpk)
				
				
								**************

*Panel B
*Column 1								
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & sex==1, cluster(distpk)

*Column 2
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & sex==2, cluster(distpk)
				
				
*Column 3
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & urban==1, cluster(distpk)
				
		  
		  
*Column 4
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & urban==2, cluster(distpk)

				