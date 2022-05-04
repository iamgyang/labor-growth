// Macros ----------------------------------------------------------------

clear all 
set more off
set varabbrev off
set scheme s1mono
set type double, perm

// CHANGE THIS!! --- Define your own directories:
foreach user in "`c(username)'" {
	global root "C:/Users/`user'/Dropbox/CGD/Projects/dem_neg_labor"
	global output "C:/Users/`user'/Dropbox/Apps/Overleaf/Demographic Labor Effects"
}

global code        "$root/code"
global input       "$root/input"
cd "$input"
global check "yes"

// CHANGE THIS!! --- Do we want to install user-defined functions?
loc install_user_defined_functions "Yes"

if ("`install_user_defined_functions'" == "Yes") {
	foreach i in rangestat wbopendata kountry mmerge outreg2 somersd ///
	asgen moss reghdfe ftools fillmissing {
		capture quietly ssc install `i'
	}
}

// Define programs -----------------------------------------------------------

quietly capture program drop check_dup_id
program check_dup_id
	args id_vars
	preserve
	keep `id_vars'
	sort `id_vars'
    quietly by `id_vars':  gen dup = cond(_N==1,0,_n)
	assert dup == 0
	restore
	end

quietly capture program drop naomit
program naomit
	foreach var of varlist _all {
		drop if missing(`var')
	}
	end

quietly capture program drop conv_ccode
program conv_ccode
args country_var
	kountry `country_var', from(other) stuck
	ren(_ISO3N_) (temp)
	kountry temp, from(iso3n) to(iso3c)
	drop temp
	ren (_ISO3C_) (iso3c)
end

quietly capture program drop append_all_dta
program append_all_dta
args input_directory output_directory NAME
	clear
	cd "`input_directory'"
	local filepath = "`c(pwd)'" // Save path to current folder in a local
	di "`c(pwd)'" // Display path to current folder
	local files : dir "`filepath'" files "*.dta" // Save name of all files in folder ending with .dta in a local
	di `"`files'"' // Display list of files to import data from
	tempfile master // Generate temporary save file to store data in
	save `master', replace empty
	foreach x of local files {
		di "`x'" // Display file name

		* 2A) Import each file
		qui: use "`x'", clear // Import file
		qui: gen id = subinstr("`x'", ".dta", "", .)	// Generate id variable (same as file name but without .dta)

		* 2B) Append each file to masterfile
		append using `master', force
		save `master', replace
	}
	order id, first
	sort id
	cd "`output_directory'"
	save "`NAME'.dta", replace
end	


quietly capture program drop conv_ccode_un
program conv_ccode_un
args country
	replace iso3c = "BOL" if `country' == "Bolivia (Plurinational State of)"
	replace iso3c = "CPV" if `country' == "Cabo Verde"
	replace iso3c = "HKG" if `country' == "China, Hong Kong SAR"
	replace iso3c = "MAC" if `country' == "China, Macao SAR"
	replace iso3c = "TWN" if `country' == "China, Taiwan Province of China"
	replace iso3c = "CIV" if `country' == "CÃ´te d'Ivoire"
	replace iso3c = "PRK" if `country' == "Dem. People's Republic of Korea"
	replace iso3c = "SWZ" if `country' == "Eswatini"
	replace iso3c = "PSE" if `country' == "State of Palestine"
	replace iso3c = "VEN" if `country' == "Venezuela (Bolivarian Republic of)"
	replace iso3c = "XKX" if `country' == "Kosovo"
	replace iso3c = "MKD" if `country' == "North Macedonia"
	replace iso3c = "CUW" if `country' == "CuraÃ§ao"
	replace iso3c = "REU" if `country' == "RÃ©union"
	replace iso3c = "FSM" if `country' == "Micronesia (Fed. States of)"
	replace iso3c = "PYF" if `country' == "French Polynesia"
	replace iso3c = "BES" if `country' == "Bonaire, Sint Eustatius and Saba"
	replace iso3c = "IMN" if `country' == "Isle of Man"
	replace iso3c = "MNP" if `country' == "Northern Mariana Islands"
	replace iso3c = "MAF" if `country' == "Saint Martin (French part)"
	replace iso3c = "SXM" if `country' == "Sint Maarten (Dutch part)"
	replace iso3c = "TKL" if `country' == "Tokelau"	
	
	drop if `country' == "Polynesia" // Polynesia refers to the REGION, not the COLONY
	drop if `country' == "Micronesia" // we have fed states of micronesia, which is the Country; micronesia is the REGION
	drop if `country' == "Africa"
	drop if `country' == "Channel Islands"
	drop if `country' == "Oceania"
	drop if `country' == "Melanesia"
	drop if `country' == "African Group"
	drop if `country' == "African Union"
	drop if `country' == "African Union: Central Africa"
	drop if `country' == "African Union: Eastern Africa"
	drop if `country' == "African Union: Northern Africa"
	drop if `country' == "African Union: Southern Africa"
	drop if `country' == "African Union: Western Africa"
	drop if `country' == "African, Caribbean and Pacific (ACP) Group of States"
	drop if `country' == "Andean Community"
	drop if `country' == "Asia"
	drop if `country' == "Asia-Pacific Economic Cooperation (APEC)"
	drop if `country' == "Asia-Pacific Group"
	drop if `country' == "Association of Southeast Asian Nations (ASEAN)"
	drop if `country' == "Australia/New Zealand"
	drop if `country' == "BRIC"
	drop if `country' == "BRICS"
	drop if `country' == "Belt-Road Initiative (BRI)"
	drop if `country' == "Belt-Road Initiative: Africa"
	drop if `country' == "Belt-Road Initiative: Asia"
	drop if `country' == "Belt-Road Initiative: Europe"
	drop if `country' == "Belt-Road Initiative: Latin America and the Caribbean"
	drop if `country' == "Belt-Road Initiative: Pacific"
	drop if `country' == "Black Sea Economic Cooperation (BSEC)"
	drop if `country' == "Bolivarian Alliance for the Americas (ALBA)"
	drop if `country' == "Caribbean"
	drop if `country' == "Caribbean Community and Common Market (CARICOM)"
	drop if `country' == "Central America"
	drop if `country' == "Central Asia"
	drop if `country' == "Central European Free Trade Agreement (CEFTA)"
	drop if `country' == "Central and Southern Asia"
	drop if `country' == "China (and dependencies)"
	drop if `country' == "Commonwealth of Independent States (CIS)"
	drop if `country' == "Commonwealth of Nations"
	drop if `country' == "Commonwealth: Africa"
	drop if `country' == "Commonwealth: Asia"
	drop if `country' == "Commonwealth: Caribbean and Americas"
	drop if `country' == "Commonwealth: Europe"
	drop if `country' == "Commonwealth: Pacific"
	drop if `country' == "Countries with Access to the Sea"
	drop if `country' == "Countries with Access to the Sea: Africa"
	drop if `country' == "Countries with Access to the Sea: Asia"
	drop if `country' == "Countries with Access to the Sea: Europe"
	drop if `country' == "Countries with Access to the Sea: Latin America and the Caribbean"
	drop if `country' == "Countries with Access to the Sea: Northern America"
	drop if `country' == "Countries with Access to the Sea: Oceania"
	drop if `country' == "Czechia"
	drop if `country' == "Denmark (and dependencies)"
	drop if `country' == "ECE: North America-2"
	drop if `country' == "ECE: UNECE-52"
	drop if `country' == "ECLAC: Latin America"
	drop if `country' == "ECLAC: The Caribbean"
	drop if `country' == "ESCAP region: East and North-East Asia"
	drop if `country' == "ESCAP region: North and Central Asia"
	drop if `country' == "ESCAP region: Pacific"
	drop if `country' == "ESCAP region: South and South-West Asia"
	drop if `country' == "ESCAP region: South-East Asia"
	drop if `country' == "ESCAP: ADB Developing member countries (DMCs)"
	drop if `country' == "ESCAP: ADB Group A (Concessional assistanceÂ only)"
	drop if `country' == "ESCAP: ADB Group BÂ (OCR blend)"
	drop if `country' == "ESCAP: ADB Group C (Regular OCR only)"
	drop if `country' == "ESCAP: ASEAN"
	drop if `country' == "ESCAP: Central Asia"
	drop if `country' == "ESCAP: ECO"
	drop if `country' == "ESCAP: HDI groups"
	drop if `country' == "ESCAP: Landlocked countries (LLDCs)"
	drop if `country' == "ESCAP: Least Developed Countries (LDCs)"
	drop if `country' == "ESCAP: Pacific island dev. econ."
	drop if `country' == "ESCAP: SAARC"
	drop if `country' == "ESCAP: WB High income econ."
	drop if `country' == "ESCAP: WB Low income econ."
	drop if `country' == "ESCAP: WB Lower middle income econ."
	drop if `country' == "ESCAP: WB Upper middle income econ."
	drop if `country' == "ESCAP: WB income groups"
	drop if `country' == "ESCAP: high HDI"
	drop if `country' == "ESCAP: high income"
	drop if `country' == "ESCAP: income groups"
	drop if `country' == "ESCAP: low HDI"
	drop if `country' == "ESCAP: low income"
	drop if `country' == "ESCAP: lower middle HDI"
	drop if `country' == "ESCAP: lower middle income"
	drop if `country' == "ESCAP: other Asia-Pacific countries/areas"
	drop if `country' == "ESCAP: upper middle HDI"
	drop if `country' == "ESCAP: upper middle income"
	drop if `country' == "ESCWA: Arab countries"
	drop if `country' == "ESCWA: Arab least developed countries"
	drop if `country' == "ESCWA: Gulf Cooperation Council countries"
	drop if `country' == "ESCWA: Maghreb countries"
	drop if `country' == "ESCWA: Mashreq countries"
	drop if `country' == "ESCWA: member countries"
	drop if `country' == "East African Community (EAC)"
	drop if `country' == "Eastern Africa"
	drop if `country' == "Eastern Asia"
	drop if `country' == "Eastern Europe"
	drop if `country' == "Eastern European Group"
	drop if `country' == "Eastern and South-Eastern Asia"
	drop if `country' == "Economic Community of Central African States (ECCAS)"
	drop if `country' == "Economic Community of West African States (ECOWAS)"
	drop if `country' == "Economic Cooperation Organization (ECO)"
	drop if `country' == "Eurasian Economic Community (Eurasec)"
	drop if `country' == "Europe"
	drop if `country' == "Europe (48)"
	drop if `country' == "Europe and Northern America"
	drop if `country' == "European Community (EC: 12)"
	drop if `country' == "European Free Trade Agreement (EFTA)"
	drop if `country' == "European Union (EU: 15)"
	drop if `country' == "European Union (EU: 28)"
	drop if `country' == "France (and dependencies)"
	drop if `country' == "Greater Arab Free Trade Area (GAFTA)"
	drop if `country' == "Group of 77 (G77)"
	drop if `country' == "Group of Eight (G8)"
	drop if `country' == "Group of Seven (G7)"
	drop if `country' == "Group of Twenty (G20) - member states"
	drop if `country' == "Gulf Cooperation Council (GCC)"
	drop if `country' == "High-income countries"
	drop if `country' == "LLDC: Africa"
	drop if `country' == "LLDC: Asia"
	drop if `country' == "LLDC: Europe"
	drop if `country' == "LLDC: Latin America"
	drop if `country' == "Land-locked Countries"
	drop if `country' == "Land-locked Countries (Others)"
	drop if `country' == "Land-locked Developing Countries (LLDC)"
	drop if `country' == "Latin America and the Caribbean"
	drop if `country' == "Latin American Integration Association (ALADI)"
	drop if `country' == "Latin American and Caribbean Group (GRULAC)"
	drop if `country' == "League of Arab States (LAS, informal name: Arab League)"
	drop if `country' == "Least developed countries"
	drop if `country' == "Least developed: Africa"
	drop if `country' == "Least developed: Asia"
	drop if `country' == "Least developed: Latin America and the Caribbean"
	drop if `country' == "Least developed: Oceania"
	drop if `country' == "Less developed regions"
	drop if `country' == "Less developed regions, excluding China"
	drop if `country' == "Less developed regions, excluding least developed countries"
	drop if `country' == "Less developed: Africa"
	drop if `country' == "Less developed: Asia"
	drop if `country' == "Less developed: Latin America and the Caribbean"
	drop if `country' == "Less developed: Oceania"
	drop if `country' == "Low-income countries"
	drop if `country' == "Lower-middle-income countries"
	drop if `country' == "Middle Africa"
	drop if `country' == "Middle-income countries"
	drop if `country' == "More developed regions"
	drop if `country' == "More developed: Asia"
	drop if `country' == "More developed: Europe"
	drop if `country' == "More developed: Northern America"
	drop if `country' == "More developed: Oceania"
	drop if `country' == "Netherlands (and dependencies)"
	drop if `country' == "New EU member states (joined since 2004)"
	drop if `country' == "New Zealand (and dependencies)"
	drop if `country' == "No income group available"
	drop if `country' == "Non-Self-Governing Territories"
	drop if `country' == "North American Free Trade Agreement (NAFTA)"
	drop if `country' == "North Atlantic Treaty Organization (NATO)"
	drop if `country' == "Northern Africa"
	drop if `country' == "Northern Africa and Western Asia"
	drop if `country' == "Northern America"
	drop if `country' == "Northern Europe"
	drop if `country' == "Oceania (excluding Australia and New Zealand)"
	drop if `country' == "Organisation for Economic Co-operation and Development (OECD)"
	drop if `country' == "Organization for Security and Co-operation in Europe (OSCE)"
	drop if `country' == "Organization of American States (OAS)"
	drop if `country' == "Organization of Petroleum Exporting countries (OPEC)"
	drop if `country' == "Organization of the Islamic Conference (OIC)"
	drop if `country' == "SIDS Atlantic, and Indian Ocean, Mediterranean and South China Sea (AIMS)"
	drop if `country' == "SIDS Caribbean"
	drop if `country' == "SIDS Pacific"
	drop if `country' == "Shanghai Cooperation Organization (SCO)"
	drop if `country' == "Small Island Developing States (SIDS)"
	drop if `country' == "South America"
	drop if `country' == "South Asian Association for Regional Cooperation (SAARC)"
	drop if `country' == "South-Eastern Asia"
	drop if `country' == "Southern Africa"
	drop if `country' == "Southern African Development Community (SADC)"
	drop if `country' == "Southern Asia"
	drop if `country' == "Southern Common Market (MERCOSUR)"
	drop if `country' == "Southern Europe"
	drop if `country' == "Sub-Saharan Africa"
	drop if `country' == "UN-ECE: member countries"
	drop if `country' == "UNFPA Regions"
	drop if `country' == "UNFPA: Arab States (AS)"
	drop if `country' == "UNFPA: Asia and the Pacific (AP)"
	drop if `country' == "UNFPA: East and Southern Africa (ESA)"
	drop if `country' == "UNFPA: Eastern Europe and Central Asia (EECA)"
	drop if `country' == "UNFPA: Latin America and the Caribbean (LAC)"
	drop if `country' == "UNFPA: West and Central Africa (WCA)"
	drop if `country' == "UNICEF PROGRAMME REGIONS"
	drop if `country' == "UNICEF Programme Regions: East Asia and Pacific (EAPRO)"
	drop if `country' == "UNICEF Programme Regions: Eastern Caribbean"
	drop if `country' == "UNICEF Programme Regions: Eastern and Southern Africa (ESARO)"
	drop if `country' == "UNICEF Programme Regions: Europe and Central Asia (CEECIS)"
	drop if `country' == "UNICEF Programme Regions: Latin America"
	drop if `country' == "UNICEF Programme Regions: Latin America and Caribbean (LACRO)"
	drop if `country' == "UNICEF Programme Regions: Middle East and North Africa (MENARO)"
	drop if `country' == "UNICEF Programme Regions: South Asia (ROSA)"
	drop if `country' == "UNICEF Programme Regions: West and Central Africa (WCARO)"
	drop if `country' == "UNICEF REGIONS"
	drop if `country' == "UNICEF Regions: East Asia and Pacific"
	drop if `country' == "UNICEF Regions: Eastern Europe and Central Asia"
	drop if `country' == "UNICEF Regions: Eastern and Southern Africa"
	drop if `country' == "UNICEF Regions: Europe and Central Asia"
	drop if `country' == "UNICEF Regions: Latin America and Caribbean"
	drop if `country' == "UNICEF Regions: Middle East and North Africa"
	drop if `country' == "UNICEF Regions: North America"
	drop if `country' == "UNICEF Regions: South Asia"
	drop if `country' == "UNICEF Regions: Sub-Saharan Africa"
	drop if `country' == "UNICEF Regions: West and Central Africa"
	drop if `country' == "UNICEF Regions: Western Europe"
	drop if `country' == "UNITED NATIONS Regional Groups of Member States"
	drop if `country' == "United Kingdom (and dependencies)"
	drop if `country' == "United Nations Economic Commission for Africa (UN-ECA)"
	drop if `country' == "United Nations Economic Commission for Latin America and the Caribbean (UN-ECLAC)"
	drop if `country' == "United Nations Economic and Social Commission for Asia and the Pacific (UN-ESCAP) Regions"
	drop if `country' == "United Nations Member States"
	drop if `country' == "United States of America (and dependencies)"
	drop if `country' == "Upper-middle-income countries"
	drop if `country' == "WB region: East Asia and Pacific (excluding high income)"
	drop if `country' == "WB region: Europe and Central Asia (excluding high income)"
	drop if `country' == "WB region: Latin America and Caribbean (excluding high income)"
	drop if `country' == "WB region: Middle East and North Africa (excluding high income)"
	drop if `country' == "WB region: South Asia (excluding high income)"
	drop if `country' == "WB region: Sub-Saharan Africa (excluding high income)"
	drop if `country' == "WHO Regions"
	drop if `country' == "WHO: African region (AFRO)"
	drop if `country' == "WHO: Americas (AMRO)"
	drop if `country' == "WHO: Eastern Mediterranean Region (EMRO)"
	drop if `country' == "WHO: European Region (EURO)"
	drop if `country' == "WHO: South-East Asia region (SEARO)"
	drop if `country' == "WHO: Western Pacific region (WPRO)"
	drop if `country' == "West African Economic and Monetary Union (UEMOA)"
	drop if `country' == "Western Africa"
	drop if `country' == "Western Asia"
	drop if `country' == "Western Europe"
	drop if `country' == "Western European and Others Group (WEOG)"
	drop if `country' == "World"
	drop if `country' == "World Bank Regional Groups (developing only)"
	drop if `country' == "ESCAP: ADB groups"
	drop if `country' == "ESCAP: Other Regional Groups"
	drop if `country' == "Economic groups"
	drop if `country' == "Geographic regions"
	drop if `country' == "International groups"
	drop if `country' == "Regional political groups: Africa"
	drop if `country' == "Regional political groups: Americas"
	drop if `country' == "Regional political groups: Arab"
	drop if `country' == "Regional political groups: Asia and Oceania"
	drop if `country' == "Regional political groups: Europe"
	drop if `country' == "Regional trade groups: Africa"
	drop if `country' == "Regional trade groups: Americas"
	drop if `country' == "Regional trade groups: Arab"
	drop if `country' == "Regional trade groups: Asia"
	drop if `country' == "Regional trade groups: Europe"
	drop if `country' == "Saint BarthÃ©lemy"
	drop if `country' == "Sustainable Development Goal (SDG) regions"
	drop if `country' == "UN development groups"
	drop if `country' == "United Nations Economic Commission for Europe (UN-ECE)"
	drop if `country' == "United Nations Economic and Social Commission for Western Asia (UN-ESCWA)"
	drop if `country' == "United Nations Regional Commissions"
	drop if `country' == "World Bank income groups"	
end
