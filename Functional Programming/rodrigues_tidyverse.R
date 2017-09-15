# Library setup ----------------------------------------------------
library(tidyverse)
library(magrittr)

# Getting data into R ---------------------------------------------
mtcars # mtcars dataset

# Check structure of columns
str(mtcars)
str(mtcars$cyl)
str(mtcars$car)

# Check attributes
# attr(mtcars$cyl, "label")
data(cars)

attr(cars$speed, "label") <- "Speed (mph)"
attr(cars$dist, "label") <- "Stopping distance (feet)"

haven::write_dta(cars, "Functional Programming/cars.dta")

# When you use any of the discussed packages to import data, the
# resulting object is a tibble. Tibbles are modern day data.frame's.
# The first thing you might have noticed is when you print a tibble
# vs a data.frame
data(mtcars)
print(mtcars)
glimpse(mtcars)

# Transforming data with dplyr ------------------------------------
data(Gasoline, package = "plm")
gasoline <- as_tibble(Gasoline)

# filter()--------------------------------------------------------
filter(gasoline, year == 1969)
gasoline %>%
  filter(year == 1969)

gasoline %>%
  filter(year %in% seq(1969, 1973))

gasoline %>%
  filter(year %in% c(1969, 1973, 1977))

# Conditional filtering: filter_if()
# ~all(is.numeric) selects numeric columns
# all_vars()
gasoline %>% 
  filter_if( ~all(is.numeric(.)), all_vars(. > -8))

gasoline %>% 
  filter_at(vars(ends_with("p")), all_vars(. > -8))

# filter() helpers:
# end_with(), starts_with()
# filter_all(), considers all variables
# filter_if() and filter_at(), for applying a filter to a subset

# select() ------------------------------------------------------
gasoline %>% select(country, date = year, lrpmg)
gasoline %>% rename(date = year)

gasoline %>% select_at(vars(c(1,2,5)))
gasoline %>% select_if(is.numeric, toupper)

# group_by() ---------------------- 
gasoline %>% group_by(country, year)

# summarise() --------------------
gasoline %>%
  group_by(country) %>%
  summarise(mean_gaspcar = mean(lgaspcar)) %>%
  filter(country == "FRANCE")

desc_gasoline <- gasoline %>%
  group_by(country) %>%
  summarise(mean_gaspcar = mean(lgaspcar), 
            sd_gaspcar = sd(lgaspcar), 
            max_gaspcar = max(lgaspcar), 
            min_gaspcar = min(lgaspcar))

desc_gasoline %>%
  filter(max(mean_gaspcar) == mean_gaspcar)

gasoline %>%
  group_by(country) %>%
  summarise_at(vars(starts_with("l")), funs(mean, sd, max, min))

gasoline %>%
  group_by(country) %>%
  summarise_if(is.double, funs(mean, sd, min, max))

# mutate() and transmute() --------------------------------------
gasoline %>%
  group_by(country) %>%
  mutate(freq = n())

gasoline %>%
  group_by(country) %>%
  transmute(spam = exp(lgaspcar + lincomep))

gasoline %>%
  mutate_if(is.double, exp)

gasoline %>%
  mutate_at(vars(starts_with("l")), exp)

# if_else(), case_when() and recode() ----------------------------
eu_countries <- c("austria", "belgium", "bulgaria", "croatia", "republic of cyprus",
                  "czech republic", "denmark", "estonia", "finland", "france", "germany",
                  "greece", "hungary", "ireland", "italy", "latvia", "lithuania", "luxembourg",
                  "malta", "netherla", "poland", "portugal", "romania", "slovakia", "slovenia",
                  "spain", "sweden", "u.k.")

# if_else()
gasoline %>%
  mutate(country = tolower(country)) %>%
  mutate(in_eu = if_else(country %in% eu_countries, 1, 0))

gasoline %>%
  mutate(country = tolower(country)) %>%
  mutate(in_eu = if_else(country %in% eu_countries, "yes", "no")) %>%
  filter(year == 1960)

# case_when()
gasoline %>%
  mutate(country = tolower(country)) %>%
  mutate(region = case_when(
    country %in% c("france", "italy", "turkey", "greece", "spain") ~ "mediterranean",
    country %in% c("germany", "austria", "switzerl", "belgium", "netherla") ~ "central europe",
    country %in% c("canada", "u.s.a.", "u.k.", "ireland") ~ "anglosphere",
    country %in% c("denmark", "norway", "sweden") ~ "nordic",
    country %in% c("japan") ~ "asia")) %>%
  filter(year == 1960)

# recode()
gasoline <- gasoline %>%
  mutate(country = tolower(country)) %>%
  mutate(country = recode(country, "netherla" = "netherlands", 
                          "switzerl" = "switzerland"))

# lead() and lag() ------------------------------------------------
gasoline %>%
  group_by(country) %>%
  mutate(lag_lgaspcar = lag(lgaspcar)) %>%
  mutate(lead_lgaspcar = lead(lgaspcar)) %>%
  filter(year %in% seq(1960, 1963))

gasoline %>%
  group_by(country) %>%
  mutate_if(is.double, lag) %>%
  filter(year %in% seq(1960, 1963))

# ntile() - FOR QUANTILES -----------------------------------------
gasoline %>%
  mutate(quintile = ntile(lgaspcar, 5)) %>%
  mutate(decile = ntile(lgaspcar, 10)) %>%
  select(country, year, lgaspcar, quintile, decile)

gasoline %>%
  group_by(country) %>%
  mutate(median = quantile(lgaspcar, 0.5)) %>% # quantile(x, 0.5) is equivalent to median(x)
  filter(year == 1960) %>%
  select(country, year, median)

# arrange() --------------------------------------------------------
gasoline %>%
  arrange(lgaspcar)

gasoline %>%
  arrange(desc(lgaspcar))

gasoline %>%
  filter(year %in% seq(1960, 1963)) %>%
  group_by(country) %>%
  arrange(desc(lgaspcar), .by_group = TRUE) # .by_group = TRUE needed

# Exercises ----------------------------------------------------
# 2. Use one of the map() functions to combine two lists into one. 
# Consider the following two lists:

mediterranean <- list("starters" = list("humous", "lasagna"), 
                      "dishes" = list("sardines", "olives"))

continental <- list("starters" = list("pea soup", "terrine"), 
                    "dishes" = list("frikadelle", "sauerkraut"))

map2(mediterranean, continental, ~c(.x, .y))


# Functions with dplyr --------------------------------------------
simple_function <- function(dataset, col_name){
  col_name <- enquo(col_name)
  dataset %>%
    group_by(!!col_name) %>%
    summarise(mean_mpg = mean(mpg)) -> dataset
  return(dataset)
}

simple_function(mtcars, cyl)
