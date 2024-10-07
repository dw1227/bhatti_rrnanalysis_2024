# name: convert_shared_to_tibble.R
#
# author: Pat Schloss; Gaurav Bhatti
#
# input: a shared file generated in mothur
# output: tidy version of the shared file


# The R code goes here
library(tidyverse)
library(data.table)


args<- commandArgs(trailingOnly = TRUE)
input_file<-args[1]
output_file<-args[2]


fread(input_file, drop=c("label","numOtus")) |> 
  setnames(old = "Group",new = "genome") |> 
  melt(id.vars = "genome", 
       variable.name = "asv", 
       value.name = "count") %>%
  .[count != 0] |> 
  write_csv(output_file)
