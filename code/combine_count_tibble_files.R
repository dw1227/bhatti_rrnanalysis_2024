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
names(tibble_files)<-str_replace(string = tibble_files,
                                 pattern="data/(.*)/rrnDB.esv.count_tibble",
                                 replacement = "\\1")

map_dfr(.x=tibble_files,
            .f=read_tsv,
            .id= "region",
            col_types=c("ccd")) |> 
  write_tsv("data/processed/rrnDB.esv.count_tibble")
