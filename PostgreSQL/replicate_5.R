# Library --------------------------------------------------------
require("RPostgreSQL")
require("tidyverse")
require("sqldf")
require("data.table")
require("lazyeval")

subset2_ <- function(df, condition) {
  r <- lazy_eval(condition, df)
  r <- r & !is.na(r)
  df[r, , drop = FALSE]
}

# Connect to DataBase ---------------------------------------------
# Load PostgreSQL driver 
drv <- dbDriver("PostgreSQL")
sql_db <- "northwind"
sql_drv <- "RPostgreSQL"
# create con to postgres database
con <- dbConnect(drv, dbname = "northwind",
                 host = "localhost", port = 5432,
                 user = "ma")

# `AND` Operator Example --------------------------------------------
# The following SQL statement selects all customers from the country
# 'Germany' AND the city "Berlin", in the "Customers" table
table_name <- "Customers"
column_names <- c("Country", "City")
column_names_psql <- c('"Country"', '"City"')
record_values <- c("Germany", "Berlin")

sql_query <- paste(
  "SELECT * FROM ", table_name, " WHERE ", 
  paste(
    column_names_psql, 
    paste("'", record_values, "'", sep=""), 
    sep="=", 
    collapse=" AND "
  ), 
  ";", sep=""
)

cat(sql_query)
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
t0
rm(sql_query)

# Comparison
sql_query <- paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

filter_criteria <- interp(~ c1 == record_values[1] & 
                            c2 == record_values[2], 
                          .values = list(
                            c1 = as.name(column_names[1]), 
                            c2 = as.name(column_names[2])
                          )
)

t1 <- subset2_(df, filter_criteria)
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% filter_(filter_criteria)
all.equal(t0, t2, check.attributes = FALSE)

t3 <- data.table(df)
setkeyv(t3, column_names) #key(t3)
t3 <- t3[.(record_values[1], record_values[2])]

all.equal(t0, t3, check.attributes = FALSE)

# Clear
rm(sql_query)
rm(filter_criteria)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names, record_values)

# `OR` Operator Example ----------------------------------------------
# Selects all customers from the city "Berlin" OR "Mnchen", in the
# "Customers" table:
table_name <- "Customers"
column_names <- rep("City", 2)
column_names_psql <- rep('"City"', 2)
record_values <- c("Berlin", "Mnchen")

sql_query <- paste(
  "SELECT * FROM ", 
  table_name, 
  " WHERE ", 
  paste(
    column_names_psql, 
    paste("'", record_values, "'", sep=""), 
    sep="=", 
    collapse=" OR "
  ), 
  ";", sep=""
)

cat(sql_query)

# Compare
sql_query = paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

filter_criteria <- interp(~ c1 == record_values[1] | 
                            c2 == record_values[2], 
                          .values = list(
                            c1 = as.name(column_names[1]), 
                            c2 = as.name(column_names[2])
                          )
)

t1 <- subset2_(df, filter_criteria)
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% filter_(filter_criteria)
all.equal(t0, t2, check.attributes = FALSE)

t3 <- data.table(df)
setkeyv(t3, column_names)
suppressWarnings(t3 <- t3[c(record_values[[1]], record_values[[2]]),
                          nomatch=0])
all.equal(t0, t3, check.attributes = FALSE)

t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
t0
rm(sql_query)

# Clear
rm(sql_query)
rm(filter_criteria)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names, record_values)

# Combining `AND` & `OR` --------------------------------------------
# Selects all customers from the country "Germany" AND the city must 
# be equal to "Berlin" OR "Mnchen" in the "Customers" table

table_name <- "Customers"
column_names <- c("Country", rep("City", 2))
column_names_psql <- c('"Country"', rep('"City"', 2))
record_values <- c("Germany", "Berlin", "Mnchen")

sql_query <- paste(
  "SELECT * FROM ", 
  table_name, 
  " WHERE ", 
  paste(
    column_names_psql[1], 
    paste("'", record_values[1], "'", sep=""), sep="="
  ),
  " AND (", 
  paste(
    column_names_psql[2:3], 
    paste("'", record_values[2:3], "'", sep=""), 
    sep="=", 
    collapse=" OR "
  ), 
  ");", sep=""
)

cat(sql_query)
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
t0
rm(sql_query)

# Compare
sql_query <- paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

filter_criteria <- interp(~ c1 == record_values[1] & (c2 == record_values[2] | c3 == record_values[3]), 
                          .values = list(
                            c1 = as.name(column_names[1]), 
                            c2 = as.name(column_names[2]), 
                            c3 = as.name(column_names[3])
                          )
)

t1 <- subset2_(df, filter_criteria)
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% filter_(filter_criteria)
all.equal(t0, t2, check.attributes = FALSE)


t3 <- data.table(df)
setkeyv(t3, column_names)
suppressWarnings(t3 <- t3[.(record_values[[1]], c(record_values[[2]], record_values[[3]])), nomatch=0])
all.equal(t0, t3, check.attributes = FALSE)

# Clean and close the connection -------------------------------------
rm(sql_query)
rm(filter_criteria)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names, record_values)
dbDisconnect(con)
dbUnloadDriver(drv)
rm(sql_db, sql_drv, con, drv)