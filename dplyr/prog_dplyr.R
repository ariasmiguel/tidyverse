# Library -------------------------------------------------
library(tidyverse)

# Programming with dplyr by using dplyr --------------------------------
starwars %>%
  group_by(homeworld) %>%
  summarise(mean_height = mean(height, na.rm = TRUE),
            mean_mass = mean(mass, na.rm = TRUE),
            count = n())

# Make this a function with dplyr
starwars_mean <- function(var) {
  var <- enquo(var)   # Need to enquo(var) to quote the name
  starwars %>%
    group_by(!!var) %>% # !! unquotes and uses the name instead of var
    summarise(mean_height = mean(height, na.rm = TRUE),
              mean_mass = mean(mass, na.rm = TRUE),
              count = n())
}

starwars_mean(homeworld)

# Other forms
starwars_mean2 <- function(var) {
  var <- as.name(var)
  starwars %>%
    group_by(!!var) %>%
    summarise(mean_height = mean(height, na.rm = TRUE),
              mean_mass = mean(mass, na.rm = TRUE),
              count = n())
}

starwars_mean2("homeworld")

# Another one
starwars_mean3 <- function(var) {
  starwars %>%
    group_by_at(var) %>%
    summarise(mean_height = mean(height, na.rm = TRUE),
              mean_mass = mean(mass, na.rm = TRUE),
              count = n())
}

starwars_mean3("homeworld")

# Change column names as well ---------------------------
# Basic R
grouped_mean <- function(data, grouping_variables, value_variables) {
  result_names <- paste0("mean_", value_variables)
  expressions <- paste0("mean(", value_variables, ", na.rm = TRUE)")
  data %>%
    group_by_se(grouping_variables) %>%
    summarize_se(c(result_names := expressions,
                   "count" := "n()"))
}

starwars %>% 
  grouped_mean("eye_color", c("mass", "birth_year"))

# Dplyr
grouped_mean <- function(data, grouping_variables, value_variables) {
  data %>%
    group_by_at(grouping_variables) %>%
    mutate(count = n()) %>%
    summarise_at(c(value_variables, "count"), mean, na.rm = TRUE) %>%
    rename_at(value_variables, funs(paste0("mean_", .)))
}

starwars %>% 
  grouped_mean("eye_color", c("mass", "birth_year"))

