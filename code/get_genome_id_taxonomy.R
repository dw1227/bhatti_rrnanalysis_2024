# name: get_genome_id_taxonomy.R
#
# author: Gaurav Bhatti
#
# input: data/raw/rrnDB-5.9.tsv
#        data/references/sp_spp_lookup.tsv
#        data/raw/rrnDB-5.9_pantaxa_stats_NCBI.tsv
# output: tsv containing genome id along with taxonomic information.
#         data/references/genome_id_taxonomy.tsv



library(tidyverse)


metadata<- read_tsv("data/raw/rrnDB-5.9.tsv") |> 
  rename(genome_id= 'Data source record id',
         subspecies_id= 'NCBI tax id',
         rdp= `RDP taxonomic lineage`,
         scientific_name= `NCBI scientific name`) |> 
   select(genome_id,subspecies_id,rdp, scientific_name) |> 
  mutate(across(everything(),as.character))

sp_spp_lookup <- read_tsv("data/references/sp_spp_lookup.tsv",
                          col_names = c("domain","species_id","subspecies_id"),
                          col_types = "ccc")


tax<- read_table("data/raw/rrnDB-5.9_pantaxa_stats_NCBI.tsv") |> 
filter(rank=="species")  |> 
  rename(species="name") |> 
  select(taxid,species) |> 
  mutate(across(taxid,as.character))


inner_join(metadata,sp_spp_lookup,by="subspecies_id") |> 
  select(genome_id,rdp,scientific_name,species_id) |> 
  anti_join(tax,by=c("species_id"="taxid")) |> 
  count(species_id) 
  

#find & add missing species from ncbi manually
makeup_tax<- tibble(taxid= c("119542","141390","159612","3144925","3161974","340145"),
species= c("Roseinatronobacter bogoriensis","Chromohalobacter israelensis",
           "Curtobacterium poinsettiae","Nitrospirillum viridazoti",
           "Thermosynechococcus sichuanensis", "Exiguobacterium artemiae"))

tax<-tax |> bind_rows(makeup_tax)
  

test<- inner_join(metadata,sp_spp_lookup,by="subspecies_id") |> 
  select(genome_id,rdp,scientific_name,species_id) |> 
  anti_join(tax,by=c("species_id"="taxid")) |> 
  count(species_id) |> 
  nrow()==0


stopifnot(test)

inner_join(metadata,sp_spp_lookup,by="subspecies_id") |> 
  select(genome_id,rdp,scientific_name,species_id) |> 
  inner_join(tax,by=c("species_id"="taxid")) |> 
  select(genome_id,rdp,species, scientific_name) |> 
  write_tsv("data/references/genome_id_taxonomy.tsv")
