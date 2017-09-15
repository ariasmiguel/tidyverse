# Library setup ------------------------------------------------------
library(repurrrsive)
library(tidyverse)
library(jsonlite)
library(xml2)

# Recursive list examples-------------------------------------------
# https://github.com/jennybc/repurrrsive
wesanderson[1:3]

# Mapping functions over a list
map_chr(wesanderson, 1)
map_int(wesanderson, length)
map_chr(wesanderson[7:9], paste, collapse = ", ")

# JSON and XML files local path
wesanderson_json()
wesanderson_xml()

# Bringing data from JSON and XML into an R list -----------------------
json <- fromJSON(wesanderson_json())
json$wesanderson[1:3]
identical(wesanderson, json$wesanderson)

xml <- read_xml(wesanderson_xml())
xml_child(xml)
as_list(xml_child(xml))

# GOT POV characters --------------------------------------
nms <- map_chr(got_chars, "name")
map_df(got_chars, `[`, c("name", "gender", "culture", "born"))

# Present in JSON and XML
got_chars_json()
got_chars_xml()

# JSON
json <- fromJSON(got_chars_json(), simplifyDataFrame = FALSE)
json[[1]][c("name", "titles", "playedBy")]

# XML
xml <- read_xml(got_chars_xml())
xml_child(xml)

# GitHub User and Repo data ---------------------------------------
map_chr(gh_users, "login")
map_chr(gh_users, 18)
map_df(gh_users, `[`, c("login", "name", "id", "location"))

# Get full name of each user's 11th repo
map_chr(gh_repos, list(11, "full_name"))

# XML
repo_xml <- read_xml(gh_repos_xml())
repo_names <- map_chr(xml_find_all(repo_xml, "//full_name"), xml_text)
elevenses <- 
  11 + cumsum(c(0, head(table(gsub("(.*)/.*", "\\1", repo_names)), -1)))
repo_names[elevenses]

# Star Wars Universe entities --------------------------------------
map_chr(sw_films, "title")
luke <- sw_people[[1]]
names(luke)
luke[["films"]]

# Mapping between titles and urls
film_lookup <- map_chr(sw_films, "title") %>% 
  set_names(map_chr(sw_films, "url"))

# The film Luke is in
film_lookup[luke[["films"]]] %>% unname()

# Nested and split data frame ex -----------------------------------
## group_by() + summarize()
gap_simple %>% 
  group_by(country) %>%
  summarize(cor = cor(lifeExp, year))

## nest() + map_*() inside mutate()
gap_nested %>%
  mutate(cor = data %>% map_dbl(~ cor(.x$lifeExp, .x$year)))

## split + map_*()
gap_split %>% 
  map_dbl(~ cor(.x$lifeExp, .x$year)) %>% 
  
## split + map_*() + tibble::enframe()
gap_split %>% 
  map_dbl(~ cor(.x$lifeExp, .x$year)) %>% 
  enframe()
