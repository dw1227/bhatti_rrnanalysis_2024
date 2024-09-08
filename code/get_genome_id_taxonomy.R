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


tax<- read_tsv("data/raw/rrnDB-5.9_pantaxa_stats_NCBI.tsv",
               col_select = c(taxid,rank,name)) |> 
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
  filter(!is.na(rdp)) |> 
  # select(-species,-scientific_name) |>   
  # filter(!str_detect(rdp,"\\|\\|\\|")) |> 
  mutate(rdp=str_replace_all(rdp,pattern = ".*\\|\\|\\|.*",
                             replacement = "NA|domain")) |> 
  separate(col=rdp,
           into = paste0("rdp_",letters[1:8]),
           sep="; ",
           fill="right") |> 
  pivot_longer(cols = starts_with("rdp_"),
               names_to = "rank",
               values_to = "name") |> 
  filter(!is.na(name)) |> 
  separate(col=name,
           into=c("taxon_name","taxon_rank"),
           sep="\\|",convert=TRUE) |> 
  select(-rank) |> 
  mutate(taxon_name=str_replace_all(taxon_name,pattern='\"',
         replacement=''),
         taxon_name=str_replace_all(taxon_name,pattern=' ',
                                    replacement='_')) |> 
  filter(taxon_rank %in% c("domain","phylum","class","order","family","genus")) |> 
  pivot_wider(names_from = taxon_rank,
              values_from = taxon_name) |> 
  rename(kingdom=domain) |> 
  # count(kingdom) |> 
  # print(n=Inf)
  write_tsv("data/references/genome_id_rdp_taxonomy.tsv")
