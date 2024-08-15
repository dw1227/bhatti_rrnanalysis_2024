#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: none
# outputs: place SILVA SEED reference alignment into data/references/silva_seed
# 
# Download this version of the SILVA reference to help with aligning our sequence
# data. This is version 138.1, which was released in 2024. Because the tgz file
# contained a README file, we extracted to a directory within data/references/.

wget -nc -P data/references/ https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.seed_v138_1.tgz
mkdir data/references/silva_seed
tar xvzmf data/references/silva.seed_v138_1.tgz -C data/references/silva_seed 
 


