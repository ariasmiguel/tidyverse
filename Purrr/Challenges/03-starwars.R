# Star Wars challenge
library(tidyverse)
library(jsonlite)
library(listviewer)
library(stringr)
# Your task -----
# There are only 11 instances of a character using a vehicle.  
# Your task is to produce text for each of these instances like
# the following:
# "Luke Skywalker used a Snowspeeder"

# To get you started
load("Purrr/Challenges/data/swapi.rda")
rm(list = c("planets", "species", "starships"))

luke <- people[[1]]$results[[1]]

# jsonedit(people)
# jsonedit(vehicles)
# jsonedit(films)

# Extra challenge -----
# Add the film to your text, e.g. 
# "Luke Skywalker used a Snowspeeder in The Empire Strikes Back"

# Functions --------------------------------------------------------------------
# Simplify List to one level
drop_list <- function(data, level = "results") {
  map(data, level) %>%
    unlist(recursive = FALSE)
}

# Function to get the names
get_names <- function(data, value) {
  map(data, value) %>%
    map(~replace(.x, NULL, NA_character_))
}

# Combine the tables
combine_lists <- function(data1, data2) {
  data2 %>%
    set_names(data1) %>%
    enframe() %>%
    unnest() 
   # rename(data1 = name, data2 = value)
}

# People Names ----------------------------------------------------------------------------------------------------------------------------------
# Simplify people table
people2 <- drop_list(people)

# Get people names, vehicle_url, and film_url
people_name <- get_names(people2, "name")

people_vehicle <- get_names(people2, "vehicles")
#  set_names(people_name) %>%
#  enframe()

# Make it a tibble
part1 <- combine_lists(people_name, people_vehicle) %>%
  rename(people_name = name, vehicle_url = value)

# Vehicles Names -------------------------------------------------------------------------------------------------------------------------------
# Simplify vehicle table
vehicles2 <- drop_list(vehicles)

# Get vehicle names and url
vehicle_name <- get_names(vehicles2, "name")

vehicle_url <- get_names(vehicles2, "url")

#  Create vehicle_info
vehicle_info <- combine_lists(vehicle_name, vehicle_url) %>%
  rename(vehicle_name = name, vehicle_url = value)

# Print first part of project ----------------------------------------------------------------
# Your task is to produce text for each of these instances like
# the following:
# "Luke Skywalker used a Snowspeeder"
last_prep <- left_join(part1, vehicle_info, by = "vehicle_url" ) %>%
  select(-vehicle_url)
ans <- map2(last_prep$people_name, last_prep$vehicle_name, 
            ~sprintf("%s used a %s", .x, .y)) %>%
            unlist()
ans

# # Film Titles -----------------------------------------------------------------------------------------------------------------------------------
# # Simplify films
# films2 <- drop_list(films)
# 
# # Get the title for each film
# film_title <- get_names(films2, "title")
# 
# # Get the url for each film
# film_url <- get_names(films2, "url")
# 
# # Combine this together
# film_info <- combine_lists(film_title, film_url)

# For challenge ------------------------------------

# people_films <- get_names(people2, "films")
# #  set_names(people_name) %>%
# #  enframe()

# challenge <- combine_lists(people_name, people_films) %>%
#   rename(people_name = name, film_url = value)

# people_info <- tibble( 
#                 name = people_name, 
#          vehicle_url = people_vehicle, 
#             film_url = people_films
#          ) 

# Other possibility -----------------------------------------------------------------------------------------------------------------------------
# get_names2 <- function(data, value) {
#  name <- paste0(gsub('[0-9]+', "", deparse(substitute(data))), "_name")
#   map(data, value) %>%
#     map(~replace(.x, NULL, NA_character_)) # %>%
#     if (value != "name") {
#       set_names(name) %>%
#         enframe()
#     } else {}
# }

