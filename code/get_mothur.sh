#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: none
# outputs: place mothur files into code/mothur
# 
# Download the lates version of the mothur to perform the alignment
# This is version 1.48.1, which was released in 2024. 


wget -nc -P code/ https://github.com/mothur/mothur/releases/download/v1.48.1/Mothur.linux_7.zip


unzip -n -d code/ code/Mothur.linux_7.zip

 


