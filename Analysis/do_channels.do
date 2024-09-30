****	This do file looks at the potential mechanisms	****

****	Included: Table 3 & Table A13					****

use "${...}pak_labforce_1951_tehsil.dta", clear
encode tehsil, gen(tehsilpk)
		
replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2
		
reg prop_nonag migrate i.tehsilpk, cluster(tehsilpk)		
outreg2  using mech_reg3.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  replace ///
				title(Share of Non-Agricultural Workforce in 1951) ///
				ctitle(Tehsil Level, ) tex keep(migrate) nocons ///
				addtext(Urban Dummy, No, Tehsil FE, Yes)
				
				
use "${...}pak_labforce_1951_tehsil_urban_2.dta", clear
encode tehsil, gen(tehsilpk)
		
replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2		

replace urban = 0 		if urban==1
replace urban = 1		if urban==2	

gen 	mig_urban = 0
replace mig_urban = 1 if migrate==1 & urban==1	

reg prop_nonag urban migrate i.tehsilpk if urban==1, cluster(tehsilpk)		
outreg2  using mech_reg3.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  append ///
				title(Share of Non-Agricultural Workforce in 1951) ///
				ctitle(Urban Areas, ) tex keep(migrate) nocons ///
				addtext(Urban Dummy, Yes, Tehsil FE, Yes)		

reg prop_nonag urban migrate i.tehsilpk if urban==0, cluster(tehsilpk)		
outreg2  using mech_reg3.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  append ///
				title(Share of Non-Agricultural Workforce in 1951) ///
				ctitle(Rural Areas, ) tex keep(migrate mig_urban) nocons ///
				addtext(Urban Dummy, Yes, Tehsil FE, Yes)										
		


use "${...}pak_labforce_1951_tehsil_urban.dta", clear
encode tehsil, gen(tehsilpk)
		
replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2		

		
reg proppop_urban migrate i.tehsilpk, cluster(tehsilpk)		
outreg2  using mech_reg1.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  replace ///
				title(Share of Urban Population in 1951) ///
				ctitle(Only Urban, Areas) tex keep(migrate) nocons ///
				addtext(Urban Dummy, N/A, Tehsil FE, Yes)
				



use "${...}pak_labforce_1951_tehsil_urban_2.dta", clear
encode tehsil, gen(tehsilpk)
		
replace	migrate = 0		if migrate==1
replace migrate = 1		if migrate==2		

replace urban = 0 		if urban==1
replace urban = 1		if urban==2	

gen 	mig_urban = 0
replace mig_urban = 1 if migrate==1 & urban==1
		
reg proppop urban mig_urban i.tehsilpk, cluster(tehsilpk)		
outreg2  using mech_reg1.tex, sdec(4) bdec(4) alpha(0.01, 0.05, 0.1) ///
				symbol(***, **, *) stats(coef se)  append ///
				title(Share of Urban Population in 1951) ///
				ctitle(All, Areas) tex keep(urban mig_urban) nocons ///
				addtext(Urban Dummy, Yes, Tehsil FE, Yes)






	 

