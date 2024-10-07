#!/usr/bin/env bash

# author: Gaurav Bhatti
#
# description: takes in distance file,counts file, and cutoff
# Generates a count_tibble file to indicate the number of times 
# each asv appears in each genome.
#
# input: target - file name in the format
#        data/v4/rrnDB.01.count_tibble
#        - this file name is also the output
#        - The 01 in this example is the threshold (0.01)
#
# output: target - created 

target=$1 #data/v4/rrnDB.01.count_tibble


stub=`echo $target | sed -E "s/(.*rrnDB).*/\1/"`

threshold=`echo $target | sed -E "s/.*rrnDB\.(.*)\.count.*/\1/"`
distances=$stub.unique.dist
count=$stub.count_table
cutoff=0.$threshold
code/mothur/mothur "#cluster(column=$distances, \
                     count=$count,cutoff=$cutoff); \
                     make.shared()"
                     
code/run_r_script.sh code/convert_shared_to_tibble.R \
 $stub.unique.opti_mcc.shared $target
 
 
# Garbage collection
rm $stub.unique.opti_mcc.list
rm $stub.unique.opti_mcc.steps
rm $stub.unique.opti_mcc.sensspec
rm $stub.unique.opti_mcc.shared



 
 

