#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: 
# outputs: data/references/ncbi_names_lookup.tsv
#          data/references/ncbi_nodes_lookup.tsv
#          data/references/ncbi_merged_lookup.tsv


curl -L https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip \
-o data/references/taxdmp.zip

unzip -n -d data/references/ data/references/taxdmp.zip


if [[ $? -eq 0 ]]
 then

     mv data/references/names.dmp \
     data/references/ncbi_names_lookup.tsv 
     mv data/references/nodes.dmp \
     data/references/ncbi_nodes_lookup.tsv
     mv data/references/merged.dmp \
     data/references/ncbi_merged_lookup.tsv

     touch data/references/ncbi_*_lookup.tsv

     rm data/references/*dmp
     rm data/references/gc.prt

 else
     echo "FAIL: Could not extract taxcat.zip"
     exit 1
 fi

 
