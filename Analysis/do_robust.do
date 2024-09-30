****	This do file does the sensitivity analysis not included in do_reg.do	****
****	Included here: Tables A7 through A12

use "${...}pak_1973_temp.dta", clear

global controlled		i.age
global control			agegroup_r_1-agegroup_r_4
global treated			i.treatage
global treat			treat_r_1-treat_r_4
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban	migyrs1 diff_dist
global fixed_effects	i.distpk
***********

	
*Table A12

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

		  
		  
						***********

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


						************

reg 	inter_educ $control $treat $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
		
reg 	inter_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

reg 	inter_educ $controlled $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)



					*****************************



**Now doing a simple before and after

*Table A11

*Panel A
*Column 1
reg 	sec_educ treatment migtreat migrate age $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)


*Column 2
reg 	sec_educ treatment migtreat migrate i.birth_year $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
				

*Column 3
reg 	sec_educ migtreat age agegroup_6 agegroup_7 treat_6 treat_7 ///
		 $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		 if birth_year<=1951 & birth_year>=1923, cluster(distpk)
				
		 
*Column 4
reg 	sec_educ migtreat treat_6 treat_7 ///
		i.birth_year $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		 if birth_year<=1951 & birth_year>=1923, cluster(distpk)



							****************

*Panel B
*Column 1
reg 	prim_educ treatment_2 migtreat_2 migrate age $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)


*Column 2
reg 	prim_educ treatment_2 migtreat_2 migrate i.birth_year $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
				

*Column 3
reg 	prim_educ migtreat_2 age agegroup_5 agegroup_6 agegroup_7 treat_5 treat_6 treat_7 ///
		 $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		 if birth_year<=1951 & birth_year>=1923, cluster(distpk)
				
		 
*Column 4
reg 	prim_educ migtreat_2 treat_5 treat_6 treat_7 ///
		i.birth_year $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		 if birth_year<=1951 & birth_year>=1923, cluster(distpk)



					*****************************
				
		  
**controlling for prop of literate migrants and natives in 1951, and for prop of rural and urban migrants in 1951
use "${...}pak_1973_temp.dta", clear

global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.district_merge


gen district_merge = distpk

recode district_merge (311=312) (313=312) (442=454) (414=429)

merge m:1 district migrate using "${...}pak_literacy_1951.dta"
drop if _merge==2
drop _merge


merge m:1 district migrate urban using "${...}pak_labforce_1951_district_3.dta"
drop if _merge==2		//no rural migrants in Karachi in 1951, so 1 obs dropped//
drop _merge

gen prop_literate = literate_51 / total_1951_dist_2
gen prop_literate_2 = literate_51 / total_1951_dist

*Table A7

*Panel A
*Column 1
reg 	sec_educ $control $treat $individual $household prop_literate_2 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)	


*Column 2
reg 	sec_educ $control $treat $individual $household prop_1951 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)		


*Column 3
reg 	sec_educ $control $treat $individual $household prop_literate_2 prop_1951 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)	



							****************
							
*Panel B
*Column 1
reg 	prim_educ $control $treat $individual $household prop_literate_2 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)


*Column 2
reg 	prim_educ $control $treat $individual $household prop_1951 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)			


*Column 3
reg 	prim_educ $control $treat $individual $household prop_literate_2 prop_1951 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(district_merge)



					*****************************
				
***Robustness Check (controlling for parents' education)


use "${...}pak_1973_temp.dta", clear

global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.distpk


gen par_lit=.
replace par_lit=0 if poploc>0 & lit==1
replace par_lit=0 if momloc>0 & lit==1
replace par_lit=1 if poploc>0 & lit==2
replace par_lit=1 if momloc>0 & lit==2

gen par_educ=.
replace par_educ = educpk if poploc>0
replace par_educ = educpk if momloc>0

gen par_samehh = 0
replace par_samehh = 1 if poploc>0 | momloc>0

gen district_merge = distpk

recode district_merge (311=312) (313=312) (442=454) (414=429)

merge m:1 district migrate using "${...}pak_literacy_1951.dta"
drop if _merge==2
drop _merge


merge m:1 district migrate urban using "${...}pak_labforce_1951_district_3.dta"
drop if _merge==2		//no rural migrants in Karachi in 1951, so 1 obs dropped//
drop _merge

gen prop_literate = literate_51 / total_1951_dist_2
gen prop_literate_2 = literate_51 / total_1951_dist



preserve
keep if poploc>0 | momloc>0

*Table A8

*Column 1		  
reg 	sec_educ $control $treat $individual $household par_lit ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 2
reg 	sec_educ $control $treat $individual $household par_lit prop_literate_2 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)	
				
*Column 3
reg 	prim_educ $control $treat $individual $household par_lit ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

*Column 4
reg 	prim_educ $control $treat $individual $household par_lit prop_literate_2 ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)	  
outreg2  using parentslit.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  append ///
				title(Controlling for, Parents' Literacy) ///
				ctitle(=1 if Completed, 5 Yrs) tex keep($treat) nocons ///
				addtext(Individual Controls, Yes, Hh Controls, Yes, District Controls, Yes, ///
				District FE, Yes, Birth-Year FE, No )
restore



					*****************************
					

***Now running regressions	with migrant status at household level			
use "${...}pak_1973_temp_migrate_hh.dta", clear
global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.distpk

preserve
drop if migrate!=migrate_hh

*Table A9

*Panel A
*Column 1
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

restore	


preserve
keep if poploc>0 | momloc>0

*Column 2
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
restore

*Column 3
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)		



							****************

preserve
drop if migrate!=migrate_hh

*Panel B
*Column 1
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

restore


preserve
keep if poploc>0 | momloc>0

*Column 2
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
restore

*Column 3
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)

				
							************
							
preserve
drop if migrate!=migrate_hh
			
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_sec_migrate_hh
		  
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923, cluster(distpk)
est store results_prim_migrate_hh
		  
coefplot (results_sec_migrate_hh, aseq(Ten Years of Education) \ ///
		results_prim_migrate_hh, aseq(Five Years of Education) ), ///
		keep(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) omitted ///
		order(treat_7 treat_6 treat_5 treat_4 treat_3 treat_2) ///
		xline(0.5) vertical  ///
		levels(99 95 90) ciopts(lwidth(1 ...) lcolor(black*.3 black*.6 black*1.2) ) ///
		mfcolor(white) mlcolor(black) msymbol(O)  ///
		ytitle(Estimated probability of Completing X Years of Education, size(small))  ///
		xtitle (Birth Group Cohort 19XX) yline(0, lpattern(dash) lcolor(black)) mlabposition(10) ///
		legend (order(1 "99% CI" 2 "95% CI" 3 "90% CI")) ///
		mlabsize(medium) ms(Oh) graphregion(color(white)) bgcolor(white) ///
		coeflabels(treat_2="47-51" treat_3="42-46" treat_4="37-41" ///
		treat_5="32-36" treat_6="27-31" treat_7="23-26") 
graph export "${output}did_ci_group_migrate_hh.png", replace				
restore



					*****************************
					

**Now running the regressions separately for districts with migrants>=10% & migrants<10%

use "${...}pak_1973_temp.dta", clear

global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.distpk

*Table A10

*Panel A
*Column 1
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & signif_migrants==1, cluster(distpk)

*Column 2
reg 	sec_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & signif_migrants==0, cluster(distpk)
			
			
			
						****************
*Panel B
*Column 1
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & signif_migrants==1, cluster(distpk)

*Column 2
reg 	prim_educ $control $treat $individual $household ///
		$migrants_area $fixed_effects [pweight=hhwt] ///
		  if birth_year<=1951 & birth_year>=1923 & signif_migrants==0, cluster(distpk)
				
		  
**Following	de Chaisemartin and D'Haultfoeuille (2020a) 
*Note: there is NO table for this in the analysis	
global controlled		i.age
global control			agegroup_2-agegroup_7
global treated			i.treatage
global treat			treat_2-treat_7
global individual		i.sex i.disabled
global household		famsize nchild nfams hhsize
global migrants_area	urban migyrs1 diff_dist
global fixed_effects	i.distpk

use "${...}pak_1973_temp.dta", clear

tab distpk, gen(dist_)

gen treat_test=1 if treat_1 == 1
replace treat_test=2 if treat_2 == 1
replace treat_test=3 if treat_3 == 1
replace treat_test=4 if treat_4 == 1
replace treat_test=5 if treat_5 == 1
replace treat_test=6 if treat_6 == 1
replace treat_test=7 if treat_7 == 1

gen age_test=1 if agegroup_1 == 1
replace age_test=2 if agegroup_2 == 1
replace age_test=3 if agegroup_3 == 1
replace age_test=4 if agegroup_4 == 1
replace age_test=5 if agegroup_5 == 1
replace age_test=6 if agegroup_6 == 1
replace age_test=7 if agegroup_7 == 1

	  
twowayfeweights 	sec_educ migrate treatment migtreat ///
		  if birth_year<=1951 & birth_year>=1923, weight(hhwt) ///
		  type(feS) controls(sex disabled famsize nchild nfams hhsize prop_migrants urban diff_dist dist_*)

twowayfeweights 	sec_educ migrate age_test treat_test ///
		  if birth_year<=1951 & birth_year>=1923, weight(hhwt) ///
		  type(feS) controls(sex disabled famsize nchild nfams hhsize urban migyrs1 diff_dist dist_*)

*******

twowayfeweights 	prim_educ migrate treatment migtreat ///
		  if birth_year<=1951 & birth_year>=1923, weight(hhwt) ///
		  type(feS) controls(sex disabled famsize nchild nfams hhsize prop_migrants urban diff_dist dist_*)

twowayfeweights 	prim_educ migrate age_test treat_test ///
		  if birth_year<=1951 & birth_year>=1923, weight(hhwt) ///
		  type(feS) controls(sex disabled famsize nchild nfams hhsize urban migyrs1 diff_dist dist_*)
		  

