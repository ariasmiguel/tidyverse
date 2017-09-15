# Library setup -------------------------------------------------
library(ggplot2)
library(ggthemes)
library(dplyr)
library(tidyr)
library(purrr)
library(pwt9)

# Load data -----------------------------------------------------
data("pwt9.0")

# Select list of countries
country_list <- c("France", "Germany", 
                  "United States of America", "Luxembourg", 
                  "Switzerland", "Greece")

small_pwt <- pwt9.0 %>%
  filter(country %in% country_list)

# Lets order the counties in the df as written in country_list
small_pwt <- small_pwt %>%
  mutate(country = factor(country, levels = country_list,
                          ordered = TRUE))

# Plot the same variables ------------------------------------------
# The usual way to do it is with facet_wrap() or fact_grid()
ggplot(data = small_pwt, aes(year, avh))+
  geom_line() +
  facet_wrap(~country) +
  theme_tufte()

ggplot(data = small_pwt, aes(year, avh)) + 
  geom_line() + 
  facet_grid(country~.) +
  theme_tufte()

# To have a single graph for each country
# Using group_by() and nest()
plots <- small_pwt %>%
  group_by(country) %>%
  nest() %>%
  mutate(plot = map2(data, country, ~ggplot(data = .x) + 
                       theme_tufte() +
                       geom_line(aes(y = avh, x = year)) +
                       ggtitle(.y) +
                       ylab("Year") +
                       xlab("Average annual hours worked by 
                            persons engaged")))

# By using map2() we are able to get the titles of the graphs,
# with ggtitle(unique(.$country)) in ggtitle(.y)

# nesting -----------------------
# nest() cerates a lit of df containing all the nested variables
small_pwt %>%
  group_by(country) %>%
  nest() %>%
  head()

# We get a tibble where each element of the column data is itself
# a tibble. Can apply any function that we know works on lists

print(plots) # The object created by this code

