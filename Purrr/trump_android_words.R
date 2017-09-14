# Library setup --------------------------------------------------------
library(tidyverse)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)

# Trump Android words --------------------------------------------------
# Load the data
load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))
glimpse(trump_tweets_df)

# Create tweets with the text data
tweets <- trump_tweets_df$text
tweets %>% head() %>% strtrim(70) # strtrim() cuts the string to length(x)

# Words used by Trump
regex <- "badly|crazy|weak|spent|strong|dumb|joke|guns|funny|dead"

# gregexpr()------------------------------------------------------------
matches <- gregexpr(regex, tweets)
str(matches)

# matches is a list. One element per element of tweets
# Each element is an int. -1 if no match found, holds the position of each
# match otherwise.
# Two attributes per element. match.length = -1 when no matches, and it 
# holds the length(s) of each match, otherwise.


# Get to know the list ---------------------
lengths(matches)              # just happens to exist for length
map_int(matches, length)      # length of match.length

# Create list match_length that carries the element of match.length()
m <- matches[[7]]
attr(m, which = "match.length")

# Pre-defined function
ml <- function(x) attr(x, which = "match.length")
map(matches, ml)

# Anonymous function
matches %>%
  map(~attr(.x, which = "match.length"))

# Pre-existing function
match_length <- map(matches, attr, which = "match.length")

## Exercise ----------------------------------------------------
# Count the number of Trump Android words in each tweet
m <- matches[[1]]
sum(m > 0)
m <- matches[[705]]
sum(m > 0)

# Insert this code into machinery -- USE map()
f <- function(x) sum(x > 0)
map(matches, f)
map(matches, ~ sum(.x > 0))

# Use map_int() to create a int vector
map_int(matches, ~sum(.x > 0))

# Confirm that this is different from map_int(matches, length)
matches %>% {
  tibble(
    naive_length = map_int(., length),
         n_words = map_int(., ~ sum(.x>0))
)
}

## Strip attributes from matchs -----------------------------------
match_first <- map(matches, as.vector) # as.vector strips the attributes

# Extract Trump words from a single tweet
# Use tweet #1 and #919
tweet <- tweets[919]
t_first <- match_first[[919]]         # An element of matches
t_length <- match_length[[919]]       # An element of match_length
t_last <- t_first + t_length - 1      # first + length - 1
substring(tweet, t_first, t_last)

tweet <- tweets[1]
t_first <- match_first[[1]]
t_length <- match_length[[1]]
t_last <- t_first + t_length - 1
substring(tweet, t_first, t_last)

# Apply this to all the tweets ---------------------------------------
# Use map2()
last_m <- function(x,y) x + y -1
map2(match_first, match_length, last_m)

match_last <- map2(match_first, match_length, ~ .x + .y -1)

# Extract the words --------------------------------------------------
# Use pmap()
# Remember: substring(text, first, last)
# .l is a list of lists
# Deliberately uuse the list names to match the argument names of
# substring()
# .f will be substring()

pmap(list(text = tweets, first = match_first, last =  match_last), 
     substring)

# March through the rows in a data frame ----------------
mdf <- tibble(
  text = tweets,
  first = match_first,
  last = match_last
)
pmap(mdf, substring)

# Combining everything from the top ---------------------------
tibble(text = tweets,
       first = gregexpr(regex, tweets)) %>% 
  mutate(match_length = map(first, ~ attr(.x, which = "match.length")),
         last = map2(first, match_length, ~ .x + .y - 1)) %>%
  select(-match_length) %>% 
  pmap(substring)
