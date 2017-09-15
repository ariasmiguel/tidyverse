# Library setup ------------------------------------------------------
library("Julia")
library(tidyverse)
library(future)


# Julia Sets ---------------------------------------------------------
# http://www.jottr.org/2017/06/the-many-faced-future.html?m=1
set <- JuliaImage(1000, centre = 0 + 0i, L = 3.5, C = -0.4 + 0.6i)

plot_julia <- function(img, col = topo.colors(16)){
  par(mar = c(0, 0, 0, 0))
  image(img, col = col, axes = FALSE)
}
plot_julia(set)

# For the purpose of calculating different Julia sets in parallel
# Use the same (centre, L) = (0 + 0i, 3.5) region as above with
# the following coefficients (from Julia set):
Cs <- list(
  a = -0.618,
  b = -0.4 + 0.6i,
  c = 0.285 + 0i,
  d = 0.285 + 0.01i,
  e = 0.45 + 0.1428i,
  f = -0.70176 - 0.3842i,
  g = 0.835 - 0.2321i,
  h = -0.8 + 0.156i,
  i = -0.7269 + 0.1889i,
  j = -0.8i
)

# Create a list of sets with the different coefficients:
# Sequential
sets <- lapply(Cs, function(C) {
  JuliaImage(1000, centre = 0 + 0i, L = 3.5, C = C)
})

# Futures with purrr (= furrr)
plan(multisession) ## specifies what type of futures

sets <- Cs %>%
  map(~ future(JuliaImage(1000, centre = 0 + 0i, 
                          L = 3.5,
                          C = .x))) %>%
  values
