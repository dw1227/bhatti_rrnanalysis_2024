Code Club project: Assessing (in 2024) whether intra and inter-genomic
variations hinder utility of ESVs & ASVs.
================
Gaurav Bhatti; Pat Schloss
08/31/2024

Developed over a series of *Code Club* episodes led by Pat Schloss to
answer an important question in microbiology and develop comfort using
tools to do reproducible research.

## Questions

- Within a genome, how many distinct copies of the 16S rRNA gene
  relative to the number of copies per genome? How far apart are these
  sequences from each other? How does this scale from a genome to
  kingdoms?
- Within a taxa (any level), how many ESVs or ASVs from that taxa are
  shared with sister taxa? How does this change with taxonomic level ?
  Variable region?

### Dependencies:

- [mothur Version
  1.48.1](https://github.com/mothur/mothur/releases)-`code/get_mothur.sh`
  downloads/extracts/installs mothur.
- `wget`
- `curl`
- R version 4.4.0 (2024-04-24)
  - `tidyverse` (v. 2.0.0)
  - `data.table` (v. 1.15.4)
  - `rmarkdown` (v. 2.27)

### My computer

    ## R version 4.4.0 (2024-04-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: CentOS Linux 7 (Core)
    ## 
    ## Matrix products: default
    ## BLAS:   /wsu/el7/gnu7/R/R-4.4.0/lib64/R/lib/libRblas.so 
    ## LAPACK: /wsu/el7/gnu7/R/R-4.4.0/lib64/R/lib/libRlapack.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## time zone: US/Eastern
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] data.table_1.15.4 lubridate_1.9.3   forcats_1.0.0     stringr_1.5.1    
    ##  [5] dplyr_1.1.4       purrr_1.0.2       readr_2.1.5       tidyr_1.3.1      
    ##  [9] tibble_3.2.1      ggplot2_3.5.1     tidyverse_2.0.0   rmarkdown_2.27   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.5      compiler_4.4.0    tidyselect_1.2.1  scales_1.3.0     
    ##  [5] yaml_2.3.9        fastmap_1.2.0     R6_2.5.1          generics_0.1.3   
    ##  [9] knitr_1.48        munsell_0.5.1     pillar_1.9.0      tzdb_0.4.0       
    ## [13] rlang_1.1.4       utf8_1.2.4        stringi_1.8.4     xfun_0.46        
    ## [17] timechange_0.3.0  cli_3.6.3         withr_3.0.0       magrittr_2.0.3   
    ## [21] digest_0.6.36     grid_4.4.0        hms_1.1.3         lifecycle_1.0.4  
    ## [25] vctrs_0.6.5       evaluate_0.24.0   glue_1.7.0        fansi_1.0.6      
    ## [29] colorspace_2.1-0  tools_4.4.0       pkgconfig_2.0.3   htmltools_0.5.8.1
