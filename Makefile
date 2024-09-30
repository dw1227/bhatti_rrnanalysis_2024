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


data/references/ncbi_nodes_lookup.tsv data/references/ncbi_names_lookup.tsv \
    data/references/ncbi_merged_lookup.tsv: code/get_ncbi_tax_lookup.sh
	$<

data/references/genome_id_taxonomy.tsv: code/run_r_script.sh \
	        code/get_genome_id_taxonomy.R \
	        data/raw/rrnDB-5.9.tsv \
	        data/references/ncbi_nodes_lookup.tsv \
	        data/references/ncbi_names_lookup.tsv \
	        data/references/ncbi_merged_lookup.tsv 
	$< code/get_genome_id_taxonomy.R
	
	

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


exploratory/2024-09-09-taxa-representation.md: exploratory/2024-09-09-taxa-representation.Rmd\
	        data/references/genome_id_taxonomy.tsv\
			    data/processed/rrnDB.count_tibble\
	        code/run_r_script.sh \
			    code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R $<


exploratory/2024-09-13-rrn-copy-number-vs-ranks.md: exploratory/2024-09-13-rrn-copy-number-vs-ranks.Rmd\
	        data/references/genome_id_taxonomy.tsv\
			    data/processed/rrnDB.count_tibble\
	        code/run_r_script.sh \
			    code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R $<


exploratory/2024-09-21-asv-species-coverage.md: exploratory/2024-09-21-asv-species-coverage.Rmd\
	        data/references/genome_id_taxonomy.tsv\
			    data/processed/rrnDB.count_tibble\
	        code/run_r_script.sh \
			    code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R $<
	
exploratory/2024-09-22-asv-taxa-overlap.md: exploratory/2024-09-22-asv-taxa-overlap.Rmd\
	        data/references/genome_id_taxonomy.tsv\
			    data/processed/rrnDB.count_tibble\
	        code/run_r_script.sh \
			    code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R $<
	
exploratory/2024-09-30-dominance-commonness-of-asvs.md: exploratory/2024-09-30-dominance-commonness-of-asvs.Rmd\
	        data/references/genome_id_taxonomy.tsv\
			    data/processed/rrnDB.count_tibble\
	        code/run_r_script.sh \
			    code/render_markdown.R
	code/run_r_script.sh code/render_markdown.R $<	