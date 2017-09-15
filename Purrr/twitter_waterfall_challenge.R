# Library setup -------------------------------------------------
library(tidyverse)
library(forcats)
library(microbenchmark)

# Twitter Waterfall Problem -------------------------------------
# https://eric.netlify.com/2017/08/24/using-purrr-to-refactor-imperative-code/
# Given a set of walls, where would water accumulate?

# Imperative Solution --------------------------------------------
# Walls represented by a simple numerical vector wall. Then iterate over
# these walls.
# 1. Find height of the current index
# 2. Find max heigh of walls to the left
# 3. Find max heigh of walls to the right
# 4. Find smallest max heigh between left & right
# 5. If smallest - current index > 0, amount of blocks water will fill
# 6. If smallest - current < 0, then water run off

wall <- c(2, 5, 1, 2, 3, 4, 7, 7, 6)

get_water_original <- function(wall) {
  len <- length(wall)
  # pre-allocate memory to make the loop more efficient
  water <- rep(0, len)
  for (i in seq_along(wall)) {
    currentHeight <- wall[i]
    maxLeftHeight <- if (i > 1) {
      max(wall[1:(i - 1)])
    } else {
      0
    }
    maxRightHeight <- if (i == len) {
      0
    } else {
      max(wall[(i + 1):len])
    }
    smallestMaxHeight <- min(maxLeftHeight, maxRightHeight)
    water[i] <- if (smallestMaxHeight - currentHeight > 0) {
      smallestMaxHeight - currentHeight
    } else {
      0
    }
  }
  water
}

get_water_original(wall)

# Functional Solution --------------------------------------------

# 1. For a given i, find current height, max height left & right
# 2. For a give set of heights, find min of max heights left & right,
# and find the difference between max heights and current height.
# 3. Machinery for iterating over the wall vector and populating
# the water vector

# Create function get_heights -------
get_heights <- function(wall, i) {
  left  <- wall[seq_len(i - 1)]
  right <- wall[seq(i + 1, length(wall))]
  list(l = max(left, 0, na.rm = TRUE),
       m = wall[i],
       r = max(right, 0, na.rm = TRUE))
}

get_heights(wall, 2)
# l is max height to the left
# m is the height of the index
# r is max height to the right

get_heights(wall, 2)

# Create function get_depth -------
get_depth <- function(h) {
  max(min(h$l, h$r) - h$m, 0) # doesn't match, keeps value 1 right corner
}

get_depth2 <- function(h) {
  max(min(h$r, h$l) - h$m, 0)
}
get_depth2(get_heights(wall, 2))

# Compose -----------------------------
# The co-domain of get_heights matches up with the domain of
# get_depth. Can compose the two functions with purrr:compose
# to create a function f which takes as input a wall and an i
# and returns the depth of water at that position

f <- compose(get_depth2, get_heights)
# Equivalent to:
# f <- function(wall, i) get_depth(get_heights(wall, i))

# Iteration ----------------------------
get_water <- function(wall) {
  map_dbl(seq_along(wall), f, wall = wall)
}

get_water(wall)

# Comparing results ----------------------------------------------
big_wall <- sample(1:1000, 1000, TRUE)
all(get_water_original(wall) == get_water(wall))
get_water_original(wall)
get_water(wall)

# Check which is faster
microbenchmark(get_water(big_wall), get_water_original(big_wall))
# The functional solution is somewhat smaller

# Plot the solution
# Create DF for wall and water 
df_solution <- function(wall) {
  df <- data_frame(
    x = seq_along(wall),
    wall,
    water = get_water(wall)
  )
  gather(df, key, y, -x)
}

df_solution(wall)

# Pass the data frame into the plot
plot_solution <- function(df) {
  ggplot(df, aes(x + 0.5, y, fill = fct_rev(key))) +
    geom_col(position = "stack", show.legend = FALSE, width = 1) +
    scale_fill_manual(values = c("steelblue", "grey")) +
    scale_x_continuous(breaks = seq_along(wall)) +
    scale_y_continuous(breaks = seq(0, max(wall), 1)) +
    theme_void() +
    theme(
      strip.text = element_blank(),
      panel.ontop = TRUE,
      panel.grid.major.x = element_line(colour = "white", size = 0.1),
      panel.grid.major.y = element_line(colour = "white", size = 0.1),
      plot.margin = unit(rep(0.1, 4), "cm")
    ) +
    coord_equal()
}

plot_solution(df_solution(wall))

# Create a large number of random walls and plot each solution
# as a separate facet
walls <- rerun(25, df_solution(sample(1:10, 10, TRUE))) %>% 
  bind_rows(.id = "draw")

plot_solution(walls) +
  facet_wrap(~draw) +
  ggtitle("Twitter Waterfall Challenge")

# Summary ----------------------------------------------------
# 1. Split for loop into two small functions
# 2. Composed these functions together
# 3. Mapped the composite function over the wall vector