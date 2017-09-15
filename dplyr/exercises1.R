# Library -------------------------------------------------------------
library(tidyverse)

# dplyr exercises -----------------------------------------------------

# 1. Read msleep and use the function class to determine what type of
# object is returned.
class(msleep) # msleep is a tibble
msleep1 <- msleep

# 2. Now use the filter function to select only the primates. How many 
# animals are primates? # Hint: the nrow function gives you the 
# number of rows of a data frame or matrix.
str(msleep)

msleep2 <- msleep %>%
  filter(tolower(order) == "primates") %>%
  mutate(count = n()) %>%
  select(name, order, count, everything())

msleep2

# 3. What is the class of the object you obtain after subsetting the 
# table to only include primates
str(msleep2)
# tbl_df, tbl, and data.frame

# 4. Use select to extract the sleep (total) of the primates. What
# class is this object?
msleep3 <- msleep %>%
  filter(order == "Primates") %>%
  select(name, order, sleep_total)
msleep3

# 5. Now we want to calc the avg sleep for primates. One challenge
# is that the mean function requires a vector so, if we simply apply
# it to the output above, we get an error.
msleep4 <- msleep %>%
  filter(order == "Primates") %>%
  group_by(order) %>%
  summarize(mean_sleep = mean(sleep_total)) %>%
  select(order, mean_sleep)
msleep4

