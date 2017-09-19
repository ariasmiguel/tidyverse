### Library ----------------------------------------------
library(data.table)

# Data --------------------------------------
# Use data.table's fast file reader fread to load flights data
flights <- fread("flights.wiki/NYCflights14/flights14.csv")
head(flights)

# 1. Secondary indices ------------------------------------------

# A. What are secondary indices?
# Similar to keys, except:
# - Doesn't phisically reorder the entire data.table in RAM.
# Instead, it only computes the order for the set of columns
# provided and stores that order vector in an additional attribute
# called index

# - There can be more than one secondary index for a data.table

# B. Set and get secondary indices
# - How can we set the column origin as a secondary index in the
# data.table flights?

setindex(flights, origin)
setindexv(flights, "origin")
head(flights)
names(attributes(flights))
# setindex(flights, NULL) would remove all secondary indices

# - How can we get all the secondary indices set so far in
# flights?
indices(flights)
setindex(flights, origin, dest)
indices(flights)

# C. Why do we need secondary indices?
# - Reordering a data.table can be expensive and not always
# ideal
# - Secondary indices can be reused
# - The new `on` argument allows for clearer syntax and automatic
# creation and reuse of secondary indices

# 2. Fast subsetting using `on` argument and secondary indices -----------

# A. Fast subsets in i
# - Subset all rows where the origin airport matches "JFK" using
# `on`
flights["JFK", on = "origin"]

## alternatively
# flights[.("JFK"), on = "origin"] (or) 
# flights[list("JFK"), on = "origin"]

# If we already created a secondary index, using `setindex()`, 
# then `on` would reuse it instead of (re)computing it. We
# can see that by using `verbose = TRUE`:
setindex(flights, origin)
flights["JFK", on = "origin", verbose = TRUE][1:5]

# How can I subset based on origin and dest?
flights[.("JFK","LAX"), on = c("origin", "dest")][1:5]

# B. Select in `j`
# - Return arr_delay col alone as a data.table corresponding to
# `origin = "LGA"` and `dest = "TPA"`
flights[.("LGA", "TPA"), .(arr_delay), on = c("origin", "dest")]

# C. Chaining
# - On the result obtained above, use chaining to order the col
# in decreasing order
flights[.("LGA", "TPA"), .(arr_delay),
        on = c("origin", "dest")][order(-arr_delay)]

# D. Compute or do in `j`
# - Find the max arr_delay
flights[.("LGA", "TPA"), max(arr_delay), 
        on = c("origin", "dest")]

# E. Sub-assign by reference using `:=` in `j`
# get all 'hours' in flights
flights[, sort(unique(hour))]
flights[.(24L), hour := 0L, on = "hour"]
flights[, sort(unique(hour))]

# F. Aggregation using `by`
# - Get the maximum departure delay for each `month` 
# corresponding to `origin = "JFK"`. Order the result by `month`

ans <- flights["JFK", max(dep_delay), keyby = month,
               on = "origin"]
head(ans)

# G. The `mult` argument
# - Subset only the first matching row where `dest` matches
# "BOS" and "DAY"
flights[c("BOS", "DAY"), on = "dest", mult = "first"]

# - Subset only the last matching rows where `origin` matches
# "LGA", "JFK", "EWR" and dest matches "XNA"
flights[.(c("LGA", "JFK", "EWR"), "XNA"), 
        on = c("origin", "dest"), mult = "last"]

# H. The `nomatch` argument
# - From the previous example, subset all rows only if there's
# a match
flights[.(c("LGA", "JFK", "EWR"), "XNA"), mult = "last", 
        on = c("origin", "dest"), nomatch = 0L]

# 3. Auto indexing --------------------------------------------

# Optimise native R syntax to use secondary indices internally
# so that we can have the same performance without having to
# use newer syntax. At the moment, it is only implemented for
# binary operators `==` and `%in%`. Only works with a single
# column at the moment as well.

set.seed(1L)
dt = data.table(x = sample(1e5L, 1e7L, TRUE), y = runif(100L))
print(object.size(dt), units = "Mb")

## have a look at all the attribute names
names(attributes(dt))

## run thefirst time
(t1 <- system.time(ans <- dt[x == 989L]))

## secondary index is created
names(attributes(dt))

indices(dt)
## successive subsets
(t2 <- system.time(dt[x == 989L]))
system.time(dt[x %in% 1989:2012])
