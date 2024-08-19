#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: none
# outputs: place mothur files into code/mothur
# 
# Download the lates version of the mothur to perform the alignment
# This is version 1.48.1, which was released in 2024. 


wget -nc -P code/ https://github.com/mothur/mothur/releases/download/v1.48.1/Mothur.linux_7.zip


unzip -n -d code/ code/Mothur.linux_7.zip

 
# Touch the downloaded files to update time stamps only if the files
# were unzipped.
 if [[ $? -eq 0 ]]
 then 
     touch  code/mothur/mothur
     rm code/Mothur.linux_7.zip
 else
     echo "FAIL: Could not install mothur"
     exit 1
 fi


