# name: combine_count_tibble_files.R
#
# author: Pat Schloss; Gaurav Bhatti
#
# input: tidy count files for each region with esv, genome and count as columns
# output: composite tidy count files with a column to designate the region
# note: the input file names need to be 'data/<region>/rrnDB_count.tibble'


library(tidyverse)

args<- commandArgs(trailingOnly = TRUE)
tibble_files<-args



read_count_tibble<-function(count_tibble_file){
  

  
  region= str_replace(string = count_tibble_file,
                                   pattern="data/(.*)/rrnDB\\..*\\.count_tibble",
                                   replacement = "\\1")
  type<- if_else(str_detect(count_tibble_file,"esv"),"esv","asv")
  
  threshold<-if_else(type=="esv","esv",
                     str_replace(string = count_tibble_file,
                      pattern="data/.*/rrnDB\\.(.*)\\.count_tibble",
                      replacement = "0.\\1"))
  
  
  read_delim(count_tibble_file,col_types = "ccd") |> 
    mutate(region=region,
           threshold=threshold) |>   
    # rename esv or asv to be easv
    rename_with(function(x){"easv"},ends_with("sv"))
  
  }
  

map_dfr(.x=tibble_files,.f=read_count_tibble) |> 
  write_tsv("data/processed/rrnDB.easv.count_tibble")
