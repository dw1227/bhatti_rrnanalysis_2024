# The R code goes here
library(tidyverse)
library(vroom)
library(data.table)

# name: conver_count_table_to_tibble.R
#
# author: Gaurav Bhatti
#
# input: mothur-formatted count file
#
# output: tidy data frame with asv, genome and count as columns
# note: we expect command line arguements in order of input,output.



args<- commandArgs(trailingOnly = TRUE)

input_file<-args[1]
output_file<-args[2]

# a custom function to covert very large wide file to long format
pivot_longer_big_tibble= function(df,
                                    names_to="genome",
                                    values_to="count",
                                    id_columns="asv",
                                    chunk_size=250)
  {
# Get the column indices of the 'id' columns
id_indices <- which(names(df) %in% id_columns)
# Split the dataframe by columns, keeping the 'id' columns
split_dfs <- lapply(seq_len(ncol(df))[-id_indices] %>% split(ceiling(seq_along(.) / chunk_size)),
                    function(cols) {
                      df[, c(id_indices, cols)]
                      })
# Convert each chunk to long format and combine them
long_df <- split_dfs %>%
  map(~ pivot_longer(.x,
                     cols = -all_of(id_columns),
                     names_to = names_to,
                     values_to = values_to ) %>% filter(count > 0)) %>%
  bind_rows()

return(long_df)
}


vroom(input_file,delim = "\t",num_threads = 4) %>%
  rename(asv=Representative_Sequence) %>%
   select(-total) %>%
  pivot_longer_big_tibble(id_columns = "asv",
               names_to="genome",
               values_to="count",
               chunk_size = 250) %>%
  write_tsv(output_file)



