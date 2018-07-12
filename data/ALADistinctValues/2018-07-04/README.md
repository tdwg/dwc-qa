# ALA Distinct values for DwC fields

The data files in this directory are generated from the BASH shell script `ALA_DwC_field_counts.sh`, which calls the ALA public JSON web service for occurrence data (see https://api.ala.org.au). There is a mapping of the DwC terms to the ALA search fields (SOLR search index) in this script (line 21). The ALA fields with a prefix of `raw_` indicate the values are unprocessed (verbatim) where as the other fields may have been processed to remove duplicate values due to case or white space differences or may have been mapped to a common vocabulary (needs link). 

The ALA stores many more fields in a Cassandra database but there is no API to easliy search this database, at this time. 