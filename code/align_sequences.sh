#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: data/raw/rrnDB-5.9_16S_rRNA.fasta
#         data/references/silva_seed/silva.seed_v138_1.align
# outputs: data/raw/rrnDB-5.9_16S_rRNA.align
# We need to include flip=T to make sure all sequences are pointed
# in the same direction

# the "g" in sed below is gloabal and replaces all spaces with
# underscore. Without "g", only first occurence is replaced.
sed "s/ /_/g" data/raw/rrnDB-5.9_16S_rRNA.fasta >
data/raw/rrnDB-5.9_16S_rRNA.temp.fasta


code/mothur/mothur
'#align.seqs(fasta=data/raw/rrnDB-5.9_16S_rRNA.temp.fasta,
reference=data/references/silva_seed/silva.seed_v138_1.align,
flip=T,
processors=30)'

if [[ $? -eq 0 ]]
then 
    mv data/raw/rrnDB-5.9_16S_rRNA.temp.align
    data/raw/rrnDB-5.9_16S_rRNA.align
    rm data/raw/rrnDB-5.9_16S_rRNA.temp.fasta
else
    echo "FAIL: mothur failed to align sequences"
    exit 1
fi





