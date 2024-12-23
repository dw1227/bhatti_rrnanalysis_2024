Quantifying the coverage of ESVs within a species
================
G Bhatti; P Schloss
9/21/2024

``` r
library(tidyverse)
library(here)
library(knitr)

metadata<- read_tsv(here("data/references/genome_id_taxonomy.tsv"),
                    col_types = cols(.default = col_character())) |> 
  mutate(strain=if_else(scientific_name==species,NA_character_,scientific_name)) |> 
  select(-scientific_name)


esv<- read_tsv(here("data/processed/rrnDB.easv.count_tibble"),
                        col_types = cols(.default=col_character(),
                                         count=col_integer())) |> 
  filter(threshold=="esv") |> 
  select(-threshold)



metadata_esv<- inner_join(metadata, esv, by=c("genome_id"="genome"))
```

### Does the number of ESVs per species increase with sampling effort?

### Does this vary by region within the 16S rRNA gene?

We have previously seen (genome_sens_spec_2024-09-04.md) that the number
of ESVs per copy of the 16S rRNA gene is about 0.6. This means that if a
genome has 10 copies of the 16S rRNA gene, we would expect to see about
6 different versions of the gene within that genome. Across genomes from
the same species, we know that the number of copies of the gene is
pretty consistent. So if we look at multiple genomes from the same
species, will we see the same versions of the gene or will we see new
versions of the gene? To answer this, we would like to look at the
relationship between the number of ESVs found in a species per number of
genomes in the species versus the number of genomes. Besides looking at
the full length sequences, let’s also look at the V4, V3-4, and V4-5
regions.

``` r
# x= number of genomes for a particular species
# y= ratio of number of ESVs per genome
# each point represents a different species
# each facet represents a different region
species_esvs<-metadata_esv |> 
  select(genome_id,species,region,easv,count) |> 
  group_by(region,species) |> 
  summarize(n_genomes= n_distinct(genome_id),
            n_rrns=sum(count)/n_genomes,
            n_esvs= n_distinct(easv),
            esv_rate=n_esvs/n_genomes,
            .groups = "drop") 

region_labels<- c("V1-V9","V4","V3-V4","V4-V5")
names(region_labels)=c("v19","v4","v34","v45")
species_esvs |> 
  ggplot(aes(x=n_genomes,y=esv_rate)) +
  geom_point(alpha=0.2)+
  geom_smooth()+
  # facet_grid(region~.)+
  facet_wrap(facet="region",
             nrow = 2,
             strip.position = "top",
             scales = "fixed",
             labeller = labeller(region=region_labels))+
  scale_x_log10()+
  scale_y_log10()+
  theme_classic()
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](2024-09-21-esv-species-coverage_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
# species name, number of genomes, average number of rrns, number of ESVs across
# genomes for each region of 16S rRNA gene.
count_table<- species_esvs |>   
  select(species, region, n_genomes,n_rrns,n_esvs) |> 
  group_by(species) |> 
  mutate(n_genomes=max(n_genomes),
         n_rrns= max(n_rrns)) |> 
  ungroup() |> 
  pivot_wider(names_from = region,
              values_from = n_esvs) |> 
  arrange(species) 

# see also kableExtra
count_table |> 
  arrange(desc(n_genomes)) |> 
  top_n(n_genomes,n=10) |> 
  kable(caption="Ten most commonly sequenced species",
        digits=2)
```

| species                    | n_genomes | n_rrns |  v19 | v34 |  v4 | v45 |
|:---------------------------|----------:|-------:|-----:|----:|----:|----:|
| Escherichia coli           |      3337 |   6.97 | 2838 | 768 | 587 | 792 |
| Klebsiella pneumoniae      |      1885 |   7.97 | 1571 | 576 | 341 | 459 |
| Salmonella enterica        |      1549 |   6.99 | 1437 | 382 | 267 | 384 |
| Staphylococcus aureus      |      1183 |   5.75 |  918 | 196 | 104 | 186 |
| Pseudomonas aeruginosa     |       821 |   4.00 |  257 |  75 |  48 |  62 |
| Bordetella pertussis       |       634 |   3.00 |   30 |   8 |   5 |   9 |
| Acinetobacter baumannii    |       610 |   5.98 |  275 | 108 |  56 |  74 |
| Campylobacter jejuni       |       421 |   2.54 |   83 |  25 |  15 |  27 |
| Mycobacterium tuberculosis |       396 |   1.00 |   20 |   5 |   2 |   6 |
| Helicobacter pylori        |       368 |   1.97 |  240 |  35 |  28 |  44 |

Ten most commonly sequenced species

### Conclusions

- V1-V9 continues to add significant number of ESVs as more genomes are
  sampled from a species.
- The sub-regions seem to have plateaued indicating that perhaps we will
  always add more ESVs for a species.
- Perhaps we really are splitting genomes and species too finely with
  ESVs.
- Would like to look at individual genomes in more detail.
