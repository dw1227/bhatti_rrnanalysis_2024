# The R code goes here
library(tidyverse)
# library(vroom)
library(data.table)

# name: convert_count_table_to_tibble.R
#
# author: Gaurav Bhatti
#
# input: mothur-formatted count file
#
# output: tidy data frame with asv, genome and count as columns
# note: we expect command line arguements in order of input,output.


# a custom function to covert very large wide file to long format using tidyverse
# pivot_longer_big_tibble= function(df,
#                                     names_to="genome",
#                                     values_to="count",
#                                     id_columns="asv",
#                                     chunk_size=250)
#   {
# # Get the column indices of the 'id' columns
# id_indices <- which(names(df) %in% id_columns)
# # Split the dataframe by columns, keeping the 'id' columns
# split_dfs <- lapply(seq_len(ncol(df))[-id_indices] %>% split(ceiling(seq_along(.) / chunk_size)),
#                     function(cols) {
#                       df[, c(id_indices, cols)]
#                       })
# # Convert each chunk to long format and combine them
# long_df <- split_dfs %>%
#   map(~ pivot_longer(.x,
#                      cols = -all_of(id_columns),
#                      names_to = names_to,
#                      values_to = values_to ) %>% filter(count > 0)) %>%
#   bind_rows()
# 
# return(long_df)
# }




args<- commandArgs(trailingOnly = TRUE)
input_file<-args[1]
output_file<-args[2]


# input_file<-"data/v19/rrnDB.temp.count_table"
# output_file<-"data/v19/rrnDB.count_tibble"
# Using tidyverse
# system.time({vroom(input_file, delim = "\t") %>%
#     rename(asv = Representative_Sequence) %>%
#     select(-total) %>%
#    pivot_longer_big_tibble(id_columns = "asv",
#                                 names_to = "genome",
#                                 values_to = "count",
#                                 chunk_size = 250) %>%
#     write_tsv(output_file)})




  
 
  

#####################Repeat the same with data.table and melt
melt_big_data_table <- function(dt, 
                                id_columns = "asv", 
                                variable_name = "genome", 
                                value_name = "count", 
                                chunk_size = 250) {
  
  # Get the column names of the 'id' columns
  id_columns <- intersect(id_columns, names(dt))
  # Get the indices of the 'id' columns
  id_indices <- which(names(dt) %in% id_columns)
  # Split the data.table by columns, keeping the 'id' columns
  split_dts <- lapply(seq_len(ncol(dt))[-id_indices] %>% split(ceiling(seq_along(.) / chunk_size)),
                      function(cols) {
                        dt[,c(id_columns, names(dt)[cols]),with=FALSE]
                      })
  
  # Melt each chunk and combine them using purrr and dplyr
  long_dt <- split_dts %>%
    map(~ melt(.x, 
               id.vars = id_columns, 
               variable.name = variable_name, 
               value.name = value_name) %>%
          filter(!!sym(value_name) > 0)) %>%
    bind_rows()
  
  return(long_dt)
}



fread(input_file) %>%
    rename(asv=Representative_Sequence) %>%
    select(-total)  %>%
    melt_big_data_table(id_columns = "asv",
                        variable_name="genome",
                        value_name="count",
                            chunk_size = 2000) %>%
    write_tsv(paste0(output_file))

