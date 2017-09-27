# Library setup --------------------------------------------------
library(tidyverse)
library(stringi)

# Functional programming ---------------------------------------

# Compute sqrt root of a number using Newton's Algorithm
sqrt_newton <- function(a, init, eps = 0.01){
  while(abs(init**2 - a) > eps) {
    init <- 1/2 *(init + a/init)
  }
    return(init)
}

sqrt_newton(16, 2)

# Using a while loops is not part of functional programming
# Use recursion:

sqrt_newton_recur <- function(a, init, eps = 0.01){
  if(abs(init**2 - a) < eps) {
      result <- init
  } else {
      init <- 1/2 * (init + a/init)
      result <- sqrt_newton_recur(a, init, eps)
  }
  return(result)
}

sqrt_newton_recur(16, 2)

# Actually loops are more efficient, performance-wise, in R.

# Functions should have no, or very limited, side-effects.

# Mapping with Map() and *apply() family of functions
numbers <- c(16, 25, 36, 49, 64, 81)
Map(sqrt_newton, numbers, init = 1)
sqrt_newton_vec <- function(numbers, init, eps = 0.01){
  return(Map(sqrt_newton, numbers, init, eps))
}

sqrt_newton_vec(numbers, 1)
lapply(numbers, sqrt_newton, init = 1) # returns a list of lists
sapply(numbers, sqrt_newton, init = 1) # returns a list of numbers

# The purrr way -------------------------------------------------
map(numbers, sqrt_newton, init = 1)
reduce(numbers, `+`)
reduce_right(numbers, `-`)
accumulate(numbers, `+`)


# Exercises --------------------------------------------------
# Writing unit tests before the functions they're supposed to test
# is called test-driven development and can help you write your
# functions

# 1. Create a function that returns the factorial of a number using
# reduce
my_fact <- function(x) {
  factorial <- seq(1,x)    # Creates a vector of length(x) from 1:x
  reduce(factorial, `*`)
}
my_fact(5)

# 2. Suppose you have a list of data set names. Create a function that
# removes ".csv" from each of these names. Stary by creating a function
# that does so using stri_split() from the package stringi. 
dataset_names <- c("dataset1.csv", "dataset2.csv", "dataset3.csv")
remove_csv <- function(names) {
  removed <- map(names, ~stri_split_regex(.x, "\\.csv",
                                          omit_empty = TRUE))
  removed <- unlist(removed)
  return(removed)
}
remove_csv(dataset_names)

# 3. Create a function that takes a number a, and then returns either
# the sum of the numbers from 1 to this number that are divisible by
# another number b or the product of the numbers from 1 to this number
# that are divisible by b. 

divisible <- function(a, b) {
  !as.logical(a %% b)           # Checks if 'a' divisible by 'b'
}

reduce_some_numbers <- function(a, divisible_func = divisible, 
                                b, reduce_op = `*`){
    sum <- seq(1, a)             # Creates vector of 1 to a
    logical <- divisible(sum, b) # Applies divisible to sum
    sum <- sum[logical]          # Eliminitates non divisible values
    answer <- reduce(sum, reduce_op)  # Applies reduce
    return(answer)
}
