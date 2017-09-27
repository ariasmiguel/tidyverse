### Library ------------------------------------------------------
library(data.table)
library(purrr)

# Data ------------------------------------------------------------
# Use data.table's fast file reader fread to load flights data
DT <- fread("flights.wiki/NYCflights14/flights14.csv")
head(DT)

#-------------------------------------------------------------------
# Change data from long-to-wide (?dcast), wide-to-long (?melt)
# Sorting rows and re-ordering columns

ans <- DT[order(carrier, -dep_delay),
          .(carrier,origin,dest,dep_delay)]
head(ans)

# To re-order data by reference, instead of querying data in specific
# order, we use set* functions.
setorder(DT, carrier, -dep_delay)
leading.cols <- c("carrier","dep_delay")
setcolorder(DT, c(leading.cols, setdiff(names(DT), leading.cols)))
print(DT)

# Subset Queries ----------------------------------------------------
ans2 <- DT[origin == "JFK" & month %in% 6L:9L,
           .(origin, month, arr_delay, dep_delay,
             sum_delay = arr_delay + dep_delay)]
head(ans2)

# Update Dataset -----------------------------------------------
# Single var
DT[, sum_delay := arr_delay + dep_delay]
head(DT)

# Multiple variables
# DT[, `:=`(sum_delay = arr_delay + dep_delay)]

DT[origin == "JFK", distance := NA]
head(DT)

# Aggregate Data -----------------------------------------------
# Query
ans3 <- DT[, .(m_arr_delay = mean(arr_delay),
               m_dep_delay = mean(dep_delay),
               count = .N),
              by = .(carrier, month)]
head(ans3)

# Update
DT[, `:=`(carrierm_mean_arr = mean(arr_delay),
          carrierm_mean_dep = mean(dep_delay)),
          by = .(carrier, month)]
head(DT)

# Join Datasets ------------------------------------------------
# If we want to keep only matching rows (inner join), then we pass
# an extra argument `nomatch = 0L`. We use `on` argument to specify
# cols on which we want to join both datasets.

# Create reference subset
carrierdest <- DT[, .(count =.N), by = .(carrier,dest) # count by carrier and dest
                  ][1:10] # just 10 first groups, chaining [...][...]
print(carrierdest)                

# Outer join
outerjoin <- carrierdest[DT, on = c("carrier","dest")]
print(outerjoin)

# Inner join
innerjoin <- DT[carrierdest,              # for each row in carrierdest
              nomatch = 0L,               # return only matching rows from both tables
              on = c("carrier","dest")]   # joining on columns carrier and dest
print(innerjoin)

# To lookup the column(s) to our dataset:
DT[carrierdest,              # data.table to join with
   lkp.count := count,       # lookup `count` col from `carrierdest`
   on = c("carrier","dest")] # join by cols
head(DT)

# For aggregate while join, use by = .EACHI
# It performs join that won't materialize intermediate join
# results and will apply aggregates on the fly. (more efficient)

# Rolling join fits perfectly for processing temporal data, and
# time series in general. Basically roll matches in join cond
# to next matching value

# Profiling Data -----------------------------------------------
# Descriptive stats
summary(DT)

# Cardinality
DT[, map(.SD, uniqueN)]

# NA Ratio
DT[, map(.SD, ~ sum(is.na(.x))/.N)]

# Exporting data
tmp.csv <- tempfile(fileext = ".csv")
fwrite(DT, tmp.csv)
# preview exported data
cat(system(paste("head -3", tmp.csv), 
           intern = TRUE), sep = "\n")