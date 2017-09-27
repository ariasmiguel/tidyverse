# Library --------------------------------------------------------
require("RPostgreSQL")
require("tidyverse")
require("sqldf")
require("datatable")
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

# Database Tables --------------------------------------------------
sql_query <- "SELECT * FROM Customers;"

# Using sqldf
head(sqldf(sql_query, dbname = sql_db, drv = sql_drv), 5)

# Using RPostgreSQL
head(dbGetQuery(con, sql_query), 5)

rm(sql_query)

# Close the connection -------------------------------------------
dbDisconnect(con)
dbUnloadDriver(drv)

