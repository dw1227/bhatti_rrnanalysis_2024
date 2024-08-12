#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: Names of the file to be extracted from the archive (without the path or zip extension)
# outputs: The dppropriate file into data/raw/

archive=$1

curl -L https://rrndb.umms.med.umich.edu/downloads/"$archive".zip \
-o data/raw/"$archive".zip

unzip -n -d data/raw/ data/raw/"$archive".zip



 
