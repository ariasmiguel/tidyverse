### Library ----------------------------------------------
library(data.table)
library(purrr)
# Data --------------------------------------
# Use data.table's fast file reader fread to load flights data
flights <- fread("flights.wiki/NYCflights14/flights14.csv")
head(flights)

# fread accepts http and https URLs directly as well as operating
# system commands such as sed and awk
# ?fread for examples

## 1. Basics --------------------------------------------------
# data.table provides an enhanced version of data.frames

# Create a enhanced version of data.frame
DT <- data.table(ID = c("b","b","b","a","a","c"),
                 a = 1:6,
                 b = 7:12,
                 c= 13:18)
DT
class(DT$ID)

# Can convert existing objects to a data.table using
# as.data.table()

# Data.table general form: --------------------------------
# DT[i, j, by]
###  R:   i            j                by
## SQL: where  select | update    group by

# Subsetting rows in i -------------------------------------
# Get all the flights with "JFK" as the origin airport in
# the month of June
ans <- flights[origin == "JFK" & month == 6L]
head(ans)

# Within the frame columns can be referred to as if they
# are variables. Therefore, we simply refer to dest and
# month as if they are variables. We do not need to add 
# the prefix flights$ each time. However using fligths$dest
# and flights$month would work just fine.

# Get the first two roms form flights.
ans <- flights[1:2]
ans

# Sort flights first by column origin in ascending order, and 
# then by dest in descending order:
ans <- flights[order(origin, -dest)]
head(ans)

# can use "-" on a character column within the frame of a 
# data.table to sort in decreasing order.

# Select column(s) in j -------------------------------------
# Select arr_delay column, but return it as a vector
ans <- flights[, arr_delay]
head(ans)

# columns can be referred to as variables. Since we only want
# all the rows, we skip `i`.

# Select arr_delay column, but return as a data.table instead
ans <- flights[, list(arr_delay)]
head(ans)

# wrapping the variables with list() ensures that data.table
# is returned

# Select both arr_delay and dep_delay columns
ans <- flights[, .(arr_delay, dep_delay)]
head(ans)

# Alternative:
ans <- flights[, list(arr_delay, dep_delay)]

# Select both and rename them:
ans <- flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]
head(ans)

# Compute or do in j ----------------------------------------
# How many trips have had total delay <0 ?
ans <- flights[, sum((arr_delay + dep_delay) < 0)]
ans

# Subset in i and do in j -----------------------------------
# Calculate the avg arr and dep delay for flights with "JFK"
# as origin airport in June
ans <- flights[origin == "JFK" & month == 6L,
               .(m_arr = mean(arr_delay), 
                 m_dep = mean(dep_delay))]
ans

# How many trips have been made in 2014 from "JFK" airport
# in the month of June?
ans <- flights[origin == "JFK" & month == 6L,
               .N] # .N is used for count
ans

# Refer to columns by names in j --------------------------
# Can do this using 'with = FALSE'
# Select both arr_delay and dep_delay columns the data.frame
# way
ans <- flights[, c("arr_delay", "dep_delay"), with = FALSE]
head(ans)

# Can deselect columns using `-` or `!`
# returns all columns except arr_delay and dep_delay
ans <- flights[, !c("arr_delay", "dep_delay"), with = FALSE]
# or
ans <- flights[, -c("arr_delay", "dep_delay"), with = FALSE]

# v1.9.5+
# returns year, month and day
ans <- flights[, year:day, with = FALSE]
# returns day, month and year
ans <- flights[, day:year, with = FALSE]
# returns all columns except year, month and day
ans <- flights[, -(year:day), with = FALSE]
ans <- flights[, !(year:day), with = FALSE]


## 2. Aggregations -------------------------------------------
# a. Grouping using by
# How can we get the number of trips corresponding to each
# origin airport?
ans <- flights[, .(.N), by = .(origin)]
ans

## or equivalently using a character vector in `by`
ans <- flights[, .(.N), by = "origin"]

# can drop the .() when only one variable

# How can we calculate the number of trips for each origin
# airport for carrier code "AA"
ans <- flights[carrier == "AA", .N, by = origin]
ans

# How can we get the total number of trips for each origin,
# dest pair for carrier code "AA"
ans <- flights[carrier == "AA", .N, by = .(origin, dest)]
head(ans)

## or equivalently using a character vector in `by`
ans <- flights[carrier == "AA", .N, by = c("origin", "dest")]

# How can we get the average arrival and departure delay
# for each orig, dest pair for each month for carrier 
# code "AA"
ans <- flights[carrier == "AA", .(mean_a = mean(arr_delay),
                                  mean_d = mean(dep_delay)),
               by = .(origin, dest, month)]
head(ans)

## b. Keyby
# Sometimes we would like to sort by the variables we grouped

# So how can we directly order by all the grouping vars?
ans <- flights[carrier == "AA", .(mean_a = mean(arr_delay),
                                  mean_d = mean(dep_delay)),
               keyby = .(origin, dest, month)]
head(ans)
# simply change by to keyby

## c. Chaining
ans <- flights[carrier == "AA", .N, by = .(origin, dest)]

# How can we oder ans using the columns orig in asc, and dest
# in desc order?
ans <- ans[order(origin, -dest)]
head(ans)

# In order to avoid intermediate assignment on to a var
# altogether by chaining expressions
ans <- flights[carrier == "AA", .N, 
               by = .(origin, dest)][order(origin, -dest)]
head(ans, 10)

## d. Expressions in by
# All delayed flights
ans <- flights[, .N, .(dep_delay>0, arr_delay>0)]
ans

## e. Multiple columns in j - .SD
# De we have to compute mean() for each column individually?
# .SD stands for Subset of Data. 
# example:
DT[, print(.SD), by = ID]

# To compute on (multiple) columns, we can then simply use the
# base R funciton lapply()
DT[, lapply(.SD, mean), by = ID]
# .SD holds the rows corresponding to columns a, b and c
# Can use map from purrr library as well
DT[, map(.SD, mean), by = ID]

# Specify the colums to compute the mean() on?
flights[carrier == "AA",                       ## Only on trips with carrier "AA"
        lapply(.SD, mean),                     ## compute the mean
        by = .(origin, dest, month),           ## for every 'origin,dest,month'
        .SDcols = c("arr_delay", "dep_delay")] ## for just those specified in .SDcols

# f. Subset `.SD` for each group:
# How can we return the first two rows for each month
ans <- flights[, head(.SD, 2), by = month]
head(ans)

# g. Why keep `j` so flexible?
# Consistent syntax and keep using already existing and
# familiar functions insead of learning new functions.

# How can we concatenate columns a and b for each group
# in ID?
DT[, .(val = c(a,b)), by = ID]

# What if we would like to have all the values of column a 
# and b concated, but returned as a list column
DT[, .(val = list(c(a,b))), by = ID]
