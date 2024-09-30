**** This do file cleans the 1973 data and creates the necessary variables for main analysis	****


clear
set more off
*cd "E:\Partition\Output"
global raw 			"C:\E Drive AA\Partition\Data\Raw\"
global temp 		"C:\E Drive AA\Partition\Data\Temp\"
global collapsed 	"C:\E Drive AA\Partition\Data\Collapsed\"
global final 		"C:\E Drive AA\Partition\Data\Final\"

use "${raw}pak_1973.dta", clear

keep if bplcountry==32100 | bplcountry==32040		

gen migrate = 0 if bplcountry==32100
replace migrate = 1 if bplcountry==32040
label var migrate "=1 if born in India"

gen native = 1 if bplcountry==32100
replace native = 0 if bplcountry==32040
label var native "=1 if born in Pakistan"

*drop if treat==.
*drop if migrate==.

keep if geo1_pk==586003 | geo1_pk==586004

gen inter_educ=0 if educpk<320
replace inter_educ=1 if educpk>=320 & educpk!=500

gen sec_educ=0 if educpk<310
replace sec_educ=1 if educpk>=310 & educpk!=500
label var sec_educ "=1 if completed 10 years of education"

gen prim_educ=0 if educpk<220
replace prim_educ=1 if educpk>=220 & educpk!=500
label var prim_educ "=1 if completed 5 years of education"

gen birth_year = 1973 - age
label var birth_year "Year of Birth"

bys serial pernum: gen place = _n		//This genertes a unique individual identifier//

egen total_pop = sum(place), by(distpk)			//total population in each district//
label var total_pop "total population in each district"

gen treatage = age * migrate
label var treatage "equals age for those born in India, 0 o/w"

gen migrants = 1 if bplcountry!=32100
replace migrants = 0 if bplcountry==32100
egen no_migrants = sum(migrants), by(distpk)		//no of migrants in each district//
label var no_migrants "total migrants in each district"
drop migrants

gen natives = 1 if bplcountry==32100
replace natives = 0 if bplcountry!=32100
egen no_natives = sum(natives), by(distpk)		//no of natives in each district)//
label var no_natives "total natives in each district"
drop natives

gen prop_migrants = no_migrants / total_pop		//proportion of migrants in each district// 
label var prop_migrants "proportion of migrants in each district"

gen signif_migrants = 0
replace signif_migrants = 1 if prop_migrants > 0.1 
label var signif_migrants "=1 for districts with more than 10% pop of migrants"

gen diff_dist = 0
replace diff_dist = 1 if migpk!=distpk			
label var diff_dist "=1 lived in a different district 8 years ago"

egen hhsize = sum(place), by(serial)
label var hhsize "Household size"

gen labforce_active=0 if labforce==1
replace labforce_active=1 if labforce==2
label var labforce_active "=1 if active member of labor force"

gen inactive = 0 if empstat!=0 & empstat!=9 & empstat!=3
replace inactive = 1 if empstat==3
label var inactive "=1 if part if labor-force eligible but inactive member"

gen employed = 1 if empstat==1
replace employed = 0 if empstat==2
label var employed "=1 if employed"

gen labforce_eligible = 1
replace labforce_eligible = 0 if labforce==9
label var labforce_eligible "=1 if eligible member of the labor force"



gen self_employed = 0 if classwk!=0 & classwk!=9 & classwk!=1
replace self_employed = 1 if classwk==1
label var self_employed "=1 if self employed"

gen salaried = 0 if classwk!=0 & classwk!=9 & classwk!=2
replace salaried = 1 if classwk==2
label var salaried "=1 if salaried employee"



gen agegroup_1 = 0
replace agegroup_1 = 1		if birth_year<=1953 & birth_year>=1952
label var agegroup_1 "equals 1 for those born from 1952 to 1953, 0 o/w"

gen agegroup_2 = 0
replace agegroup_2 = 1		if birth_year<=1951 & birth_year>=1947
label var agegroup_2 "equals 1 for those born from 1947 to 1951, 0 o/w"

gen agegroup_3 = 0
replace agegroup_3 = 1		if birth_year<=1946 & birth_year>=1942
label var agegroup_3 "equals 1 for those born from 1942 to 1946, 0 o/w"

gen agegroup_4 = 0
replace agegroup_4 = 1		if birth_year<=1941 & birth_year>=1937
label var agegroup_4 "equals 1 for those born from 1937 to 1941, 0 o/w"

gen agegroup_5 = 0
replace agegroup_5 = 1		if birth_year<=1936 & birth_year>=1932
label var agegroup_5 "equals 1 for those born from 1932 to 1936"

gen agegroup_6 = 0
replace agegroup_6 = 1		if birth_year<=1931 & birth_year>=1927
label var agegroup_6 "=1 for those born from 1927 to 1931"

gen agegroup_7 = 0
replace agegroup_7 = 1		if birth_year<=1926 & birth_year>=1923
label var agegroup_7 "=1 for those born from 1923 to 1926"

*replace migrate=0 if agegroup_7==1

gen treat_1 = agegroup_1 * migrate
label var treat_1 "=1 for migrants born from 1952 to 1953, 0 o/w"

gen treat_2 = agegroup_2 * migrate
label var treat_2 "=1 for migrants born from 1947 to 1951, 0 o/w"

gen treat_3 = agegroup_3 * migrate
label var treat_3 "=1 for migrants born from 1942 to 1946, 0 o/w"

gen treat_4 = agegroup_4 * migrate
label var treat_4 "=1 for migrants born from 1937 to 1941, 0 o/w"

gen treat_5 = agegroup_5 * migrate
label var treat_5 "=1 for migrants born from 1932 to 1936, 0 o/w"

gen treat_6 = agegroup_6 * migrate
label var treat_6 "=1 for migrants born from 1927 to 1931, 0 o/w"

gen treat_7 = agegroup_7 * migrate
label var treat_1 "=1 for migrants born from 1923 to 1926, 0 o/w"


forvalues num = 1/7	 {
	egen migrants_`num' = sum(migrate)	if agegroup_`num'==1
	label var migrants_`num' "total migrants in the country in age group `num'"
	
	egen natives_`num' = sum(native)	if agegroup_`num'==1
	label var natives_`num' "total natives in the country in age group `num'"
	}
	
		
gen noparent = 0
replace noparent = 1 if parrul==0
label var noparent "=1 if does not have any parent"

gen noparent_mig = 0
replace noparent_mig = 1 if migrate ==1 & noparent==1
label var noparent_mig "=1 if migrated and does not have any parent"

gen hh_extended = 0 if hhtype!=6 & hhtype!=7 & hhtype!=8 & hhtype!=9 & hhtype!=99
replace hh_extended = 1 if hhtype==6 | hhtype==7 | hhtype==8 | hhtype==9
replace hh_extended=0 if hhtype==99
label var hh_extended "=1 if extended family lives in the same hh"

gen agegroup_r_1 = 0
replace agegroup_r_1 = 1		if birth_year<=1951 & birth_year>=1944
label var agegroup_r_1 "equals 1 for those born from 1944 to 1951, 0 o/w"

gen agegroup_r_2 = 0
replace agegroup_r_2 = 1		if birth_year<=1943 & birth_year>=1937
label var agegroup_r_2 "equals 1 for those born from 1937 to 1943, 0 o/w"

gen agegroup_r_3 = 0
replace agegroup_r_3 = 1		if birth_year<=1936 & birth_year>=1930
label var agegroup_r_3 "equals 1 for those born from 1930 to 1936, 0 o/w"

gen agegroup_r_4 = 0
replace agegroup_r_4 = 1		if birth_year>=1923 & birth_year<=1929
label var agegroup_r_4 "equals 1 for those born from 1923 to 1929, 0 o/w"



gen treat_r_1 = agegroup_r_1 * migrate
label var treat_r_1 "=1 for migrants born from 1944 to 1951, 0 o/w"

gen treat_r_2 = agegroup_r_2 * migrate
label var treat_r_2 "=1 for migrants born from 1937 to 1943, 0 o/w"

gen treat_r_3 = agegroup_r_3 * migrate
label var treat_r_3 "=1 for migrants born from 1930 to 1936, 0 o/w"

gen treat_r_4 = agegroup_r_4 * migrate
label var treat_r_4 "=1 for migrants born from 1923 to 1929, 0 o/w

gen treatment = 0
replace treatment = 1 if birth_year>=1932 & birth_year<=1951

gen migtreat = 0
replace migtreat = 1 if treatment==1 & migrate==1 

gen treatment_2 = 0
replace treatment_2 = 1 if birth_year>=1937 & birth_year<=1951

gen migtreat_2 = 0
replace migtreat_2 = 1 if treatment_2==1 & migrate==1 

gen rural = 0
replace rural = 1 if	urban==1

gen dist_rural = distpk*rural

gen 	hours_work = hrswork1 		if hrswork1!=998 & hrswork1!=999

gen 	age_married = agemarr 		if agemarr!=0 & agemarr!=99

gen 	ever_chborn = chborn 		if chborn!=99

gen 	ever_chsurv = chsurv 		if chsurv!=99

gen 	never_married = 0
replace never_married = 1 			if marst==1

gen 	literate=0 					if lit==1
replace literate=1 					if lit==2

gen 	literate_migrate = 0 		if literate==0
replace literate_migrate = 1 		if literate==1 & migrate==1

gen 	group_qrtr = 0
replace group_qrtr = 1 				if gq==22

gen		youngest_ch = yngch			if yngch!=99 

gen		eldest_ch = eldch			if eldch!=99 

gen 	ln_hrswork = ln(hours_work)

save "${final}pak_1973_temp.dta", replace


*For creating difference in t-stat of means between migrants and natives	//THIS NEEDS ELEVANT VARIABLES//
use "${final}pak_1973_temp.dta", clear
keep if birth_year>=1923 & birth_year<=1953
collapse (mean) sec_educ migyrs1 famsize hhsize nchild age sex labforce_* employed	///
			(max) signif_migrants, by(birth_year migrate) 
save "${final}pak_1973_col.dta", replace

exit

*use "${temp}pak_1973_temp.dta", clear

*gen district_merge = distpk

*recode district_merge (311=312) (313=312) (442=454)

*save "${temp}pak_1973_temp_2.dta", replace





**appending census 1931 and 1951 data for UP, Punjab and Sind districts
*use "${temp}pak_census_1951_1931.dta", clear

*drop dist_merge





foreach var of varlist nchild famsize age nfams ncouples nfathers lit disabled {
	egen dist_`var' = mean(`var'), by(distpk)
	*label dist_`var' " No of `var' in each district"
	}
	
gen	event = birth_year - 1931
label var event "exposure for each birth cohort born since 1931"

gen event_treat = event * migrate
label var event_treat "exposure for each birth cohort born since 1931 for migrants only"

gen event_treat_2 = event_treat * -1
label var event_treat "event_treat into -1"

gen nonag = 0 if indgen!=10 & indgen!=0 & indgen!=999
replace nonag = 1 if indgen==10
label var nonag "=1 if employed in a non-agricultural job"

gen unskilled_service = 1 if occisco==3 | occisco==4 | occisco==5 | occisco==9
replace unskilled_service = 0 if occisco!=3 & occisco!=4 & occisco!=5 & occisco!=9 & occisco!=98 & occisco!=99
label var unskilled_service "=1 if employed in an unskilled service sector job"

gen skilled_service = 1 if occisco==1 | occisco==2
replace skilled_service = 0 if occisco!=1 & occisco!=2 & occisco!=98 & occisco!=99
label var skilled_service "=1 if employed in a skilled service sector job"

gen skilled_occup_nonag = 1 if occisco==1 | occisco==2
replace skilled_occup_nonag = 0 if occisco!=1 & occisco!=2 & occisco!=98 & occisco!=99
label var skilled_occup_nonag "=1 if employed in a non-agrocultural skilled occupation"

gen elementary = 1 if occisco==9
replace elementary = 0 if occisco!=9 & occisco!=98 & occisco!=99
label var elementary "=1 if employed in an elementary occupation"


gen hhextend_mig = 0
replace hhextend_mig = 1 if migrate==1 & hh_extended==1
label var hhextend_mig "=1 if migrated and lives with extended family"

gen major_city=0
replace major_city=1	if distpk==363
replace major_city=1	if distpk==365
replace major_city=1	if distpk==352
replace major_city=1	if distpk==331
replace major_city=1	if distpk==429
*replace major_city=1 	if distpk==544
label var major_city "=1 if lives in one of the 5 major cities"


local i = 1
foreach var of varlist treat_* {

	gen majcity_treat_`i' = 0
	replace majcity_treat_`i' = 1		if major_city==1 & treat_`i'==1
	*label var majcity_treat "=1 if belong to treat group `i' and to one of the 4 major cities"
	
	local i = `i' + 1
	}

gen majcity_urban = 0
replace majcity_urban=1 if major_city==1 | urban==1
label var majcity_urban "=1 if belong to either any urban area or a major city"

gen majcity_and_urban = 0
replace majcity_and_urban=1 if major_city==1 & urban==1
label var majcity_and_urban "=1 if belong to urban area of the major city"

gen congestion=0
replace congestion =1 if signif_migrants==1 & distpk!=429

bys birth_year: egen total_migrants = sum(migrate)
label var total_migrants "total migrants in the country"

bys birth_year: egen total_natives = sum(native)
label var total_natives "total natives in the country"



replace chbornf=. if chbornf==99
replace chbornm=. if chbornm==99

egen total_labforce_active = sum(labforce_active), by(distpk)	//total district laborforce//
label var total_labforce_active "total active members of active labor force members in each district"

egen total_labforce_eligible = sum(labforce_eligible), by(distpk)
label var total_labforce_eligible "total eligible members of laborforce in each district"

egen total_employed = sum(employed), by(distpk)		//total employed in each district//
label var total_employed "total employed members of labor force in each district"

gen emp_labforce_active = total_employed / total_labforce_active
label var emp_labforce_active "total employed to total active in labor force ratio"

gen emp_labforce_eligible = total_employed / total_labforce_eligible
label var emp_labforce_eligible "total employed to total eligible in labor force ratio"



