# Rule
# Target: Prerequisites
# (Tab)Recipe

data/references/silva_seed/silva.seed_v138_1.align: code/get_silva_seed.sh
	code/get_silva_seed.sh

data/raw/rrnDB-5.9_16S_rRNA.fasta: code/get_rrndb_files.sh
	$< $@

data/raw/rrnDB-5.9_pantaxa_stats_NCBI.tsv: code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.9_pantaxa_stats_RDP.tsv: code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.9.tsv: code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@


#data/raw/rrnDB-5.9_16S_rRNA.align: code/align_sequences.sh\
                                   data/references/silva_seed/silva.seed_v138_1.align\
				   data/raw/rrnDB-5.9_16S_rRNA.fasta
#	$< 


data/%/rrnDB.align data/%/rrnDB.bad.accnos : code/extract_region.sh\
                      data/raw/rrnDB-5.9_16S_rRNA.align
	$< $@ 



