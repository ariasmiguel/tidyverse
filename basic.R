# Library setup --------------------------------------------------
library(tidyverse)

## Non-Standard Eval -----------------------------------------------
# Expression ------------------------------------------------------
# Expression is R code that is ready to be evaluated, but is 
# not evaluated
# yet
quote(x) %>% class()
quote(mean(1:10)) %>% class()

# quote() is used to capturing an expression instead of 
# evaluating it

# Name -----------------------------------------------------------
x <- 50
exp_x <- quote(x) # Caputres value of x
eval(exp_x)       # evaluates it

eval_me <- quote(y)
eval(eval_me)
y <- "I am ready"
eval(eval_me)

as.name("x") # creates a name from a string, as.symbol() does the same

# Call ------------------------------------------------------------
# The function to be called, with the names of the objects used for
# the arguments, are stored until further notice

wait_for_it <- quote(x + y)
x <- 3; y <- 8
eval(wait_for_it)

# deparse(): returns an expression as a string
print_func <- function(expr){
  paste("The value of", deparse(expr), "is", eval(expr))
}
print_func(wait_for_it)

print_func(quote(log(42) %>% round(1)))

print_func(quote(x))

# Different environemnts for values
# Global and env within a function.

# Substitute and promise -------------------------------------------
add_squared <- function(x, col_name) {
  new_colname <- 
}