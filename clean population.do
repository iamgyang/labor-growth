// Macros ---------------------------------------------------------------------
foreach user in "`c(username)'" {
	global root "C:/Users/`user'/Dropbox/CGD GlobalSat/"
	global hf_input "$root/HF_measures/input/"
	global ntl_input "$hf_input/NTL Extracted Data 2012-2020/"
}
set more off 
cd "$hf_input"

// UN population estimates -------------------------------------------

import delimited "un_WPP2019_PopulationByAgeSex_Medium.csv", clear
keep if variant == "Medium"
keep location time agegrp agegrpstart agegrpspan poptotal
gen agegrpstart2 = min(agegrpstart, 80)
collapse (sum) poptotal, by(location time)
replace poptotal = poptotal * 1000
rename location country

// convert country names to ISO3c codes
kountry country, from(other) stuck
ren(_ISO3N_) (temp)
kountry temp, from(iso3n) to(iso3c)
ren (_ISO3C_) (iso3c)

if (1==1) {
	replace iso3c = "BOL" if country == "Bolivia (Plurinational State of)"
	replace iso3c = "CPV" if country == "Cabo Verde"
	replace iso3c = "HKG" if country == "China, Hong Kong SAR"
	replace iso3c = "MAC" if country == "China, Macao SAR"
	replace iso3c = "TWN" if country == "China, Taiwan Province of China"
	replace iso3c = "CIV" if country == "CÃ´te d'Ivoire"
	replace iso3c = "PRK" if country == "Dem. People's Republic of Korea"
	replace iso3c = "SWZ" if country == "Eswatini"
	replace iso3c = "PSE" if country == "State of Palestine"
	replace iso3c = "VEN" if country == "Venezuela (Bolivarian Republic of)"
	replace iso3c = "XKX" if country == "Kosovo"
	replace iso3c = "MKD" if country == "North Macedonia"
	replace iso3c = "CUW" if country == "CuraÃ§ao"
	replace iso3c = "REU" if country == "RÃ©union"
	replace iso3c = "FSM" if country == "Micronesia (Fed. States of)"
	replace iso3c = "PYF" if country == "French Polynesia"
	
	drop temp
	drop if country == "Polynesia" // Polynesia refers to the REGION, not the COLONY
	drop if country == "Micronesia" // we have fed states of micronesia, which is the COUNTRY; micronesia is the REGION
	drop if country == "Africa"
	drop if country == "Channel Islands"
	drop if country == "Oceania"
	drop if country == "Melanesia"
	drop if country == "African Group"
	drop if country == "African Union"
	drop if country == "African Union: Central Africa"
	drop if country == "African Union: Eastern Africa"
	drop if country == "African Union: Northern Africa"
	drop if country == "African Union: Southern Africa"
	drop if country == "African Union: Western Africa"
	drop if country == "African, Caribbean and Pacific (ACP) Group of States"
	drop if country == "Andean Community"
	drop if country == "Asia"
	drop if country == "Asia-Pacific Economic Cooperation (APEC)"
	drop if country == "Asia-Pacific Group"
	drop if country == "Association of Southeast Asian Nations (ASEAN)"
	drop if country == "Australia/New Zealand"
	drop if country == "BRIC"
	drop if country == "BRICS"
	drop if country == "Belt-Road Initiative (BRI)"
	drop if country == "Belt-Road Initiative: Africa"
	drop if country == "Belt-Road Initiative: Asia"
	drop if country == "Belt-Road Initiative: Europe"
	drop if country == "Belt-Road Initiative: Latin America and the Caribbean"
	drop if country == "Belt-Road Initiative: Pacific"
	drop if country == "Black Sea Economic Cooperation (BSEC)"
	drop if country == "Bolivarian Alliance for the Americas (ALBA)"
	drop if country == "Caribbean"
	drop if country == "Caribbean Community and Common Market (CARICOM)"
	drop if country == "Central America"
	drop if country == "Central Asia"
	drop if country == "Central European Free Trade Agreement (CEFTA)"
	drop if country == "Central and Southern Asia"
	drop if country == "China (and dependencies)"
	drop if country == "Commonwealth of Independent States (CIS)"
	drop if country == "Commonwealth of Nations"
	drop if country == "Commonwealth: Africa"
	drop if country == "Commonwealth: Asia"
	drop if country == "Commonwealth: Caribbean and Americas"
	drop if country == "Commonwealth: Europe"
	drop if country == "Commonwealth: Pacific"
	drop if country == "Countries with Access to the Sea"
	drop if country == "Countries with Access to the Sea: Africa"
	drop if country == "Countries with Access to the Sea: Asia"
	drop if country == "Countries with Access to the Sea: Europe"
	drop if country == "Countries with Access to the Sea: Latin America and the Caribbean"
	drop if country == "Countries with Access to the Sea: Northern America"
	drop if country == "Countries with Access to the Sea: Oceania"
	drop if country == "Czechia"
	drop if country == "Denmark (and dependencies)"
	drop if country == "ECE: North America-2"
	drop if country == "ECE: UNECE-52"
	drop if country == "ECLAC: Latin America"
	drop if country == "ECLAC: The Caribbean"
	drop if country == "ESCAP region: East and North-East Asia"
	drop if country == "ESCAP region: North and Central Asia"
	drop if country == "ESCAP region: Pacific"
	drop if country == "ESCAP region: South and South-West Asia"
	drop if country == "ESCAP region: South-East Asia"
	drop if country == "ESCAP: ADB Developing member countries (DMCs)"
	drop if country == "ESCAP: ADB Group A (Concessional assistanceÂ only)"
	drop if country == "ESCAP: ADB Group BÂ (OCR blend)"
	drop if country == "ESCAP: ADB Group C (Regular OCR only)"
	drop if country == "ESCAP: ASEAN"
	drop if country == "ESCAP: Central Asia"
	drop if country == "ESCAP: ECO"
	drop if country == "ESCAP: HDI groups"
	drop if country == "ESCAP: Landlocked countries (LLDCs)"
	drop if country == "ESCAP: Least Developed Countries (LDCs)"
	drop if country == "ESCAP: Pacific island dev. econ."
	drop if country == "ESCAP: SAARC"
	drop if country == "ESCAP: WB High income econ."
	drop if country == "ESCAP: WB Low income econ."
	drop if country == "ESCAP: WB Lower middle income econ."
	drop if country == "ESCAP: WB Upper middle income econ."
	drop if country == "ESCAP: WB income groups"
	drop if country == "ESCAP: high HDI"
	drop if country == "ESCAP: high income"
	drop if country == "ESCAP: income groups"
	drop if country == "ESCAP: low HDI"
	drop if country == "ESCAP: low income"
	drop if country == "ESCAP: lower middle HDI"
	drop if country == "ESCAP: lower middle income"
	drop if country == "ESCAP: other Asia-Pacific countries/areas"
	drop if country == "ESCAP: upper middle HDI"
	drop if country == "ESCAP: upper middle income"
	drop if country == "ESCWA: Arab countries"
	drop if country == "ESCWA: Arab least developed countries"
	drop if country == "ESCWA: Gulf Cooperation Council countries"
	drop if country == "ESCWA: Maghreb countries"
	drop if country == "ESCWA: Mashreq countries"
	drop if country == "ESCWA: member countries"
	drop if country == "East African Community (EAC)"
	drop if country == "Eastern Africa"
	drop if country == "Eastern Asia"
	drop if country == "Eastern Europe"
	drop if country == "Eastern European Group"
	drop if country == "Eastern and South-Eastern Asia"
	drop if country == "Economic Community of Central African States (ECCAS)"
	drop if country == "Economic Community of West African States (ECOWAS)"
	drop if country == "Economic Cooperation Organization (ECO)"
	drop if country == "Eurasian Economic Community (Eurasec)"
	drop if country == "Europe"
	drop if country == "Europe (48)"
	drop if country == "Europe and Northern America"
	drop if country == "European Community (EC: 12)"
	drop if country == "European Free Trade Agreement (EFTA)"
	drop if country == "European Union (EU: 15)"
	drop if country == "European Union (EU: 28)"
	drop if country == "France (and dependencies)"
	drop if country == "Greater Arab Free Trade Area (GAFTA)"
	drop if country == "Group of 77 (G77)"
	drop if country == "Group of Eight (G8)"
	drop if country == "Group of Seven (G7)"
	drop if country == "Group of Twenty (G20) - member states"
	drop if country == "Gulf Cooperation Council (GCC)"
	drop if country == "High-income countries"
	drop if country == "LLDC: Africa"
	drop if country == "LLDC: Asia"
	drop if country == "LLDC: Europe"
	drop if country == "LLDC: Latin America"
	drop if country == "Land-locked Countries"
	drop if country == "Land-locked Countries (Others)"
	drop if country == "Land-locked Developing Countries (LLDC)"
	drop if country == "Latin America and the Caribbean"
	drop if country == "Latin American Integration Association (ALADI)"
	drop if country == "Latin American and Caribbean Group (GRULAC)"
	drop if country == "League of Arab States (LAS, informal name: Arab League)"
	drop if country == "Least developed countries"
	drop if country == "Least developed: Africa"
	drop if country == "Least developed: Asia"
	drop if country == "Least developed: Latin America and the Caribbean"
	drop if country == "Least developed: Oceania"
	drop if country == "Less developed regions"
	drop if country == "Less developed regions, excluding China"
	drop if country == "Less developed regions, excluding least developed countries"
	drop if country == "Less developed: Africa"
	drop if country == "Less developed: Asia"
	drop if country == "Less developed: Latin America and the Caribbean"
	drop if country == "Less developed: Oceania"
	drop if country == "Low-income countries"
	drop if country == "Lower-middle-income countries"
	drop if country == "Middle Africa"
	drop if country == "Middle-income countries"
	drop if country == "More developed regions"
	drop if country == "More developed: Asia"
	drop if country == "More developed: Europe"
	drop if country == "More developed: Northern America"
	drop if country == "More developed: Oceania"
	drop if country == "Netherlands (and dependencies)"
	drop if country == "New EU member states (joined since 2004)"
	drop if country == "New Zealand (and dependencies)"
	drop if country == "No income group available"
	drop if country == "Non-Self-Governing Territories"
	drop if country == "North American Free Trade Agreement (NAFTA)"
	drop if country == "North Atlantic Treaty Organization (NATO)"
	drop if country == "Northern Africa"
	drop if country == "Northern Africa and Western Asia"
	drop if country == "Northern America"
	drop if country == "Northern Europe"
	drop if country == "Oceania (excluding Australia and New Zealand)"
	drop if country == "Organisation for Economic Co-operation and Development (OECD)"
	drop if country == "Organization for Security and Co-operation in Europe (OSCE)"
	drop if country == "Organization of American States (OAS)"
	drop if country == "Organization of Petroleum Exporting countries (OPEC)"
	drop if country == "Organization of the Islamic Conference (OIC)"
	drop if country == "SIDS Atlantic, and Indian Ocean, Mediterranean and South China Sea (AIMS)"
	drop if country == "SIDS Caribbean"
	drop if country == "SIDS Pacific"
	drop if country == "Shanghai Cooperation Organization (SCO)"
	drop if country == "Small Island Developing States (SIDS)"
	drop if country == "South America"
	drop if country == "South Asian Association for Regional Cooperation (SAARC)"
	drop if country == "South-Eastern Asia"
	drop if country == "Southern Africa"
	drop if country == "Southern African Development Community (SADC)"
	drop if country == "Southern Asia"
	drop if country == "Southern Common Market (MERCOSUR)"
	drop if country == "Southern Europe"
	drop if country == "Sub-Saharan Africa"
	drop if country == "UN-ECE: member countries"
	drop if country == "UNFPA Regions"
	drop if country == "UNFPA: Arab States (AS)"
	drop if country == "UNFPA: Asia and the Pacific (AP)"
	drop if country == "UNFPA: East and Southern Africa (ESA)"
	drop if country == "UNFPA: Eastern Europe and Central Asia (EECA)"
	drop if country == "UNFPA: Latin America and the Caribbean (LAC)"
	drop if country == "UNFPA: West and Central Africa (WCA)"
	drop if country == "UNICEF PROGRAMME REGIONS"
	drop if country == "UNICEF Programme Regions: East Asia and Pacific (EAPRO)"
	drop if country == "UNICEF Programme Regions: Eastern Caribbean"
	drop if country == "UNICEF Programme Regions: Eastern and Southern Africa (ESARO)"
	drop if country == "UNICEF Programme Regions: Europe and Central Asia (CEECIS)"
	drop if country == "UNICEF Programme Regions: Latin America"
	drop if country == "UNICEF Programme Regions: Latin America and Caribbean (LACRO)"
	drop if country == "UNICEF Programme Regions: Middle East and North Africa (MENARO)"
	drop if country == "UNICEF Programme Regions: South Asia (ROSA)"
	drop if country == "UNICEF Programme Regions: West and Central Africa (WCARO)"
	drop if country == "UNICEF REGIONS"
	drop if country == "UNICEF Regions: East Asia and Pacific"
	drop if country == "UNICEF Regions: Eastern Europe and Central Asia"
	drop if country == "UNICEF Regions: Eastern and Southern Africa"
	drop if country == "UNICEF Regions: Europe and Central Asia"
	drop if country == "UNICEF Regions: Latin America and Caribbean"
	drop if country == "UNICEF Regions: Middle East and North Africa"
	drop if country == "UNICEF Regions: North America"
	drop if country == "UNICEF Regions: South Asia"
	drop if country == "UNICEF Regions: Sub-Saharan Africa"
	drop if country == "UNICEF Regions: West and Central Africa"
	drop if country == "UNICEF Regions: Western Europe"
	drop if country == "UNITED NATIONS Regional Groups of Member States"
	drop if country == "United Kingdom (and dependencies)"
	drop if country == "United Nations Economic Commission for Africa (UN-ECA)"
	drop if country == "United Nations Economic Commission for Latin America and the Caribbean (UN-ECLAC)"
	drop if country == "United Nations Economic and Social Commission for Asia and the Pacific (UN-ESCAP) Regions"
	drop if country == "United Nations Member States"
	drop if country == "United States of America (and dependencies)"
	drop if country == "Upper-middle-income countries"
	drop if country == "WB region: East Asia and Pacific (excluding high income)"
	drop if country == "WB region: Europe and Central Asia (excluding high income)"
	drop if country == "WB region: Latin America and Caribbean (excluding high income)"
	drop if country == "WB region: Middle East and North Africa (excluding high income)"
	drop if country == "WB region: South Asia (excluding high income)"
	drop if country == "WB region: Sub-Saharan Africa (excluding high income)"
	drop if country == "WHO Regions"
	drop if country == "WHO: African region (AFRO)"
	drop if country == "WHO: Americas (AMRO)"
	drop if country == "WHO: Eastern Mediterranean Region (EMRO)"
	drop if country == "WHO: European Region (EURO)"
	drop if country == "WHO: South-East Asia region (SEARO)"
	drop if country == "WHO: Western Pacific region (WPRO)"
	drop if country == "West African Economic and Monetary Union (UEMOA)"
	drop if country == "Western Africa"
	drop if country == "Western Asia"
	drop if country == "Western Europe"
	drop if country == "Western European and Others Group (WEOG)"
	drop if country == "World"
	drop if country == "World Bank Regional Groups (developing only)"   
}

if ("$check" == "yes") {
	pause on
	preserve
	keep country iso3c
	duplicates drop
	br
	pause "does everything look okay?"
	restore
	pause off    
}

drop country
rename (time) (year)

save un_pop_estimates_cleaned.dta, replace

// WDI population estimates --------------------------------------------------
clear
wbopendata, clear nometadata long indicator(SP.POP.TOTL) year(1960:2021)
drop if regionname == "Aggregates"
keep countrycode year sp_pop_totl
rename (countrycode sp_pop_totl) (iso3c poptotal)
fillin iso3c year
drop _fillin
sort iso3c year
bysort iso3c year: gen dup = _n
assert dup == 1
drop dup
br if poptotal ==.
replace poptotal = poptotal[_n-1] if poptotal == . & iso3c[_n] == iso3c[_n-1]

save wb_pop_estimates_cleaned.dta, replace









