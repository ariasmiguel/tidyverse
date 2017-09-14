# Library setup --------------------------------------------------------
library(tidyverse)
library(lubridate)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)
library(here)
library(httr)
library(gapminder)
library(broom)

# Lists ---------------------------------------------------------------
# List-columns: a list within a df column
# Better if df is a tibble

# Get Trump tweet data
load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))
head(trump_tweets_df)

# Arrange and select variables (tweett, source, created)
tb_raw <- trump_tweets_df %>%
  select(text, statusSource, created) %>%
  rename(tweet = text,
         source = statusSource)

# Create a list-column of Trump Android words --------------------------
# Clean source to convey if Android or Iphone
source_regex <- "android|iphone"
tword_regex <- "badly|crazy|weak|spent|strong|dumb|joke|guns|funny|dead"

tb <- tb_raw %>%
  mutate(source = str_extract(source, source_regex),
         twords = str_extract_all(tweet, tword_regex))

# Derive new variables ------------------------------------
# n: How many twords are in tweet
# hour: at which hour of the day was the tweet
# strt, the start character of each tword

tb <- tb %>%
  mutate(n = lengths(twords), # can use map(twords, length)
         hour = hour(created),
         start = gregexpr(tword_regex, tweet))

# Use regular data manipulation kit --------------------------
# Tweets created before 2pm, containing 1 or 2 twords, in which there's
# a tword that starts within the first 30 characters
tb %>% filter(hour <14,
              between(n, 1, 2),
              between(map_int(start, min), 0, 30))

# Tweets that contain both the twords "strong" and "weak"
tb %>%
  filter(map_lgl(twords, ~all(c("strong", "weak") %in% .x)))

# Game of Thrones ---------------------------------------------------

# Obtain GOT POV characters
# Get IDs from repurrrsive
# Put IDs and character in a tibble
pov <- set_names(map_int(got_chars, "id"),
                 map_chr(got_chars, "name"))

ice <- pov %>%
  enframe(value = "id")

# Request character info ---------------------------------------------
ice_and_fire_url <- "https://anapioficeandfire.com/"
if (file.exists(here("talks", "ice.rds"))) {
  ice <- readRDS(here("talks", "ice.rds"))
} else {
  ice <- ice %>%
    mutate(
      response = map(id,
                     ~ GET(ice_and_fire_url,
                           path = c("api", "characters", .x))),
      stuff = map(response, ~ content(.x, as = "parsed",
                                      simplifyVector = TRUE))
    ) %>%
    select(-id, -response)
  saveRDS(ice, here("talks", "ice.rds"))
}
ice

# Improve the version of ice ------------------------------------------
# Use the data in repurrrsive

ice2 <- tibble(
  name = map_chr(got_chars, "name"),
  stuff = got_chars
)
ice2

# Inspect the list-column
str(ice2$stuff[[10]], max.level = 1)

# Form a sentence of the form "NAME" was born "AT THIS TIME, IN THIS
# PLACE" by digging info out of the stuff lise-column

template <- "${name} was born ${born}"
ice2 %>%
  mutate(birth = str_interp(template, stuff[[1]])) # Do it for one first

birth_announcements <- ice2 %>%
  mutate(birth = map_chr(stuff, str_interp, string = template)) %>%
  select(-stuff)
head(birth_announcements)

# Allegiances --------------------------------------------------------
allegiances <- ice2 %>%
  transmute(name,
           houses = map(stuff, "allegiances")) %>% # Get allegiances
  filter(lengths(houses) > 1) %>%
  unnest()        # un list the data
head(allegiances)


# Lists as variables in a data frame --------------------------------
x <- got_chars %>% {
  tibble::tibble(
    name = map_chr(., "name"),     
    aliases = map(., "aliases"),
    allegiances = map(., "allegiances")
  )
}

# If we only want Stark alliances
x %>%
  mutate(stark = map(allegiances, str_detect, pattern = "Stark"),
         stark = map_lgl(stark, any)) %>%
  filter(stark == TRUE)

# Keep Stark and Lannister Allegiances
x %>%
  filter(allegiances %>%
           map(str_detect, "Stark|Lannister") %>% # Checks for pattern
           map_lgl(any)) %>%                      # TRUE|FALSE
  select(-allegiances) %>%
  filter(lengths(aliases) > 0) %>%
  unnest()


# Nested df, modelling, and Gapminder --------------------------------
gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)

# Fit a line to each country
gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(stat = "smooth", method = "lm",
            alpha = 1/3, se = FALSE, colour = "black")

# Nested df ---------------------------------------------------------
# Nest data to get one row per country
gap_nested <- gapminder %>%
  group_by(country) %>%
  nest()
gap_nested
gap_nested$data[1]

# Fit models - extract results -------------------------------------
gap_fits <- gap_nested %>%
  mutate(fit = map(data, ~ lm(lifeExp ~ year, data = .x))) # regression data

canada <- which(gap_fits$country == "Canada")
summary(gap_fits$fit[[canada]])

# Get r-squared values ----------------------------------------------
gap_fits %>%
  mutate(rsq = map_dbl(fit, ~ summary(.x)[["r.squared"]])) %>%
  arrange(rsq)

# Use function from broom to get usual coef table from summary.lm()
gap_fits %>%
  mutate(coef = map(fit, tidy)) %>%
  unnest(coef)

