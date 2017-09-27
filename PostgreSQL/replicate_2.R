# Library --------------------------------------------------------
require("RPostgreSQL")
require("tidyverse")
require("sqldf")
require("data.table")
require("lazyeval")

# Connect to DataBase ---------------------------------------------
# Load PostgreSQL driver 
drv <- dbDriver("PostgreSQL")
sql_db <- "northwind"
sql_drv <- "RPostgreSQL"
# create con to postgres database
con <- dbConnect(drv, dbname = "northwind",
                 host = "localhost", port = 5432,
                 user = "ma")

# SELECT Column example --------------------------------------------
# In order to select column names with PostgreSQL
# Column names must be in quotations ""
table_name = "Customers"
column_names = c("ContactName", "City")
column_names_psql = c('"ContactName"', '"City"')
sql_query = paste("SELECT ", paste(column_names_psql, collapse=", "), 
                  " FROM ", table_name, ";", sep="")
cat(sql_query)

# sqldf
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
head(t0, 5)

# RPostgreSQL
t0 <- dbGetQuery(con, sql_query)
head(t0, 5)

# Compare ------------------------------------------------------------
sql_query = paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

t1 <- df[, column_names]
all.equal(t0, t1, check.attributes = FALSE)

t2 <- df %>% select(one_of(column_names))
all.equal(t1, t2, check.attributes = FALSE)

t3 <- data.table(df)
# setkeyv(t3, column_names)
t3 <- t3[, column_names, with = FALSE] # t3[, .SD, .SDcols=column_names]
all.equal(t1, t3, check.attributes = FALSE)

# Remove values ----------------------------------------------
rm(sql_query)
rm(df, t0, t1, t2, t3)
rm(table_name, column_names)

# Close the connection -------------------------------------------
dbDisconnect(con)
dbUnloadDriver(drv)
