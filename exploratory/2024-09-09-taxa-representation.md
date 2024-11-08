Analyzing the distribution of genomes across different taxonomic ranks
================
G Bhatti; P Schloss
9/9/2024

``` r
library(tidyverse)
library(here)

metadata<- read_tsv(here("data/references/genome_id_taxonomy.tsv"),
                    col_types = cols(.default = col_character())) |> 
  mutate(strain=if_else(scientific_name==species,NA_character_,scientific_name)) |> 
  select(-scientific_name) |> 
  pivot_longer(-genome_id,names_to="rank",values_to = "taxon") |> 
  drop_na(taxon) |> 
  mutate(rank=factor(rank,
                     levels=c("kingdom","phylum","class","order",
                              "family","genus","species","strain")))

esv<- read_tsv(here("data/processed/rrnDB.easv.count_tibble"),
                        col_types = cols(.default=col_character(),
                                         count=col_integer())) |> 
  filter(threshold=="esv") |> 
  select(-threshold)


metadata_esv<- inner_join(metadata, esv, by=c("genome_id"="genome"))
```

    ## Warning in inner_join(metadata, esv, by = c(genome_id = "genome")): Detected an unexpected many-to-many relationship between `x` and `y`.
    ## ℹ Row 1 of `x` matches multiple rows in `y`.
    ## ℹ Row 51376 of `y` matches multiple rows in `x`.
    ## ℹ If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this warning.

### Find the number of taxa within each taxonomic rank

``` r
n_taxa_per_rank<- metadata_esv |> 
  filter(region=="v19") |> 
  group_by(rank,taxon) |> 
  summarize(N=n_distinct(genome_id)) |> 
  summarize(n_1=n_distinct(taxon),
            n_2=sum(N>=2),
            n_3=sum(N>=3),
            n_4=sum(N>=4),
            n_5=sum(N>=5),
            n_10=sum(N>=10)) |> 
  pivot_longer(-rank,names_to ="n_genomes" ,values_to = "n_taxa" ) |> 
  mutate(n_genomes=factor(n_genomes,
                          levels = c("n_1","n_2","n_3","n_4","n_5","n_10")))
```

    ## `summarise()` has grouped output by 'rank'. You can override using the
    ## `.groups` argument.

``` r
n_taxa_per_rank |> 
  ggplot(aes(x=rank,y=n_taxa,group=n_genomes,color=n_genomes))+
  geom_point()+
  geom_line()+
  theme_classic()
```

![](2024-09-09-taxa-representation_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->
\* Even if we require that every taxonomic group has at least 5 genomes,
there would be a a few hundred species represented. \* Not sure I trust
the strain level data as being complete. There may be taxa in the strain
rank that are in the species but the people that deposited the data
didn’t indicate the correct strain name.
