#!/usr/bin/env bash

# author: Gaurav Bhatti
# inputs: data/raw/rrnDB-5.9_16S_rRNA.fasta
#         data/references/silva_seed/silva.seed_v138_1.align
# outputs: data/raw/rrnDB-5.9_16S_rRNA.align
# We need to include flip=T to make sure all sequences are pointed in the same
# direction

code/mothur/mothur '#align.seqs(fasta=data/raw/rrnDB-5.9_16S_rRNA.fasta,
reference=data/references/silva_seed/silva.seed_v138_1.align, flip=T,processors=24)'
