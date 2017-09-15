# Library ----------------------------------------------------
library(tidyverse)

# Tidy evaluation ------------------------------------------

# bare to quosure: quo
bare_to_quo <- function(x, var){
  x %>% select(!!var) %>% head(1)
}
bare_to_quo(mtcars, quo(cyl))

# bare to quosure in fucntion: enquo
bare_to_quo_in_func <- function(x, var) {
  var_enq <- enquo(var)
  x %>% select(!!var_enq) %>% head(1)
}
bare_to_quo_in_func(mtcars, mpg)

# quosure to a name: quo_name
bare_to_name <- function(x, nm) {
  nm_name <- quo_name(nm)
  x %>% mutate(!!nm_name := 42) %>% head(1) %>% 
    select(!!nm)
}
bare_to_name(mtcars, quo(this_is_42))

# quosure to text: quo_text
quo_to_text <- function(x, var) {
  var_enq <- enquo(var)
  ggplot(x, aes_string(rlang::quo_text(var_enq))) + geom_density()
}
plt <- quo_to_text(mtcars, cyl)
plt

# character to name: sym
char_to_quo <- function(x, var) {
  var_enq <- rlang::sym(var)
  x %>% select(!!var_enq) %>% head(1)
}
char_to_quo(mtcars, "vs")

# multiple bares to quosure: quos
bare_to_quo_mult <- function(x, ...) {
  grouping <- quos(...)
  x %>% group_by(!!!grouping) %>% summarise(nr = n())
}
bare_to_quo_mult(mtcars, vs, cyl)

# multiple characters to names: syms
bare_to_quo_mult_chars <- function(x, ...) {
  grouping <- rlang::syms(...)
  x %>% group_by(!!!grouping) %>% summarise(nr = n())
}
bare_to_quo_mult_chars(mtcars, list("vs", "cyl"))

# quoting full expressions
filter_func <- function(x, filter_exp) {
  filter_exp_enq <- enquo(filter_exp)
  x %>% filter(!!filter_exp_enq)
}
filter_func(mtcars, hp == 93)
