# Library setup --------------------------------------------------------
library(tidyverse)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)

# List inside a data frame ---------------------------------------------
# Put the gh_repos list into a data frame, along with identifying the GitHub
# usernames. 

# Obtain the username information
str(gh_repos[[1]][4], list.len = 6)
unames <- map_chr(gh_repos, c(1, 4, 1))
unames

# Grab the usernames and set them as the names of the gh_repos list. Then
# we use tibblee::enframe() to convert this named vector into a tibble with
# the names as one variable and the vector as the other. 
udf <- gh_repos %>%
  set_names(unames) %>% 
  enframe("username", "gh_repos")
udf

# Use map() inside mutate() ---------------------------------------------
# Create new column that tells us the length of the lists
udf %>%
  mutate(n_repos = map_int(gh_repos, length))

# How far do we need to drill to get a single repo? How do we create "one
# row's worth" of data for this repo? How do we do that for all repos
# for a single user?

# ONE USER --------------------------------------------------------------
## one_user is a list of repos for one user
one_user <- udf$gh_repos[[1]]

## one_user[[1]] is a list of info for the first repo
one_repo <- one_user[[1]]
str(one_repo, max.level = 1, list.len = 5)

## Selective list of variables for one repo
select_var <- c("name", "fork", "open_issues")
one_repo[c("name", "fork", "open_issues")]

## Make a data frame of that info for all a user's repos
map_df(one_user, extract, select_var)

# ALL USERS ------------------------------------------------------------
## Use map() inside map() to create the user specific tibbles
udf %>%
  mutate(repo_info = gh_repos %>%
           map(. %>% map_df(extract, select_var)))

# Remove the gh_repos variable and use tidyr::unnest() -----------------
rdf <- udf %>%
  mutate(
    repo_info = gh_repos %>%
      map(. %>% map_df(extract, select_var))) %>%
  select(-gh_repos) %>%
  tidyr::unnest()

rdf %>%
  filter(!fork) %>% # Filters for fork = FALSE
  select(-fork) %>%
  group_by(username) %>%
  arrange(username, desc(open_issues)) %>%
  slice(1:3)

