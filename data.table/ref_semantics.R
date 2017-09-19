### Library ----------------------------------------------
library(data.table)
library(purrr)
# Data --------------------------------------
# Use data.table's fast file reader fread to load flights data
flights <- fread("flights.wiki/NYCflights14/flights14.csv")
head(flights)

# 1. Reference Semantis -----------------------------------------
# See how to add new column(s), update or delete existing
# column(s) on the original data

# shallow vs deep copy
# - Shallow copy is a copy of the vector of column pointers. The
# actual data is not physically copied in memory.
# - A deep copy on the other hand copies the entire data to
# another location in memory

# With data.table's `:=` operator, absolutely no copies are made
# in both(1) and(2)

# b. The `:=` operator
# can be used in k in two ways:

# - a. The `LHS := RHS` form
# DT[, c("colA", "colB", ...) := list(valA, valB, ...)]
# Only one col:
# DT[, colA := valA]

# - b. The functional form
# DT[, `:=`(colA = valA,
#           colB = valB,
#           ...
# )]

# 2. Add/update/delete columns by reference --------------------
# a. Add columns by reference
# How can we add columns speed and total delay of each flight
# to flights data.table?
flights[, `:=`(speed = distance / (air_time/60), # speed in mph(mi/h)
               delay = arr_delay + dep_delay)] # delay in mins

# did not need to assign the result back to flights
# the flights data.table contains the two newly added columns

# b. Update some rows of columns by reference - sub-assign by
# reference

# All the hours available in flights
# get all 'hours' in flights
flights[, sort(unique(hour))]

# Replace those rows where `hour == 24` with the value 0
# subassign by reference
flights[hour == 24L, hour := 0L][] # adding [] prints the result

# verify
flights[, sort(unique(hour))]

# Exercise ----------------------------------------------------
# What is the difference between flights[hour == 24L, hour := 0L]
# and flights[hour == 24L][, hour := 0L]

# The second expression updates a new data.table that's returned
# by the subset operation. Since the subsetted data.table is
# ephemeral, the result would be lost; unless the result is
# assigned with (<-)

# c. Delete column by reference

# Remove `delay` column
flights[, c("delay") := NULL]
head(flights)
# using functional form:
flights[, `:=`(delay = NULL)]

# Assigning NULL to a column deletes that column. And it happens
# instantly
flights[, delay := NULL]

# d. `:=` along with a grouping using by

# How can we add a new column which contains for each orig, dest
# pair the maximum speed
flights[, `:=`(max_speed = max(speed)),
          by = .(origin, dest)]
head(flights)

# e. Multiple columns and `:=`

# How can we add two more columns computing `max()` of `dep_delay`
# and `arr_delay` for each month, using `.SD`?
in_cols = c("dep_delay", "arr_delay")
out_cols = c("max_dep_delay", "max_arr_delay")
flights[, c(out_cols) := lapply(.SD, max),
          by = month,
          .SDcols = in_cols][]
head(flights)

# RHS gets automatically recycled to length of LHS
flights[, c("speed", "max_speed", "max_dep_delay",
            "max_arr_delay") := NULL]

head(flights)

# 3. `:=` and copy()
# a.`:=` for its side effect

# Simple function that returns max speed per month and adds the
# column speed of flights
foo <- function(DT){
  DT[, speed := distance / (air_time/60)]
  DT[, .(max_speed = max(speed)), by = month]
}
ans = foo(flights)
head(flights)
head(ans)

# b. The `copy()` function
# Sometimes we don't want to update the data.table

# The `copy()` function deep copies the input object and
# therefore any subsequent update by reference operations
# performed on the copied object will not affect the original
# object

# `copy()` function essentail in:
#   1. We don't want to modify flights by refernce
foo <- function(DT) {
  DT <- copy(DT)                              ## deep copy
  DT[, speed := distance / (air_time/60)]     ## doesn't affect 'flights'
  DT[, .(max_speed = max(speed)), by = month]
}
ans <- foo(flights)
head(flights)
head(ans)

#   2. When we store the column names on to a variable, e.g., 
# `DT_n = names(DT)`, and then add/update/delete column(s) by
# reference. It would also modify `DT_n`, unless we do
# `copy(names(DT))`
DT = data.table(x = 1L, y = 2L)
DT_n = names(DT)
DT_n
## add a new column by reference
DT[, z := 3L][]
## DT_n also gets updated
DT_n
## use `copy()`
DT_n = copy(names(DT))
DT[, w := 4L][]
## DT_n doesn't get updated
DT_n
