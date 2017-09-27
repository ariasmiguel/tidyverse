# Library ----------------------------------------------------------
library(data.table)
library(ggplot2)
library(purrr)
library(AER)

# Use data drawn from the 1980 US Census on married woman aged 21-35
# with two or more children (AER package)

# Exercise 1 ----
data("Fertility")
fertility <- as.data.table(Fertility)
str(fertility)

# Exercise 2 ----
# Select rows 35 to 50 and print to console its age and work entry
fertility[35:50, .(age, work)]

# Exercise 3 ----
# Select the last row in the dataset and print to console
fertility[.N]

# Exercise 4 ----
# Count how many women proceeded to have a third child
fertility[morekids == "yes", .(count = .N)]

# Exercise 5 ----
# There are four possible gender combinations for the first two
# children. Which is the most common
fertility[, .(count = .N), by = .(gender1, gender2)][order(-count)]

# Exercise 6 ----
# By racial composition what is the proportion of woman working
# four weeks or less in 1979
fertility[ , mean(work <= 4), 
            by = .(afam, hispanic, other)][order(-V1)]

# Exercise 7 ----
# Use %between% to get a subset of woman between 22 and 24.
# Calculate the proportion who had a boy as their first born
fertility[age %between% c(22L,24L), .(mean(gender1 == "male"))]

# Exercise 8
# Add a new column, age squared, to the dataset
fertility[, age_sq := age^2]

# Exercise 9
# Out of the racial composition in the dataset which had the lowest
# proportion of boys for their first born.
total = fertility[,.N]
fertility[, .(.N, prop_m = mean(gender1 == "male")),
          by = .(afam, hispanic, other)]

# Exercise 10
# Calculate the proportion of woman who have a third child
# by gender combination of the first two children
fertility[, .(prop_m = mean(morekids == "yes")),
          by = .(gender1, gender2)]
