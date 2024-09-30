**** This do file cleans creates the necessary variables for treatment defining ****
****	migrant if all people in a hh are migrants								****

clear
set more off
*cd "D:\Partition\Output"
global raw 			"C:\E Drive AA\Partition\Data\Raw\"
global temp 		"C:\E Drive AA\Partition\Data\Temp\"
global collapsed 	"C:\E Drive AA\Partition\Data\Collapsed\"
global final 		"C:\E Drive AA\Partition\Data\Final\"



use "${raw}pak_1973.dta", clear

keep if bplcountry==32100 | bplcountry==32040	

gen birth_year = 1973 - age
label var birth_year "Year of Birth"	

gen migrate = 0 if bplcountry==32100
replace migrate = 1 if bplcountry==32040
label var migrate "=1 if born in India"

bys serial: egen migrate_hha = min(migrate) if birth_year<=1951 & birth_year>=1937
label var migrate_hha "=1 if all individuals born b/w 1837 & 51 in a household were migrants"

gen migrate_hh = migrate
replace migrate_hh = 0 if migrate==1 & migrate_hha==0

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

gen treat_1 = agegroup_1 * migrate_hh
label var treat_1 "=1 for migrants born from 1952 to 1953, 0 o/w"

gen treat_2 = agegroup_2 * migrate_hh
label var treat_2 "=1 for migrants born from 1947 to 1951, 0 o/w"

gen treat_3 = agegroup_3 * migrate_hh
label var treat_3 "=1 for migrants born from 1942 to 1946, 0 o/w"

gen treat_4 = agegroup_4 * migrate_hh
label var treat_4 "=1 for migrants born from 1937 to 1941, 0 o/w"

gen treat_5 = agegroup_5 * migrate_hh
label var treat_5 "=1 for migrants born from 1932 to 1936, 0 o/w"

gen treat_6 = agegroup_6 * migrate_hh
label var treat_6 "=1 for migrants born from 1927 to 1931, 0 o/w"

gen treat_7 = agegroup_7 * migrate_hh
label var treat_1 "=1 for migrants born from 1923 to 1926, 0 o/w"


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



gen treat_r_1 = agegroup_r_1 * migrate_hh
label var treat_r_1 "=1 for migrants born from 1944 to 1951, 0 o/w"

gen treat_r_2 = agegroup_r_2 * migrate_hh
label var treat_r_2 "=1 for migrants born from 1937 to 1943, 0 o/w"

gen treat_r_3 = agegroup_r_3 * migrate_hh
label var treat_r_3 "=1 for migrants born from 1930 to 1936, 0 o/w"

gen treat_r_4 = agegroup_r_4 * migrate_hh
label var treat_r_4 "=1 for migrants born from 1923 to 1929, 0 o/w

gen treatment = 0
replace treatment = 1 if birth_year>=1932 & birth_year<=1951

gen migtreat = 0
replace migtreat = 1 if treatment==1 & migrate==1 

gen rural = 0
replace rural = 1 if	urban==1

gen dist_rural = distpk*rural

gen 	literate=0 					if lit==1
replace literate=1 					if lit==2

save "${final}pak_1973_temp_migrate_hh.dta", replace
