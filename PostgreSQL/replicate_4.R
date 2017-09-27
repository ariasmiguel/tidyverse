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

# WHERE Clause Example ---------------------------------------------
table_name <- "Customers"
column_names <- "Country"
record_values <- "Mexico"
column_names_psql <- '"Country"'

sql_query <- paste("SELECT * FROM ", table_name,
                   " WHERE " , column_names_psql, "=", "'",
                   record_values, "'", ";", sep="")
cat(sql_query)
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
head(t0, 5)
rm(sql_query)

sql_query = paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

filter_criteria <- interp(~ which_column == record_values,
                          which_column = as.name(column_names))

t1 <- subset2_(df, filter_criteria)
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% filter_(filter_criteria)
all.equal(t0, t2, check.attributes = FALSE)

t3 <- data.table(df)
setkeyv(t3, column_names)
t3 <- t3[record_values]

all.equal(t0, t3, check.attributes = FALSE)

# Clear
rm(sql_query)
rm(filter_criteria)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names, record_values)

# Text Fields vs. Numeric Fields ------------------------------------
table_name <- "Customers"
column_names <- "CustomerID"
column_names_psql <- '"CustomerID"'
record_values <- "ALFKI"

sql_query <- paste("SELECT * FROM ", table_name, " WHERE " ,
                   column_names_psql, "=", "'", record_values,
                   "'", ";", sep="")
cat(sql_query)
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
head(t0, 5)
rm(sql_query)

sql_query <- paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

filter_criteria <- interp(~ which_column == record_values,
                          which_column = as.name(column_names))
t1 <- subset2_(df, filter_criteria)
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% filter_(filter_criteria)
all.equal(t0, t2, check.attributes = FALSE)

t3 <- data.table(df)
setkeyv(t3, column_names)
t3 <- t3[record_values]

all.equal(t0, t3, check.attributes = FALSE)

# Clean and close the connection -------------------------------------
rm(sql_query)
rm(filter_criteria)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names, record_values)
dbDisconnect(con)
dbUnloadDriver(drv)
rm(sql_db, sql_drv, con, drv)
