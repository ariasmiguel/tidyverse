# Star Wars challenge
library(purrr)
library(rwars)
library(tidyverse)

# Your task -----
# There are only 11 instances of a character using a vehicle.  
# Your task is to produce text for each of these instances like
# the following:
# "Luke Skywalker used a Snowspeeder"

# To get you started
load("Purrr/Challenges/data/swapi.rda")

luke <- people[[1]]$results[[1]]
map(people, ~.x$results) %>%
  map(people, ~.x$name)

luke[["vehicles"]]

vehicles[[5]][["url"]]
vehicles[[5]][["name"]]

# Extract people's names
chr_names <- people %>% # Select people list
  map("results") %>%    # Select the result sublist
  flatten() %>%         # Eliminate the grouping of lists
  map_chr("name")       # Obtain the names

# List of vehicles
vehicle_people <- people %>%
  map("results") %>%
  flatten() %>%
  map("vehicle")

# Extra challenge -----
# Add the film to your text, e.g. 
# "Luke Skywalker used a Snowspeeder in The Empire Strikes Back"