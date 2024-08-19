#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: Names of the file to be extracted from the archive (without
# the path or zip extension)
# outputs: The appropriate file into data/raw/

target=$1
filename=`echo $target | sed "s/.*\///"`
path=`echo $target | sed -E "s/(.*\/).*/\1/"`


curl -L https://rrndb.umms.med.umich.edu/downloads/"$filename".zip \
-o "$target".zip

unzip -n -d "$path" "$target".zip

# Touch the downloaded files to update time stamps only if the files
# were unzipped.

 if [[ $? -eq 0 ]]
 then 
     touch "$target" # update time stamp
 else
     echo "FAIL: Could not extract $filename"
     exit 1
 fi

 
