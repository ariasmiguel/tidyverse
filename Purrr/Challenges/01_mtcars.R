# Many models challenge
library(purrr)
library(tidyverse)

?mtcars

# Your Task ---
# Fit a regression model, of mpg against disp, for cars
# of the same number of cylinders. Then summarise those
# models using r^2 and the estimated slope.

# A list of data frames 
mtcars_by_cyl <- mtcars %>% split(mtcars$cyl)
mtcars_by_cyl

# Do it to one element
lm(mpg ~ disp, mtcars_by_cyl[[1]]) %>%
  plot()

# Fit a regression model to each element 
map(mtcars_by_cyl, ~ lm(mpg ~ disp, .x))

# Extract R^2 from each regression model
map(mtcars_by_cyl, ~ lm(mpg ~ disp, .x)) %>%
  map_dbl(~summary(.x)$r.squared) # extracts r^2 from the regression

