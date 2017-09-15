library(tidyverse)
library(stringr)

#------------------
# CONVERT TO TIBBLE
#------------------
# – the iris dataframe is an old-school dataframe
#   ... this means that by default, it prints out
#   large numbers of records.
# - By converting to a tibble, functions like head()
#   will print out a small number of records by default

df.iris <- as_tibble(iris)


#-----------------
# RENAME VARIABLES
#-----------------
# - here, we're just renaming these variables to be more
#   consistent with common R coding "style"
# - We're changing all characters to lower case
#   and changing variable names to "snake case"

colnames(df.iris) <- df.iris %>%
  colnames() %>%
  str_to_lower() %>%
  str_replace_all("\\.","_")

# INSPECT

df.iris %>% 
  select(species, everything()) %>%
  head()

# NEST ----------------------------------------------------------
nested <- df.iris %>%
  group_by(species) %>%
  nest()

# Nesting the data frame makes it more readable and more efficient
# for iteration. 

nested$data %>%
  map(colMeans)

nested %>% map(data, colMeans)

