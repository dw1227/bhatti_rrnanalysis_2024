#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: 
# outputs: data/references/sp_spp_lookup.tsv


curl -L https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxcat.zip \
-o data/references/taxcat.zip

unzip -n -d data/references/ data/references/taxcat.zip


if [[ $? -eq 0 ]]
 then 
     mv data/references/categories.dmp \
     data/references/sp_spp_lookup.tsv 
 else
     echo "FAIL: Could not extract taxcat.zip"
     exit 1
 fi

 
