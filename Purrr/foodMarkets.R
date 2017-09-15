# Library setup -----------------------------------------------
library(jsonlite)
library(listviewer)
library(tidyverse)

# Food Markets in New York -------------------------------------
food_mkts_raw <- fromJSON("Purrr/foodMarkets/retail_food_markets.json",
                          simplifyVector = FALSE)

# Discover the data ---------------------------------------------
str(food_mkts_raw, max.level = 1)

# The data component sounds interesting
str(food_mkts_raw$data, max.level = 1, list.len = 5)

# Hypothesis: similar data for each 28355 food markets
# mysterious homogeneous list
food_mkts <- food_mkts_raw$data

# $meta has sole component view
str(food_mkts_raw$meta, max.level = 1)
jsonedit(food_mkts_raw[[c("meta", "view")]])

# The column component tells what data we have for each food market
# over in the data component

# Pull out the name elements of columns

cnames <- food_mkts_raw[[c("meta", "view",  # Used to subset into lists
                           "columns")]] %>%
  map_chr("name") # Gets the names from each column


# Apply names -----------------------
food_mkts <- food_mkts %>%
  map(set_names, cnames)

# Pull out and simplify the data for one col across all food markts.
food_mkts %>%
  map_chr("Entity Name") %>%
  head()

# Create a data frame -----------------------------
# Eliminate "Location", complicated syntax
to_process <- cnames[cnames != "Location"]

# The goal is to create a data frame with these variables and one
# row per food market

# ROWS FIRST ----------------------------------------------
# ideally use map_df() for food_mkts
food_mkts %>%
  map_df(extract, to_process)

# Null values prevent this from working

# Use function to replace NULL with NA
safe_extract <- function(l, wut) {
  res <- l[wut]                      # gets list value
  null_here <- map_lgl(res, is.null) # creates lgl value (TRUE if null)
  res[null_here] <- NA               # Replaces NULL with NA
  res
}
safe_extract(food_mkts[[67]][14:16]) # It works

# Use safe_extract to get df
mkts_df <- food_mkts %>%
  map_df(safe_extract, to_process)

# COLUMNS FIRST ----------------------------------------------

# Naive approach for two vars
food_mkts %>%
{
  tibble(
    dba_name = map_chr(., "DBA Name"),
    city = map_chr(., "City")
  )
}

# Would need to do it for all variables. Need to know variable type too

vdf <- mkts_df %>% 
    map_chr(class) %>%  # get names and type
    enframe(name = ".f", value = "type") %>%     # make it a tibble
    mutate(vname = .f %>% tolower() %>% gsub("\\s+", "_", .),
           mapper = c(integer = "map_int", character = "map_chr")[type],
           .null = list(integer = NA_integer_,
                        character = NA_character_)[type])

# Scale up
# use invoke()
mkts_df <- invoke_map_df(.f = set_names(vdf$mapper, vdf$vname),
                         .x = transpose(vdf[c(".f", ".null")]),
                         food_mkts)

# .f = set_names: specifies the list of functions to iterate over,
# the type-specific mappers we pre-seleected above. The names
# propagate ot the variable names of the data frame

# .x = transpoe: gives the parallel list of function arguments, namely
# the strings specifying named elements to extract and the value to
# insert in place of explicit NULL.
# transpose() repackages the .f and .null vars. Instead of a list of
# two same length vectors, we want a single list holding lists of
# length two
# food_mkts is the ... args

# Location ------------------------------------------------------
# Place it in its own list
loc_raw <- food_mkts %>%
  map("Location")
loc_raw[[345]]

# Get names
i <- which(cnames == "Location") # Gets location position (Index)

# Gets the sublist, Location
location_meta <- food_mkts_raw[[c("meta", "view", "columns")]][[i]]

# Gets the names of the location subColumns
lnames <- location_meta[["subColumnTypes"]] %>% 
  flatten_chr()

# Set names
loc_raw <- loc_raw %>%
  map(set_names, lnames)

# Parse the human_address element
# Rowbind elements into a df
# Prepend ha_ to the variable names to avoid conflicts

ha <- loc_raw %>%
  map("human_address") %>%
  map_df(fromJSON) %>%
  set_names(paste0("ha_", names(.)))
head(ha)

# Convert into df ---------------------------------------------
# Convert rest of vars into df
ee <- loc_raw %>%
  map_df(safe_extract, lnames[lnames != "human_address"]) %>%
  mutate_at(vars(latitude, longitude), as.numeric)
head(ee)

# Put everthing together ---------------------------------------
mkts_df <- bind_cols(mkts_df, ha, ee)

# Trim trailing whitespace
mkts_df <- mkts_df %>%
  mutate_if(is.character, trimws)
