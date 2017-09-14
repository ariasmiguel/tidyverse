# Library setup --------------------------------------------------------
library(tidyverse)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)

# Sample from groups, n varies by group ---------------------------------
# Use iris data
# Species = groups
# Sample from the 3 Species with 3 different sample sizes
# Created a nested data frame

nested_iris <- iris %>%    
  group_by(Species) %>%    # prep for work by Species
  nest() %>%               # --> one row per species
  mutate(n = c(2, 5, 3))   # add sample sizes

# Draw the sample sizes ------------------------------------------------
nested_iris
sampled_iris <- nested_iris %>%
  mutate(samp = map2(data, n, sample_n)) # Creates sample with sample_n

# Keep only Species and samp variables
sampled_iris %>%
  select(Species, samp) %>%
  unnest()

# In one simple step ---------------------------------------------------
iris %>%
  group_by(Species) %>%
  nest() %>%
  mutate(n = c(2, 5, 3)) %>%
  mutate(samp = map2(data, n, sample_n)) %>%
  select(Species, samp) %>%
  unnest()
