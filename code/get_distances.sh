#!/usr/bin/env bash

# author: Gaurav Bhatti
#
# description: takes in the fasta file and calculates a distance file
# mothur's column format. The default cutoff is 0.05.
#
# input: target - the distance matrix name, also the output!
#
# output: target - created

target=$1 #data/v4/rrnDB.unique.dist
align=`echo $target | sed -E "s/dist/align/"`

code/mothur/mothur "#dist.seqs(fasta=$align,cutoff=0.05)"


