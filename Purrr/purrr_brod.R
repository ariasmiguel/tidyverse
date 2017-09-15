# Library setup --------------------------------------------------------
library(tidyverse)
library(repurrrsive)
library(jsonlite)
library(magrittr)
library(stringr)
library(stringi)

# Map conditionally ---------------------------------------------
# Createa a helper function that returns TRUE if a number is even
numbers <- list(11, 12, 13, 14)

is_even <- function(x) !as.logical(x %% 2)

map_if(numbers, is_even, sqrt) # Only takes the sqrt of even num

map_at(numbers, c(1,3), sqrt)
# map_at() applies the function to the specific indexes

# Don't stop execution ------------------------------------------
possible_sqrt <- possibly(sqrt, otherwise = NA_real_)

numbers_with_error <- list(1, 2, 3, "spam", 4)

map(numbers_with_error, possible_sqrt)

# By using possibly() the function doesn't stop if there's an
# error

# Capture the error------------
safe_sqrt <- safely(sqrt, otherwise = NA_real_)

map(numbers_with_error, safe_sqrt)

# Returns a list of lists. An element is thus a list of the
# result and the error message. If there is no error, the 
# error component is NULL. If there is an error, it
# returns the error message.

# Transpose a list ------------------------------------------
safe_result_list <- map(numbers_with_error, safe_sqrt)
transpose(safe_result_list)

# Apply a function to a lower depth of a list ---------------
transposed_list <- transpose(safe_result_list)

transposed_list %>%
  at_depth(2, is_null)

# Set names of list elements -------------------------------
name_element <- c("sqrt()", "ok?")

set_names(transposed_list, name_element)

# Reduce and accumulate() --------------------------------
reduce(numbers, `*`) # Applies `*` iteratievly to the list

accumulate(numbers, `*`) # Same as reduce, keeps results

# Can reduce anything
# Matrices
mat1 <- matrix(rnorm(10), nrow = 2)
mat2 <- matrix(rnorm(10), nrow = 2)
mat3 <- matrix(rnorm(10), nrow = 2)

list_mat <- list(mat1, mat2, mat3)

reduce(list_mat, `+`)

# data frames
df1 <- as.data.frame(mat1)
df2 <- as.data.frame(mat2)
df3 <- as.data.frame(mat3)

list_df <- list(df1, df2, df3)

reduce(list_df, dplyr::full_join)