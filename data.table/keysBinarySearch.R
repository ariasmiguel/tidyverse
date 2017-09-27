### Library ----------------------------------------------
library(data.table)
library(purrr)
# Data --------------------------------------
# Use data.table's fast file reader fread to load flights data
flights <- fread("flights.wiki/NYCflights14/flights14.csv")
head(flights)

# 1. Keys ----------------------------------------------------------

# A. What is a key? 
# Keys provides another way of subsetting incredibly fast
set.seed(1L)
DF = data.frame(ID1 = sample(letters[1:2], 10, TRUE),
                ID2 = sample(1:3, 10, TRUE),
                val = sample(10),
                stringsAsFactors = FALSE,
                row.names = sample(LETTERS[1:10]))
DF

rownames(DF)

# We can subset a particular row using its row name as shown
# below:
DF["C",]

# Convert into a data.table
DT = as.data.table(DF)
DT
rownames(DT)
# data.tables never uses row names. If wish to preserve the row
# names, use `keep.rownames = TRUE` in `as.data.table()` - this
# will create a new column called `rn` and assign row names to
# this column

# Think of `key` as supercharged rownames
# - Can set keys on multiple columsn and the column can be of
# different types: integer, numeric, character, factor, etc..
# - Uniqueness is not enforced, i.e., duplicate key values are
# allowed. Since rows are sorted by key, any duplicates in the
# key columns will appear consecutively.
# - Setting a key does two things:
# * phisically reorders the rows of the data.table by the
# column(s) provided by refernce, always in increasing order
# * marks those columns as key columns by setting an attributed
# called sorted to the data.table


# B. Set, get and use keys on a data.table 
setkey(flights, origin)
head(flights)

## alternatively can provide character vectors to the function
# `setkeyv()`
setkeyv(flights, "origin") # useful to program with

# The data.table is now reorderd (or sorted) by the column
# we provided (origin)

# set* and `:=`
# These are the only functions which modify the input object
# by reference

# Once you key a data.table by certain columns, you can subset
# by querying those key columns using the `.()` notation in `i`

# Use the key column origin to subset all rows where the 
# origin airport matches "JFK"
flights["JFK"]              ## same as flights[.("JFK")]

flights[c("JFK", "LGA")]    ## same as flights[.(c("JFK", "LGA"))]

# How can we get the column(s) a data.table is keyed by?
key(flights)

# C. Keys and multiple cols 
# Set keys on both origin and dest:
setkey(flights, origin, dest)
setkeyv(flights, c("origin","dest"))
head(flights)

# Subset all rows using the key columns where the first key
# column origin matches "JFK" and second key col dest matches
# "MIA"
flights[.("JFK","MIA")]

# Subset all rows where just the first key column origin
# matches "JFK"
key(flights)

flights[.("JFK")]

# Subset all rows where just the second key column dest 
# matches “MIA”
flights[.(unique(origin), "MIA")]

# 2. Combining keys with j and by -----------------------------

# A. Select in j
# Return arr_delay col as a data.table corresponding to
# origin = "LGA" and dest = "TPA"
key(flights)
flights[.("LGA", "TPA"), .(arr_delay)]

# B. Chaining 
# On the result obtained above, use chaining to order the col
# in decreasing order.
flights[.("LGA", "TPA"), .(arr_delay)][order(-arr_delay)]

# C. Compute or do in j
# Find the max arr_delay corresponding to origin = "LGA"
# and dest = "TPA"
flights[.("LGA", "TPA"), max(arr_delay)]

# D. Sub-assign by reference using `:=` in j
# get all 'hours' in flights
flights[, sort(unique(hour))]

# First set key to hour, reorders flight by hour
setkey(flights, hour) 
key(flights)
flights[.(24), hour := 0L]
flights[, sort(unique(hour))]

# E. Aggregation using by
setkey(flights, origin, dest)
key(flights)

# Get the max dep_delay for each month corresponding to 
# origin = "JFK". Order the result by month
ans <- flights["JFK", max(dep_delay), keyby = month]
head(ans)
key(ans)

# 3. `mult` and `nomatch` ------------------------------------

# A. `mult` arg
# Can choose, for each query, if "all" the matching rows should
# be returned, or just the "first" or "last" using the `mult` arg.
# The def value is "all" - what we've seen so far

# - Subset only the first matching row from all rows where origin
# matches "JFK" and dest matches "MIA"
flights[.("JFK", "MIA"), mult = "first"]

# – Subset only the last matching row of all the rows where 
# origin matches “LGA”, “JFK”, “EWR” and dest matches “XNA”
flights[.(c("LGA","JFK","EWR"), "XNA"), mult = "last"]

# B. `nomatch` arg
# Can choose if queries that do not match should return NA
# or be skipped altogether using the `nomatch` arg

# - From the prev example, Subset all rows only if there's a 
# match
flights[.(c("LGA", "JFK", "EWR"), "XNA"), mult = "last", nomatch = 0L]

# Default value of `nomatch` is `NA`. Setting `nomatch = 0L`
# skips queries with no matches.

# 4. Binary search vs vector scans ----------------------------

# Binary search DT[.("LGA","XNA")] is faster 