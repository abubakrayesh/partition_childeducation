****This do file is for creating maps included in the paper****


clear
set more off
cd 					"C:\E Drive AA\Partition\Output"
global raw 			"C:\E Drive AA\Partition\Data\Raw\"
global temp 		"C:\E Drive AA\Partition\Data\Temp\"
global collapsed 	"C:\E Drive AA\Partition\Data\Collapsed\"
global final 		"C:\E Drive AA\Partition\Data\Final\"
global output 		"C:\E Drive AA\Partition\Output\"
global spatial		"C:\E Drive AA\Partition\Data\Pak_SHP\"



***Converting shapefile into dta files***
shp2dta 	using "${spatial}pak_admbnda_adm2_ocha_pco_gaul_20181218.shp" ///
			, database("${temp}Spatial\dist_shp.dta") ///
			coordinates("${temp}Spatial\dist_shp_coor.dta") ///
			genid(ID) gencentroids(c) replace
			
shp2dta 	using "${spatial}pak_admbnda_adm1_ocha_pco_gaul_20181218.shp" ///
			, database("${temp}Spatial\pak_shp.dta") ///
			coordinates("${temp}Spatial\pak_shp_coor.dta") ///
			genid(ID) gencentroids(c) replace
		

***Creating country level shapefile with provinces of interest marked with labels
use "${temp}Spatial\pak_shp_coor.dta", clear

geo2xy _Y _X,		projection( mercator) replace
local 		lon0 = r(lon0)
local 		f = r(f)
local 		a = r(a)
save "${temp}Spatial\pak_coor_mercator.dta", replace

use "${temp}Spatial\pak_shp.dta", clear
gen 		x = runiform()
save "${temp}Spatial\pak_shp_2.dta", replace

gen 		labtype  = 1
append 		using "${temp}Spatial\pak_shp_2.dta"
replace 	labtype = 2 if labtype==.
replace 	ADM1_EN = string(x, "%3.2f") if labtype ==2
geo2xy  y_c x_c,	projection( mercator, `a' `f' `lon0' ) replace
save "${temp}Spatial\paklabels.dta", replace

*Map without labels
use "${temp}Spatial\pak_shp.dta", clear

gen		border_prov = 1		
replace border_prov = 2		if ADM1_PCODE=="PK8" | ADM1_PCODE=="PK6"

label 	define 	border		1 "Other Provinces"	2 "Shared Border with India"
label 	values	border_prov	border

spmap border_prov using "${temp}Spatial\pak_shp_coor.dta", ///
			id(ID) title("Pakistan", size(*1.8)) ///
			clmethod(unique) fcolor(white blue) ///
			legend(pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize )

			
*Map with labels
use "${temp}Spatial\pak_shp_2.dta", clear

gen		border_prov = 1		
replace border_prov = 2		if ADM1_PCODE=="PK8" | ADM1_PCODE=="PK6"

label 	define 	border		1 "Other Provinces"	2 "Shared Border with India"
label 	values	border_prov	border

spmap 	border_prov using "${temp}Spatial\pak_coor_mercator.dta", ///
			id(ID) title("Pakistan", size(*1.8))  ///
			label(data("${temp}Spatial\paklabels.dta") xcoord(x_c) ycoord(y_c) ///
			label(ADM1_EN) by(labtype)  size(*1.2 ..) pos(12 0) ) ///
			clmethod(unique) fcolor(white blue) ///
			legend(pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize )
graph export "${output}prov_interest.png", as(png) replace



***Manipulating data for creating population maps with 1951 districtds

**District level shapefile (current one)
shp2dta 	using "${spatial}pak_admbnda_adm2_ocha_pco_gaul_20181218.shp" ///
			, database("${temp}Spatial\dist_shp1.dta") ///
			coordinates("${temp}Spatial\dist_shp_coor1.dta") ///
			replace
						
	
*First collapse to district names as per 1951 census
use  "${temp}Spatial\dist_shp1.dta", clear

keep	if ADM1_EN=="Sindh" | ADM1_EN=="Punjab"
rename	ADM2_EN		district

replace	district="Bahawalpur"	if district=="Bahawalnagar"
replace	district="Bahawalpur"	if district=="Rahim Yar Khan"
	
replace	district="Campbellpur"	if district=="Attock"

replace	district="Lyallpur"		if district=="Faisalabad"
replace	district="Lyallpur"		if district=="Chiniot"
replace	district="Lyallpur"		if district=="Toba Tek Singh"

replace	district="Montgomery"	if district=="Sahiwal"
replace	district="Montgomery"	if district=="Okara"
replace	district="Montgomery"	if district=="Pakpattan"

replace	district="Shahpur"		if district=="Sargodha"
replace	district="Shahpur"		if district=="Khushab"

replace	district="Gujranwala"	if district=="Hafizabad"

replace	district="Jhelum"		if district=="Chakwal"

replace	district="Mianwali"		if district=="Bhakkar"

replace	district="Lahore"		if district=="Kasur"

replace	district="Sheikhupura"	if district=="Nankana Sahib"

replace	district="Sialkot"		if district=="Narowal"

replace	district="Dera Ghazi Khan"	if district=="Rajanpur"

replace	district="Multan"		if district=="Vehari"
replace	district="Multan"		if district=="Khanewal"
replace	district="Multan"		if district=="Lodhran"

replace	district="Muzaffargarh"	if district=="Layyah"

replace	district="Gujrat"		if district=="Mandi Bahauddin"

replace	district="Sukkur"		if district=="Ghotki"
replace	district="Sukkur"		if district=="Shikarpur"

replace	district="Dadu"			if district=="Jamshoro"

*replace	district="Sialkot"	if district=="Khairpur"
replace	district="Hyderabad"	if district=="Matiari"
replace	district="Hyderabad"	if district=="Tando Allah Yar"
replace	district="Hyderabad"	if district=="Tando Muhammad Khan"

replace	district="Thar Parkar"	if district=="Mirpur Khas"
replace	district="Thar Parkar"	if district=="Sanghar"
replace	district="Thar Parkar"	if district=="Umerkot"
replace	district="Thar Parkar"	if district=="Tharparkar"

replace	district="Nawabshah"	if district=="Naushahro Feroze"
replace	district="Nawabshah"	if district=="Shaheed Benazirabad"

replace	district="Karachi"		if district=="Sujawal"
replace	district="Karachi"		if district=="Thatta"
replace	district="Karachi"		if district=="Karachi City"
replace	district="Karachi"		if district=="Badin"

replace	district="Upper Sind Frontier"	if district=="Jacobabad"
replace	district="Upper Sind Frontier"	if district=="Kashmore"
replace	district="Upper Sind Frontier"	if district=="Qambar Shahdadkot"

collapse (first) ADM1_EN ADM1_PCODE ADM0_EN ADM0_PCODE, by(district)

save  "${temp}Spatial\dist_aggregated.dta", replace


**Now merge with aggregated (1951 districts) shapefile in R
**Bringing in aggregated 1951 districts
shp2dta 	using "${temp}Spatial\shapefile_1951dist_agg.shp" ///
			, database("${temp}Spatial\dist_shp1_agg.dta") ///
			coordinates("${temp}Spatial\dist_shp_coor1_agg.dta") ///
			replace
						
	
**Map of aggregated districts as per 191 census
use  "${temp}Spatial\dist_shp1_agg.dta", clear

spmap  using "${temp}Spatial\dist_shp_coor1_agg.dta", ///
			id(_ID) title("Punjab and Sindh Districts - 1951", size(*1.2)) ///
			clmethod(unique) fcolor(none)

			
*Merge aggregated distrists shapefile with population data, and
*create final datasets for creating different maps
use  "${temp}Spatial\dist_shp1_agg.dta", clear
			
merge 1:1 district using "${temp}Spatial\dist_aggregated.dta"
drop if _merge==2
drop	_merge

merge 1:m district using "${final}pak_labforce_1951_district_3.dta"
drop if _merge==2
drop	_merge

bys district migrate: egen	total_1951_migstat = sum(total_1951), m
bys district urban:   egen	total_1951_urbstat = sum(total_1951), m

gen	prop_1951_imm_urban	= total_1951 / total_1951_urbstat	if urban==2	& migrate==1
gen	prop_1951_imm_rural	= total_1951 / total_1951_urbstat	if urban==1	& migrate==1

collapse (sum) total_1951 (max) prop_* total_1951_* _ID, by(district migrate)
gen prop_1951_imm_dist	= total_1951 / total_1951_dist		if migrate==1
drop	if migrate!=1

*reshape 	wide		prop_1951_imm_dist prop_1951_imm_rural prop_1951_imm_urban, ///
*						i(district) j(migrate)
*rename		prop_1951_20 	prop_1951_nat
*rename		prop_1951_21 	prop_1951_imm

save  "${final}pop_prop_maps.dta", replace



**Now create the labels for the 1951 districts
shp2dta 	using "${temp}Spatial\shapefile_1951dist_agg.shp" ///
			, database("${temp}Spatial\dist_shp1_agg_lab.dta") ///
			coordinates("${temp}Spatial\dist_shp_coor1_agg_lab.dta") ///
			genid(ID) gencentroids(c) replace
			
			
use "${temp}Spatial\dist_shp_coor1_agg_lab.dta", clear

geo2xy _Y _X,		projection( mercator) replace
local 		lon0 = r(lon0)
local 		f = r(f)
local 		a = r(a)
save "${temp}Spatial\dist_coor_mercator_agg.dta", replace

use "${temp}Spatial\dist_shp1_agg_lab.dta", clear
gen 		x = runiform()
save "${temp}Spatial\dist_shp1_agg_2.dta", replace

gen 		labtype  = 1
append 		using "${temp}Spatial\dist_shp1_agg_2.dta"
replace 	labtype = 2 if labtype==.
replace 	district = string(x, "%3.2f") if labtype ==2
geo2xy  y_c x_c,	projection( mercator, `a' `f' `lon0' ) replace
save "${temp}Spatial\dist_agg_labels.dta", replace



use "${temp}Spatial\dist_shp1_agg_2.dta", clear

spmap  using "${temp}Spatial\dist_shp_coor1_agg.dta", ///
			id(ID) title("Study Area Districts", size(*0.75))  ///
			fcolor(none) ///
			legend(pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize )  ///
			label(data("${temp}Spatial\dist_agg_labels.dta") xcoord(x_c) ycoord(y_c) ///
			label(district) by(labtype)  size(*1.2 ..) pos(12 0) )


**Now create all the required population maps
use  "${final}pop_prop_maps.dta", clear

spmap 	prop_1951_imm_dist using "${temp}Spatial\dist_shp_coor1_agg.dta", ///
			id(_ID) title("Migrants as a Proportion of Total District Population - 1951", size(*0.75))  ///
			clmethod(custom) clbreaks(0.05, 0.10, 0.20, 0.35, 0.50, 0.60) ///
			fcolor(Blues2) ///
			legend( order(2 "5%-10%" 3 "10%-20%" 4 "20%-35%" 5 "35%-50%" 6 ">50%") ///
			pos(6) row(3) ring(1) size(*2.0) symx(*.75) symy(*.75) forcesize )
graph export "${output}migrants_distprop.png", as(png) replace
			

spmap 	prop_1951_imm_urban using "${temp}Spatial\dist_shp_coor1_agg.dta", ///
			id(_ID) title("Urban Migrants as a Proportion of District's Urban Population - 1951", size(*0.7))  ///
			clmethod(custom) clbreaks(0.15, 0.25, 0.35, 0.45, 0.55, 0.75) ///
			fcolor(Blues2) ///
			legend( order(2 "15%-25%" 3 "25%-35%" 4 "35%-45%" 5 "45%-55%" 6 ">55%") ///
			pos(6) row(3) ring(1) size(*2.0) symx(*.75) symy(*.75) forcesize )
graph export "${output}urbmigrants_urbprop.png", as(png) replace
			

spmap 	prop_1951_imm_rural using "${temp}Spatial\dist_shp_coor1_agg.dta", ///
			id(_ID) title("Rural Migrants as a Proportion of District's Rural Population - 1951", size(*0.7))  ///
			clmethod(custom) clbreaks(0, 0.05, 0.15, 0.25, 0.35, 0.45) ///
			fcolor(Blues2) ///
			legend( order(2 "0.03%-5%" 3 "5%-15%" 4 "15%-25%" 5 "25%-35%" 6 ">35%") ///
			pos(6) row(3) ring(1) size(*2.0) symx(*.75) symy(*.75) forcesize )
graph export "${output}rurmigrants_rurprop.png", as(png) replace
			
			




			
			
exit

foreach dist in 	Bahawalpur Campbellpur Gujranwala Gujrat Hyderabad Jhang Jhelum ///
					Karachi Khairpur Lahore Larkana Lyallpur Mianwali Montgomery ///
					Multan Muzaffargarh Nawabshah Rawalpindi Shahpur Sheikhupura ///
					Dadu Sialkot Sukkur	{
use "${temp}Spatial\dist_aggregated.dta", clear
keep	if district=="`dist'"
mergepoly using "${temp}Spatial/dist_shp_coor1.dta", ///
			coor("${temp}Spatial/`dist'_coor.dta") replace	
save "${temp}Spatial/`dist'_outline.dta", replace
}						
			
use "${temp}Spatial\dist_aggregated.dta", clear
keep	if district=="Dera Ghazi Khan"
mergepoly using "${temp}Spatial\dist_shp_coor1.dta", ///
			coor("${temp}Spatial\DGKhan_coor.dta") replace	
save "${temp}Spatial\DGKhan_outline.dta", replace					
				
use "${temp}Spatial\dist_aggregated.dta", clear
keep	if district=="Upper Sind Frontier"
mergepoly using "${temp}Spatial\dist_shp_coor1.dta", ///
			coor("${temp}Spatial\UpperSind_coor.dta") replace	
save "${temp}Spatial\UpperSind_outline.dta", replace					
									
use "${temp}Spatial\dist_aggregated.dta", clear
keep	if district=="Thar Parkar"
mergepoly using "${temp}Spatial\dist_shp_coor1.dta", ///
			coor("${temp}Spatial\TharParkar_coor.dta") replace			
save "${temp}Spatial\TharParkar_outline.dta", replace				
			

use "${temp}Spatial\Bahawalpur_coor.dta", clear

foreach dist in Campbellpur Dadu DGKhan Gujranwala Gujrat Hyderabad Jhang Jhelum ///
				Karachi Khairpur Lahore Larkana Lyallpur Mianwali Montgomery ///
				Multan Muzaffargarh Nawabshah Rawalpindi Shahpur Sheikhupura ///
				Sialkot Sukkur TharParkar UpperSind	{
append using "${temp}Spatial/`dist'_coor.dta"
}

sort	_ID
	
save "${temp}Spatial\dist_aggregated_coor.dta", replace


use "${temp}Spatial\Bahawalpur_outline.dta", clear

foreach dist in Campbellpur Dadu DGKhan Gujranwala Gujrat Hyderabad Jhang Jhelum ///
				Karachi Khairpur Lahore Larkana Lyallpur Mianwali Montgomery ///
				Multan Muzaffargarh Nawabshah Rawalpindi Shahpur Sheikhupura ///
				Sialkot Sukkur TharParkar UpperSind	{
append using "${temp}Spatial/`dist'_outline.dta"
}
	
save "${temp}Spatial\dist_aggregated_outline.dta", replace





*create a coordinates file just for treatment indicator and draw the map 
use "${finaltemp}\dist_shp_coor.dta", clear
merge m:1 _ID using "${final}\treatment.dta"
keep if _merge==3
drop _merge
*drop if treat_code==0
*keep _ID _X _Y treat_code
save "${finaltemp}\dist_shp_coor2.dta", replace

use "${final}\treatment.dta", clear

label 	define rice 		0 "Other districts" ///
		2 "Neighbors to North & North-West of rice districts" ///
		1 "Rice growing districts" ///
		
label values treat_code rice

label 	define rice1  ///
		0 "Other districts" ///
		1 "Rice growing districts" ///
		
label values rice_dist rice1

spmap rice_dist using "${finaltemp}\dist_shp_coor.dta", ///
			id(_ID) title("Districts of Punjab", size(*1.0)) ///
			clmethod(unique) fcolor(blue green) ///
			legend(pos(6) row(3) ring(1) size(*.75) symx(*.75) symy(*.75) forcesize )
graph export "${graphs}\rice_dist.png", as(png) replace	
		  
