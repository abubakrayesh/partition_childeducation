**** This do file imports the 1951 and 1931 data and creates the necessary variables for analysis	****


**imorting 1951 and 1931 census data for pakistan districts in Sindh and Punjab
clear
import excel 	"${temp}\pak_census_temp.xlsx", sheet("Sheet1") ///
				firstrow case(lower)

save "${temp}pak_census_1951_1931.dta", replace



**imorting 1951 and 1931 census data for india districts in UP and Punjab
clear
import excel 	"${temp}\ind_census_temp.xlsx", sheet("Sheet1") ///
				firstrow case(lower)

save "${temp}ind_census_1951_1931.dta", replace



**importing 1951 labor force data at tehsil level for natives and immigrants
clear
import excel "${raw}pak_1951_tehsil_laborforce.xlsx", sheet("Sheet1") firstrow


rename _* 	*

foreach var of varlist m_* f_*	{
	replace `var' = 0		if `var'==.
	}
	
	
foreach var of varlist 	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents	{
		
	gen `var'_nat = `var' - `var'_imm	
		
				}
				

drop	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents 
				
foreach g in  imm nat	{
	
	egen	total_labor_`g' = rowtotal(m_aglabor_`g' m_nonaglabor_`g' m_notlaborforce_`g' f_aglabor_`g' f_nonaglabor_`g' f_notlaborforce_`g')	
	egen	total_aglabor_`g' = rowtotal(m_aglabor_`g' f_aglabor_`g')
	egen	total_nonaglabor_`g' = rowtotal(m_nonaglabor_`g' f_nonaglabor_`g' m_notlaborforce_`g' f_notlaborforce_`g')
	
	gen		prop_ag_`g' = (m_aglabor_`g' + f_aglabor_`g') / total_labor_`g'
	gen		prop_nonag_`g' = (m_nonaglabor_`g' + f_nonaglabor_`g' + m_notlaborforce_`g' + f_notlaborforce_`g') / total_labor_`g'
	
	}
	
	
	
	egen	total_labor_2 = rowtotal(total_labor_imm total_labor_nat)	
	egen	total_aglabor_2 = rowtotal(total_aglabor_imm total_aglabor_nat)
	egen	total_nonaglabor_2 = rowtotal(total_nonaglabor_imm total_nonaglabor_nat)
	
	gen		prop_ag_2_imm = (m_aglabor_imm + f_aglabor_imm) / total_labor_2
	gen		prop_nonag_2_imm = (m_nonaglabor_imm + f_nonaglabor_imm + m_notlaborforce_imm + f_notlaborforce_imm) / total_labor_2
	
	gen		prop_ag_2_nat = (m_aglabor_imm + f_aglabor_imm) / total_labor_2
	gen		prop_nonag_2_nat = (m_nonaglabor_nat + f_nonaglabor_nat + m_notlaborforce_nat + f_notlaborforce_nat) / total_labor_2
	
	
				
rename	*_imm	*2
rename	*_nat	*1

				
reshape long 	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents total_labor total_aglabor ///
				total_nonaglabor prop_ag prop_nonag prop_ag_2 prop_nonag_2, ///
				i(tehsil) j(migrate) 
				
encode	district, 	gen(distpk)
encode 	tehsil, 	gen(tehsil_code)

save "${final}pak_labforce_1951_tehsil.dta", replace


**importing 1951 labor force data at tehsil level for urban and rural areas and for natives and immigrants
clear
import excel "${raw}pak_1951_tehsil_urban_laborforce.xlsx", sheet("Sheet1") firstrow

rename _* 	*

foreach var of varlist m_* f_*	{
	replace `var' = 0		if `var'==.
	}
	
	
foreach var of varlist 	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents	{
		
	gen `var'_nat = `var' - `var'_imm	
		
				}
				

drop	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents 
				
				
rename	*_imm	*2
rename	*_nat	*1

				
reshape long 	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents, ///
				i(tehsil) j(migrate) 
				
encode	district, 	gen(distpk)
encode 	tehsil, 	gen(tehsil_code)

foreach var of varlist m_* f_*	{

	rename	`var'		`var'_urban
	
	}

merge 1:1 	tehsil migrate	using	"${final}pak_labforce_1951_tehsil.dta"
drop if _merge==2
drop _merge

drop	total_labor* total_aglabor* total_nonaglabor* prop_ag* prop_nonag*

foreach var of varlist m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents  {
				
	gen		`var'_rural	= `var' - `var'_urban
				}
				

	
foreach g in  rural urban	{
	
	egen	total_labor_`g' = rowtotal (m_aglabor_`g' m_nonaglabor_`g' m_notlaborforce_`g' f_aglabor_`g' f_nonaglabor_`g' f_notlaborforce_`g')	
	egen	total_aglabor_`g' = rowtotal (m_aglabor_`g' f_aglabor_`g')
	egen	total_nonaglabor_`g' = rowtotal (m_nonaglabor_`g' f_nonaglabor_`g' m_notlaborforce_`g' f_notlaborforce_`g')
	
	*gen		prop_ag_`g' = (m_aglabor_`g' + f_aglabor_`g') / total_labor_`g'
	*gen		prop_nonag_`g' = (m_nonaglabor_`g' + f_nonaglabor_`g' + m_notlaborforce_`g' + f_notlaborforce_`g') / total_labor_`g'
	
	}	
	

drop if total_labor_urban==0 & total_labor_rural==0
	
foreach g in  rural urban	{
	
	gen		prop_ag_`g' = (m_aglabor_`g' + f_aglabor_`g') / (total_labor_urban + total_labor_rural)
	replace prop_ag_`g' = 0					if prop_ag_`g'==.
	
	gen		prop_nonag_`g' = (m_nonaglabor_`g' + f_nonaglabor_`g' + m_notlaborforce_`g' + f_notlaborforce_`g') / (total_labor_urban + total_labor_rural)
	replace prop_nonag_`g' = 0				if prop_nonag_`g'==.
	}	
	
	
				
egen	total_1951_urban = rowtotal(m_aglabor_urban m_nonaglabor_urban m_notlaborforce_urban ///
				m_under12_dependents_urban m_plus12_dependents_urban f_aglabor_urban ///
				f_nonaglabor_urban f_notlaborforce_urban f_under12_dependents_urban f_plus12_dependents_urban)
				
egen	total_1951_rural = rowtotal(m_aglabor_rural m_nonaglabor_rural m_notlaborforce_rural ///
				m_under12_dependents_rural m_plus12_dependents_rural f_aglabor_rural ///
				f_nonaglabor_rural f_notlaborforce_rural f_under12_dependents_rural f_plus12_dependents_rural)
				
egen	total_1951_all = rowtotal(m_aglabor m_nonaglabor m_notlaborforce ///
				m_under12_dependents m_plus12_dependents f_aglabor ///
				f_nonaglabor f_notlaborforce f_under12_dependents f_plus12_dependents)
				
gen	proppop_urban = total_1951_urban / total_1951_all	

gen	proppop_rural = total_1951_rural / total_1951_all						

drop			m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents	
				

save "${final}pak_labforce_1951_tehsil_urban.dta", replace

use "${final}pak_labforce_1951_tehsil_urban.dta", clear
				
rename *_urban	*2
rename *_rural	*1				
				
reshape long 	m_aglabor m_nonaglabor m_notlaborforce m_under12_dependents ///
				m_plus12_dependents f_aglabor f_nonaglabor f_notlaborforce ///
				f_under12_dependents f_plus12_dependents total_labor total_aglabor ///
				total_nonaglabor prop_ag prop_nonag prop_ag_2 prop_nonag_2 proppop total_1951, ///
				i(tehsil migrate) j(urban) 
				

save "${final}pak_labforce_1951_tehsil_urban_2.dta", replace


**importing 1951 labor force data at district level for natives and immigrants
clear
import excel "${raw}pak_1951_laborforce.xlsx", sheet("Sheet1") firstrow

rename _* 	*

save "${temp}pak_labforce_1951_district.dta", replace


use "${temp}pak_labforce_1951_district.dta", clear

replace district="Bahawalpur" if district=="Rahimyar Khan"		//for merging with literacy data in the next stage below//

collapse (sum) tot*, by(district)

gen		total_nat = total - total_imm

drop total

rename	*_imm	*2
rename	*_nat	*1

reshape long	total, i(district) j(migrate)

save "${temp}pak_labforce_1951_district_2.dta", replace


**creating district level 1951 labor force data at district level for natives and immigrants at both urban and rural level

use "${final}pak_labforce_1951_tehsil_urban.dta", replace

collapse (sum) m_* f_*, by(district migrate)

rename	*_urban	*2
rename	*_rural	*1

reshape long 	m_aglabor m_nonaglabor m_notlaborforce ///
				m_under12_dependents m_plus12_dependents f_aglabor ///
				f_nonaglabor f_notlaborforce f_under12_dependents f_plus12_dependents, ///
				i(district migrate) j(urban) 
				
replace district="Khairpur State" if district=="Khairpur"
replace district="Bahawalpur" if district=="Rahimyarkhan"
replace district="Thatta" if district=="Tatta"
replace district="Thar Parkar" if district=="Tharparkar"

collapse (sum) m_* f_*, by(district migrate urban)

egen	total_1951 = rowtotal(m_aglabor m_nonaglabor m_notlaborforce ///
				m_under12_dependents m_plus12_dependents f_aglabor ///
				f_nonaglabor f_notlaborforce f_under12_dependents f_plus12_dependents)
				
bys 	district: egen			total_1951_dist = sum(total_1951)
gen		prop_1951_2 = total_1951 / total_1951_dist

bys		district migrate: egen	total_1951_dist_2 = sum(total_1951)
gen		prop_1951 = total_1951 / total_1951_dist_2



replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2

*keep	if migrate==1		//if I just want to merge prop of migrants in urban and rural - remove these 2 if want to merge natives too//
*drop 	migrate

save "${final}pak_labforce_1951_district_3.dta", replace


**creating migrant and antive literacy rates for 1951, to merge with the main data

use "${temp}pak_census_1951_1931.dta", clear

keep district district_merge  literate_51 literate_mig_51

rename 	literate_mig_51		literate_51_imm
gen		literate_51_nat = literate_51 - literate_51_imm

drop	literate_51

rename	*_imm	*2
rename	*_nat	*1

reshape long	literate_51, i(district) j(migrate)


replace district="Bahawalpur" if district=="Bahawalpur+Rahim"
replace district="Khairpur State" if district=="Khairpur"
replace district="Montgomery" if district=="Montgomer"
replace district="Thatta" if district=="Tatta"
replace district="Thar Parkar" if district=="Tharparker"
replace district="Karachi" if district=="Thatta"

collapse (sum) literate_51 (max) district_merge, by(district migrate)

*merge 1:1 	district migrate	using	"${temp}pak_labforce_1951_district_2.dta"
*drop if _merge==2
*drop _merge

*rename	total	total_51

*gen		prop_literate = literate_51 / total_51

replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2


save "${final}pak_literacy_1951.dta", replace


**creating necessary avriables from 1931 and 1951 Census for religious population change (Pak)
use "${temp}pak_census_1951_1931.dta", clear

drop 	literate_mig_51 ag_51 non_ag_51 dependents_51 literate_51 ag_31 non_ag_31 ///
		dependents_31 literate_31

replace district="Karachi"	if district=="Tatta"	//Thatta was part of Karachi district in 1931//
replace	district="Larkana"	if district=="Dadu"		//Dadu was mostly a part of Larkana (and some Karachi but ignored) in 1931//

egen distid = group(province district_merge)
egen stateid = group(province)

collapse (sum) *_51 *_31 (max) district_merge (first) province, by(district)

gen change_muslims_no = muslims_51 - muslims_31
gen percent_muslims_51 = (muslims_51 / total_pop_51) * 100
gen percent_muslims_31 = (muslims_31 / total_pop_31) * 100
gen change_muslims_percent = percent_muslims_51 - percent_muslims_31


gen change_hindus_no = hindus_51 - hindus_31
gen percent_hindus_51 = (hindus_51 / total_pop_51) * 100
gen percent_hindus_31 = (hindus_31 / total_pop_31) * 100
gen change_hindus_percent = percent_hindus_51 - percent_hindus_31


gen change_nonmuslims_no = nonmuslims_51 - nonmuslims_31
gen percent_nonmuslims_51 = (nonmuslims_51 / total_pop_51) * 100
gen percent_nonmuslims_31 = (nonmuslims_31 / total_pop_31) * 100
gen change_nonmuslims_percent = percent_nonmuslims_51 - percent_nonmuslims_31

sencode district, gen(dist) gsort(province district)	//encodes districts in order by each province//

replace district="Bahawalpur"	if district=="Bahawalpur+Rahim"

rename *_51		*1951
rename *_31		*1931

keep	total_pop* muslims* nonmuslims* hindus* percent_hindus* percent_nonmuslims* ///
		percent_muslims* change_*_percent district dist province

reshape long total_pop hindus muslims nonmuslims percent_hindus percent_muslims ///
			percent_nonmuslims, i(district) j(year)
			
save "${final}pak_census_1951_1931.dta", replace


**creating necessary avriables from 1931 and 1951 Census for religious population change (Ind)
use "${temp}ind_census_1951_1931.dta", clear

replace district="Patiala"	if district=="Bhatinda"
replace district="Patiala"	if district=="Mohinder garh"
replace district="Patiala"	if district=="Fatehgarh"

keep state district total_pop_51 muslims_51 total_pop_31 muslims_31

drop	if muslims_31==.		//for now - will change later//

collapse (sum) *_51 *_31 (first) state, by(district)

egen distid = group(state district)
egen stateid = group(state)
sencode district, gen(dist) gsort(state district)	//encodes districts in order by each state//

gen change_muslims_no = muslims_51 - muslims_31
gen percent_muslims_51 = (muslims_51 / total_pop_51) * 100
gen percent_muslims_31 = (muslims_31 / total_pop_31) * 100
gen change_muslims_percent = percent_muslims_51 - percent_muslims_31

rename *_51		*1951
rename *_31		*1931

keep	total_pop* muslims* percent_muslims* change_muslims_percent district dist state

reshape long total_pop muslims percent_muslims, i(district) j(year)

save "${final}ind_census_1951_1931.dta", replace


**place of birth data
*1931
clear
import excel "${raw}birthplace_1931.xlsx", sheet("Sheet1") firstrow

drop 	b_samestate_diffcntry_31 b_nborcntry_31

save "${temp}birthplace_1931.dta", replace

*1951
clear
import excel "${raw}birthplace_1951.xlsx", sheet("Sheet1") firstrow

save "${temp}birthplace_1951.dta", replace

*now merge
use "${temp}birthplace_1951.dta", clear

merge 	1:1  district using	"${temp}birthplace_1931.dta"
drop if _merge==2
drop _merge

replace district="Karachi" 			if district=="Dadu"
replace district="Larkana" 			if district=="Thatta"
replace district="Bahawalpur" 		if district=="Rahimyar Khan"

collapse (sum) *_51 *_31, by(district)


gen		b_prop_samedist_31 = b_samecity_31 / total_31

gen		b_prop_sameprov_31 = (b_samecity_31 + b_samestate_diffcity_31) / total_31

gen		b_prop_samectry_31 = (b_samecity_31 + b_samestate_diffcity_31 + b_samecntry_diffstate_31) / total_31

gen		b_prop_outofstate_31 = (b_samecntry_diffstate_31) / total_31


gen		b_prop_samedist_51 = b_samecity_51 / total_51

gen		b_prop_sameprov_51 = (b_samecity_51 + b_samestate_diffcity_51) / total_51

gen		b_prop_samectry_51 = (b_samecity_51 + b_samestate_diffcity_51 + b_samecntry_diffstate_51 ///
							+ b_nborcntry_51) / total_51
							
gen		b_prop_nborctry_51 = (b_nborcntry_51) / total_51

gen		b_prop_outofstate_51 = (b_samecntry_diffstate_51 + b_nborcntry_51) / total_51

save "${final}birthplace.dta", replace

sum b_prop_outofstate_31		//make a graph of these variables//
sum b_prop_outofstate_51
sum b_prop_sameprov_51
sum b_prop_sameprov_31


exit
**merging it with census data and creating some variables


gen change_ag_no = ag_51 - ag_31

gen percent_ag_51 = (ag_51 / total_pop_51)*100

gen percent_ag_31 = (ag_31 / total_pop_31)*100

gen change_ag_percent = percent_ag_51 - percent_ag_31


gen change_nonag_no = non_ag_51 - non_ag_31

gen percent_nonag_51 = (non_ag_51 / total_pop_51)*100

gen percent_nonag_31 = (non_ag_31 / total_pop_31)*100

gen change_nonag_percent = percent_nonag_51 - percent_nonag_31


gen change_dependents_no = dependents_51 - dependents_31

gen percent_dependents_51 = (dependents_51 / total_pop_51)*100

gen percent_dependents_31 = (dependents_31 / total_pop_31)*100

gen change_dependents_percent = percent_dependents_51 - percent_dependents_31


gen change_literate_no = literate_51 - literate_31

gen percent_literate_51 = (literate_51 / total_pop_51) * 100

gen percent_literate_31 = (literate_31 / total_pop_31) * 100

gen change_literate_percent = percent_literate_51 - percent_literate_31


