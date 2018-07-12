#!/usr/local/bin/bash
#
# Script to generate distinct values and counts for DwC fields in the ALA (CSV output)
# Requires the jq tool to be installed - see https://stedolan.github.io/jq/
# Requires BASH v.4+
#
# Author: Nick dos Remedios <nick.dosremedios@csiro.au> 2018-07-04
#
# requested fields:
#
# basisOfRecord, continent, countrycode, country, day, month, year, disposition, establishmentMeans, geodeticDatum, georeferenceVerificationStatus, identificationQualifier, identificationVerificationStatus, islandGroup, island, language, license, lifeStage, nomenclaturalCode, occurrenceStatus, organismScope, preparations, reproductiveCondition, sex, taxonRank, taxonomicStatus, typeStatus, type, verbatimSRS, waterbody
# ALA SOLR fields
# basis_of_record continent country_code country day year disposition establishment_means geodeticDatum georeferenceVerificationStatus identificationQualifier identificationVerificationStatus islandGroup island language license lifeStage month nomenclaturalCode occurrenceStatus organismScope preparations reproductiveCondition sex taxonRank taxonomicStatus typeStatus type verbatimSRS waterbody

# Only using present in ALA SOLR index
# see https://biocache.ala.org.au/fields for ALA field names and indexed status, etc.
# DWCMAP[foo]=bar
today=`date +%Y-%m-%d`
# Associative array - requires BASH version >= 4 
declare -A DWCMAP
DWCMAP[basis_of_record]=basisOfRecord
DWCMAP[continent]=continent
DWCMAP[country_code]=countrycode
DWCMAP[country]=country
DWCMAP[day]=day
DWCMAP[month]=month
DWCMAP[year]=year
DWCMAP[disposition]=disposition
DWCMAP[cultivated]=establishmentMeans
#DWCMAP[raw_datum]=geodeticDatum
DWCMAP[raw_identification_qualifier]=identificationQualifier
DWCMAP[identification_verification_status]=identificationVerificationStatus
DWCMAP[island_group]=islandGroup
DWCMAP[island]=island
DWCMAP[language]=language
DWCMAP[license]=license
DWCMAP[life_stage]=lifeStage
DWCMAP[nomenclatural_code]=nomenclaturalCode
DWCMAP[occurrence_status]=occurrenceStatus
DWCMAP[preparations]=preparations
DWCMAP[reproductive_condition]=reproductiveCondition
DWCMAP[raw_sex]=sex
DWCMAP[rank]=taxonRank
DWCMAP[taxonomic_status]=taxonomicStatus
DWCMAP[type_status]=typeStatus
DWCMAP[verbatim_srs]=verbatimSRS

#for field in basis_of_record country_code country month year establishment_means raw_identification_qualifier license occurrence_status_s reproductive_condition_s raw_sex rank type_status 

for field in "${!DWCMAP[@]}"
do
  #echo "$field -> ${DWCMAP[$field]}"
  prefix="_index";
  case $field in raw*)
      prefix=""
  esac
  #echo "$field -> prefix = ${PREFIX}"
  curl -s "https://biocache.ala.org.au/ws/occurrence/facets?q=*:*&facets=${field}&flimit=999&fsort=index" | jq -r '.[] | .fieldResult[] | [.label,.count] | @csv' > ALA_distinct${prefix}_${DWCMAP[$field]}_${today}.csv
done
