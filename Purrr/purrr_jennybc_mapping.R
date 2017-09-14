# Library setup --------------------------------------------------------
library(tidyverse)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)

## Specifying the function in map() + parallel mapping -----------------
# map() function specification
# Pull out GOT data/aliases

aliases <- set_names(map(got_chars, "aliases"),  # The data
                     map_chr(got_chars, "name")) # The names

# Index aliases of specific characters
aliases[c("Theon Greyjoy", "Asha Greyjoy", "Brienne of Tarth")]

# Existing function ---------------------------------------------------
my_fun <- function(x) {
  paste(x, collapse = " | ")  # collapses strings together
}
map(aliases, my_fun)   # applies to all the data

# Anonymous function, conventional -------------------------------------
# Conventional way (creating function on the fly)
map(aliases, function(x) paste(x, collapse = " | "))

# Alternatevily
map(aliases, paste0, collapse = " | ")

# Anonymous function, formula -------------------------------------------
map(aliases, ~ paste(.x, collapse = " | "))

# Always do your code in small steps

# List to data frame ----------------------------------------------------
aliases

# One way
map_chr(aliases[c(3, 10, 20, 24)], ~ paste(.x, collapse = " | ")) %>%
  tibble::enframe(value = "aliases") # transforms from list to variable

# Alternative
# Creates a tibble with all the character names and their aliases
tibble::tibble(
  name = map_chr(got_chars, "name"),
  aliases = got_chars %>%
    map("aliases") %>%
    map_chr(~ paste(.x, collapse = " | "))
) %>% # Slices the tibble
  dplyr::slice(c(3, 10, 20, 24))

## Exercises -------------------------------------------------------

# 1. Create a list allegiances that holds the characters' house 
# affiliations
allegiances <- map(got_chars, "allegiances")

# 2. Create a character vector nms that holds the characters' names
nms <- map_chr(got_chars, "name")

# 3. Apply the names in nms to the allegiances list via set_names
allegiances <- set_names(allegiances, nms)

# 4. Re-use the code from above to collapse each character's vector of 
# allegiances down to a string
allegiances <- allegiances %>%
  map(paste, collapse = " | ")

# 5. What happens if you pass collapse = c(" | ", " * ")
allegiances %>%
  map(paste, collapse = c(" | ", " * "))

# The " * " is ignored

## Parallel map -----------------------------------------------------
# map2(), map a function over two vectors or lists in parallel

# The inputs:
nms <- got_chars %>%
  map_chr("name")
birth <- got_chars %>%
  map_chr("born")

# Map over both with an existing function
my_fun <- function(x, y) paste(x, "was born", y)
map2_chr(nms, birth, my_fun)
# In line function
map2_chr(nms, birth, function(x,y) paste(x, "was born", y)) %>%
  head()
# Anonymous function, formula
map2_chr(nms, birth, ~ paste(.x, "was born", .y)) %>% 
  head()

# pmap() for two or more vectors or lists
df <- got_chars %>% {
  tibble::tibble(
             name = map_chr(., "name"),     
          aliases = map(., "aliases"),
      allegiances = map(., "allegiances")
  )
}

my_fun <- function(name, aliases, allegiances) {
  paste(name, "has", length(aliases), "aliases and",
        length(allegiances), "allegiances")
}

df %>% 
  pmap_chr(my_fun) %>% 
  tail()
