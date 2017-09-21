# Library ----------------------------------------------------------
library(data.table)
library(ggplot2)
library(purrr)

# Exercise 1 ----
# Load the data using fread()
dt <- fread("data.table/toy_cor.csv")

# Exercise 2 ----
# Print out the most common car model in the data, and the
# number of times it appears.
str(dt)
dt[,.N, by = Model][order(-N)][1]

# Exercise 3 ----
# Mean and median price of top 10 common models
dt[, .(count = .N,
       mean_p = mean(Price),
       median_p = median(Price)), by = Model][
         order(-count)][1:10]

# Exercise 4 ----
# Delete all columns that have guarantee in its name
str(dt)
dt[, grep("Guarantee", names(dt)) := NULL]

# Exercise 5 ----
# Add a new col which is the sq deviation of price from the
# average price of cars the same color
dt[, sq_dev_bycol := (Price - mean(Price))^2, by = Color]

# Exercise 6 ----
# Use a comb of .SDcols and lapply to get the mean value of
# cols 18 through 35
dt[, lapply(.SD, mean), .SDcols = 18:35]

# Exercise 7
# Print the most common color by age in years
dt[, .N, by = .(Color, Age_08_04)][order(-N)][1]

# Exercise 8 
# For the dummy variables in cols 18:35 recode 0 to -1
?set
for (j in 18:35) {
  set(dt,
      i = dt[, which(.SD == 0), .SDcols = j],
      j = j,
      value = -1)
}

# Exercise 9
# Use the set function to add "yuck!" to the var Fuel_Type
# if it is not petrol
set(dt,
    i = dt[, which(Fuel_Type == "Petrol")],
    j = "Fuel_Type",
    value = "Petrol yuck!")

# Exercise 10
# Using .SDcols and one command create two new vars
# log of Weight and Price
dt[, c("log_Weight", "log_Price") := lapply(.SD, log10),
      .SDcols = c("Weight", "Price")]
head(dt)
