****	This do file checks trends in variables of interest and other variables	****
****	Included here: Table 1, Tables A1 & A2
****	Included here: Figure 3, Figure A4


clear
set more off
cd 					"C:\E Drive AA\Partition\Output"
global raw 			"C:\E Drive AA\Partition\Data\Raw\"
global temp 		"C:\E Drive AA\Partition\Data\Temp\"
global collapsed 	"C:\E Drive AA\Partition\Data\Collapsed\"
global final 		"C:\E Drive AA\Partition\Data\Final\"
global output 		"C:\E Drive AA\Partition\Output\"


clear
set more off
use "${...}pak_1973_temp.dta", clear


*Table A1: born b/w 1923 and 1951
estpost tabstat ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch chbornf chbornm ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1951 & migrate==1, s(N mean sd count) ///
		columns(statistics)
est 	store migrants
		
estpost tabstat ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch chbornf chbornm ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1951 & migrate==0, s(N mean sd count) ///
		columns(statistics)
est		store natives

esttab 	natives migrants using "${output}sumstats.tex", replace main(mean) aux(sd)  ///
		nostar unstack nonote nonumber style(tex) booktab
		
		
*Table A2: born b/w 1923 and 1931		
estpost tabstat ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1931 & migrate==1, s(N mean sd count) ///
		columns(statistics)
est 	store migrants2	
	
estpost tabstat ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1931 & migrate==0, s(N mean sd count) ///
		columns(statistics)
est 	store natives2

esttab 	natives2 migrants2 using "${output}sumstatsa.tex", replace main(mean) aux(sd) ///
		nostar unstack nonote nonumber style(tex) booktab
	

*Table A1: t-test for sample b/w 1923 and 1951
estpost ttest ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1951, by(native) 
est		store migrants3

esttab 	migrants3 using "${output}sumstatsb.tex", replace wide  ///
		 style(tex) booktab
	
*Table A2: t-test for sample b/w 1923 and 1931
estpost ttest ///
		famsize hhsize nfams ncouples nchlt5 nchild youngest_ch eldest_ch ///
		diff_dist hours_work labforce_active employed ///
		age_married poly2nd never_married group_qrtr urban ///
		literate prim_educ sec_educ inter_educ ///
		if birth_year>=1923 & birth_year<=1931, by(native) 
est		store migrants4

esttab 	migrants4 using "${output}sumstatsc.tex", replace wide  ///
		 style(tex) booktab




*Table 1 No of natives and migrants in each group		
estpost tabstat migrants_*   if birth_year>=1923 & birth_year<=1953 & migrate==1, ///
		s(count) columns(statistics)
est		store migrants

estpost tabstat migrants_*   if birth_year>=1923 & birth_year<=1953 & migrate==0, ///
		s(count) columns(statistics)
est		store natives

esttab 	natives migrants using "${output}sumstats2.tex", replace main(count) nostar unstack nonote ///
		nonumber style(tex) booktab		

******************************************************************************
		
	
***Note: ONLY the figures with annotated explanations are included in the paper		


		
** generating change in religious composition in India and Pakistan		
use "${...}pak_census_1951_1931.dta", clear

graph 	hbar 	nonmuslims total_pop if province=="Punjab", over(year, lab(nolab)) over(district) percent stack ///
		ytitle( Percentage of Non-Muslims in Each District (Punjab), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_nonmuslims_Punjab.png", as(png) replace	
		
graph 	hbar 	nonmuslims total_pop if province=="Sind", over(year, lab(nolab)) over(district) percent stack ///
		ytitle( Percentage of Non-Muslims in Each District (Sindh), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_nonmuslims_Sind.png", as(png) replace
		
*Figure 3 (a) 	
graph 	hbar 	percent_nonmuslims if province=="Punjab", over(year, lab(nolab)) over(district)  ///
		ytitle( Percentage of Non-Muslims in Each District (Punjab), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_nonmuslims_Punjab_2.png", as(png) replace
		
graph 	hbar 	percent_nonmuslims if province=="Sind", over(year, lab(nolab)) over(district)  ///
		ytitle( Percentage of Non-Muslims in Each District (Sind), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_nonmuslims_Sind_2.png", as(png) replace
		
			
graph 	hbar 	change_nonmuslims_percent, over(district, lab(nolab) sort(province)) ///
		ytitle(Percentage Change in District Non-Muslim Population b/w 1931 and 1951, size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		legend(off) 
graph export "${output}change_nonmuslims.png", as(png) replace




		
use "${...}ind_census_1951_1931.dta", clear

		
graph 	hbar 	muslims total_pop if state=="Punjab and Delhi", over(year, lab(nolab)) over(district) percent stack ///
		ytitle( Percentage of Muslims in Each District (Indian Punjab), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_muslims_IndPunjab.png", as(png) replace	

*Figure 3(b)
graph 	hbar 	percent_muslims if state=="Punjab and Delhi", over(year, lab(nolab)) over(district)  ///
		ytitle( Percentage of Muslims in Each District (Indian Punjab), size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		lintensity(100) legend(off)
graph export "${output}change_muslims_IndPunjab_2.png", as(png) replace

*Figure A4 (c)
graph 	hbar 	change_muslims_percent if state=="UP" & district!="Lucknow", over(district, lab(nolab)) ///
		ytitle(Percentage Change in District Muslim Population b/w 1931 and 1951 in Uttar Paradesh, size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		legend(off) 
graph export "${output}change_muslims_UP.png", as(png) replace

*Figure A4 (b)
graph 	hbar 	change_muslims_percent if state=="Punjab and Delhi", over(district, lab(nolab)) ///
		ytitle(Percentage Change in District Muslim Population b/w 1931 and 1951 in Indian Punjab, size(small)) ///
		bargap(1) yline(0) blabel(group, position(outside) color(black)) intensity(*0.75) ///
		legend(off) 
graph export "${output}change_muslims_IndPunjab_3.png", as(png) replace

***



*********************************
use "${...}pak_1973_temp.dta", clear


**********************************************************		
use "${temp}ind_census_1951_1931.dta", clear		
twoway 	bar 	change_nonmuslims_percent dist if province=="Punjab", ///
				ylabel(10 "10%" 0 "0%" -10 "-10%" -20 "-20%" -30 "-30%" -40 "-40%", labsize(small))	///
				xlabel(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 17, valuelabel labsize(small)) ///
				yline(0) xtitle(District ID, size(small))	///
			ytitle((Share of) Non Muslims in 1951 - Non Muslims in 1931, size(small)) ///
			title(Change in Percentage Non Muslim District Population in Pakistan, size(medsmall)) 

			
*Figure A4 (a)
use "${temp}pak_census_1951_1931.dta", clear		
twoway 	bar 	change_nonmuslims_percent dist, ylabel(10 "10%" 0 "0%" -10 "-10%" -20 "-20%" ///
				-30 "-30%" -40 "-40%", labsize(small))	yline(0) xtitle(District ID, size(small))	///
			ytitle((Share of) Non Muslims in 1951 - Non Muslims in 1931, size(small)) ///
			title(Change in Percentage Non Muslim District Population in Pakistan, size(medsmall)) 
graph export "${output}change_nonmuslims.png", as(png) replace
			

twoway 	bar 	change_hindus_percent dist, ylabel(5 "5%" 0 "0%" -5 "-5%" -10 "-10%" ///
				-15 "-15%" -20 "-20%" -25 "-25%", labsize(small))	yline(0) xtitle(District ID, size(small))	///
			ytitle((Share of) Non Muslims in 1951 - Non Muslims in 1931, size(small)) ///
			title(Change in Share of Hindu Population in Pakistan, size(medsmall)) 
graph export "${output}change_hindus.png", as(png) replace
		

twoway 	bar 	change_muslims_percent dist, ylabel(0(10)50, labsize(small))	yline(0) xtitle(District ID, size(small))	///
			ytitle((Share of) Non Muslims in 1951 - Non Muslims in 1931, size(small)) ///
			title(Change in Share of Non Muslim Population in Pakistan, size(medsmall)) 
graph export "${output}change_muslims.png", as(png) replace
