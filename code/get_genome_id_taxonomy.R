# name: get_genome_id_taxonomy.R
#
# author: Gaurav Bhatti
#
# input: data/raw/rrnDB-5.9.tsv
#        data/references/sp_spp_lookup.tsv
#        data/raw/rrnDB-5.9_pantaxa_stats_NCBI.tsv
# output: tsv containing genome id along with taxonomic information.
#         data/references/genome_id_rdp_taxonomy.tsv



library(tidyverse)

merged<- read_delim("data/references/ncbi_merged_lookup.tsv",delim = "|",trim_ws = T, 
                    col_names=c("old_tax_id","new_tax_id","blank")) |> 
  select(-blank) |> 
  mutate(across(everything(),as.character))

metadata<- read_tsv("data/raw/rrnDB-5.9.tsv") |> 
  rename(genome_id= 'Data source record id',
         tax_id= 'NCBI tax id',
         rdp= `RDP taxonomic lineage`,
         scientific_name= `NCBI scientific name`) |>
  filter(!is.na(rdp)) |> 
   select(genome_id,tax_id, scientific_name) |> 
  mutate(across(everything(),as.character))

metadata<- metadata |> 
  left_join(merged,by=c("tax_id"="old_tax_id")) |> 
  mutate(tax_id= ifelse(!is.na(new_tax_id),new_tax_id,tax_id)) |> 
  select(-new_tax_id)



nodes<- read_delim("data/references/ncbi_nodes_lookup.tsv",delim = "|",trim_ws = T,
           col_names = c("tax_id","parent tax_id","rank",
             "embl code", "division id","inherited div flag","genetic code id",
             "inherited GC  flag","mitochondrial genetic code id",
             "inherited MGC flag","GenBank hidden flag",
             "hidden subtree root flag","comments","blank"
           )) |> 
  rename(parent_tax_id=`parent tax_id`) |> 
  select(tax_id,parent_tax_id,rank) |> 
  mutate(across(everything(),as.character))

  
names<- read_delim("data/references/ncbi_names_lookup.tsv",delim = "|",trim_ws = T,
                   col_names = c("tax_id", "name_txt","unique name",
                                 "name class","blank")) |> 
  filter(`name class` == "scientific name") |> 
  select(tax_id,name_txt) |> 
  mutate(across(everything(),as.character))





tree<- inner_join(nodes,metadata,by=c("tax_id"="tax_id")) |> 
  unite(tr_a,tax_id, rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_b,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_c,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_d,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_e,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_f,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_g,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_h,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_i,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_j,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_k,tax_id,rank,sep = "_") |> 
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) |> 
  unite(tr_l,tax_id,rank,sep = "_") |>
  inner_join(x=nodes,y=_, by=c("tax_id"="parent_tax_id") ) 


  # tree |>  count(genome_id)


## Have we reached the parent node?
test_a<- tree |> 
  count(parent_tax_id) |> 
  nrow()
stopifnot(test_a==1)



# Do we have 
test_b <-  anti_join(metadata,tree,by=c("genome_id")) |> nrow()
stopifnot(test_b==0)


tree |> 
   select(-parent_tax_id) |> 
   pivot_longer(cols=starts_with("tr"),names_to = "tr",values_to = "id_rank") |> 
   select(-tr,-tax_id,-rank) |> 
   separate(id_rank,into=c("tax_id","rank"),sep = "_") |>       
   filter(rank %in% c("superkingdom","phylum","class","order",
                      "family","genus","species")) |> 
   inner_join( names, by=c("tax_id")) |> 
   select(-tax_id) |> 
   pivot_wider(names_from = rank,
               values_from = name_txt) |> 
   rename(kingdom=superkingdom) |> 
   select("genome_id","scientific_name","kingdom","phylum","class","order",
                                      "family","genus","species") |> 
  write_tsv("data/references/genome_id_taxonomy.tsv")


   

 
