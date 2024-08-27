#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: data/raw/rrnDB-5.9_16S_rRNA.fasta
#         data/references/silva_seed/silva.seed_v138_1.align
# outputs: data/raw/rrnDB-5.9_16S_rRNA.align


target=data/v19/rrnDB.unique.align

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

mv $stub_temp.unique.align $stub.unique.align
mv $stub_temp.count_table $stub.count_table

rm $stub_temp.*



