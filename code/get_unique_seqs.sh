#!/usr/bin/env bash

# author: Gaurav Bhatti
#
# description: takes in fasta file and uniques and counts the
# sequences.It then converts the count table to a tidy tibble with
# columns esv, genome, and count to indicate the number of ties each
# esv appears in a genome. Zero counts are discarded.
#
# input: target - name of either the count_tibble or align file
#
# output: target - created and stored


target=$1


stub=`echo $target | sed -E "s/(.*rrnDB).*/\1/"`
stub_temp=$stub.temp

align=$stub.align
temp_align=$stub_temp.align
temp_groups=$stub_temp.groups


sed -E "s/>.*\|(.*)\|(.*)\|.*\|(.*)_.$/>\1|\2|\3/" $align > \
$temp_align

grep "^>" $temp_align | sed -E "s/>((.*)\|.*\|.*)/\1 \2/" > \
$temp_groups

code/mothur/mothur "#unique.seqs(fasta=$temp_align, \
    format=name);count.seqs(group=$temp_groups,compress=FALSE)"

# code/run_r_script.sh code/convert_count_table_to_tibble.R \
#  $stub_temp.count_table $stub.esv.count_tibble

mv $stub_temp.unique.align $stub.unique.align
mv $stub_temp.count_table $stub.count_table
rm $stub_temp.*



