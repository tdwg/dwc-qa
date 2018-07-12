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

today=`date +%Y-%m-%d`
# Associative array - requires BASH version >= 4 
declare -A DWCMAP
DWCMAP[basis_of_record]=basisOfRecord
DWCMAP[country_code]=countrycode
DWCMAP[country]=country
DWCMAP[month]=month
DWCMAP[year]=year
DWCMAP[establishment_means]=establishmentMeans
DWCMAP[raw_identification_qualifier]=identificationQualifier
DWCMAP[license]=license
DWCMAP[occurrence_status_s]=occurrenceStatus
DWCMAP[reproductive_condition_s]=reproductiveCondition
DWCMAP[raw_sex]=sex
DWCMAP[rank]=taxonRank
DWCMAP[type_status]=typeStatus
#for field in basis_of_record country_code country month year establishment_means raw_identification_qualifier license occurrence_status_s reproductive_condition_s raw_sex rank type_status 

for field in "${!DWCMAP[@]}"
do
  #echo "$field -> ${DWCMAP[$field]}"
  curl -s "https://biocache.ala.org.au/ws/occurrence/facets?q=*:*&facets=${field}&flimit=999&fsort=index" | jq -r '.[] | .fieldResult[] | [.label,.count] | @csv' > ALA_distinct_${DWCMAP[$field]}_${today}.csv
done
