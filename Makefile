# Rule
# Target: Prerequisites
# (Tab)Recipe

code/mothur/mothur: code/get_mothur.sh
	$<

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


data/raw/rrnDB-5.9_16S_rRNA.align: code/align_sequences.sh\
	                               code/mothur/mothur\
                                   data/references/silva_seed/silva.seed_v138_1.align\
				                   data/raw/rrnDB-5.9_16S_rRNA.fasta
	$< 


data/%/rrnDB.align data/%/rrnDB.bad.accnos : code/extract_region.sh\
	                                         code/mothur/mothur\
                                             data/raw/rrnDB-5.9_16S_rRNA.align
	$< $@
	
.PRECIOUS: data/%/rrnDB.align


data/%/rrnDB.unique.align data/%/rrnDB.count_tibble : code/count_unique_seqs.sh\
	                                                 code/convert_count_table_to_tibble.R\
													 code/run_r_script.sh\
	                                                 data/%/rrnDB.align\
													 code/mothur/mothur
	$< $@ 




data/processed/rrnDB.count_tibble: code/run_r_script.sh \
	                               code/combine_count_tibble_files.R \
								   data/v19/rrnDB.count_tibble \
								   data/v4/rrnDB.count_tibble \
								   data/v34/rrnDB.count_tibble \
								   data/v45/rrnDB.count_tibble 
	$^




README.md : README.Rmd \
	        code/run_r_script.sh \
			code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R "README.Rmd"


exploratory/genome_sens_spec_2024-09-04.md: exploratory/genome_sens_spec_2024-09-04.Rmd \
	        code/run_r_script.sh \
			code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R "exploratory/genome_sens_spec_2024-09-04.Rmd"


