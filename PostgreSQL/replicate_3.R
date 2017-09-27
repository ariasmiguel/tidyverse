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

# SQL SELECT DISTINCT Syntax -------------------------------------
table_name = "Customers"
sql_query = paste("SELECT * FROM ", table_name, ";", sep="")
df <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)

column_names = "City"
column_names_psql = '"City"'
sql_query = paste("SELECT DISTINCT ", column_names_psql, 
                  " FROM " , table_name, ";", sep="")
cat(sql_query)
t0 <- sqldf(sql_query, dbname = sql_db, drv = sql_drv)
t0 <- dbGetQuery(con, sql_query)
t0[is.na(t0)] <- 0
t0 <- t0[order(t0),]
head(t0, 10)

rm(sql_query)

# Compare
t1 <- unique(df[, column_names])
t1[is.na(t1)] <- 0
t1 <- t1[order(t1)]

t2 <- df %>% select_(column_names) %>% distinct %>% unlist
t2[is.na(t2)] <- 0
t2 <- t2[order(t2)]

t3 <- copy(df)
t3 <- t3[column_names]
t3 <- unique(t3)
# http://stackoverflow.com/questions/7235657/fastest-way-to-replace-nas-in-a-large-data-table
suppressWarnings(set(t3,which(is.na(t3[[1]])),1L,0))
t3 <- t3[order(t3),]

all.equal(t0, t3, check.attributes = FALSE)
all.equal(t0, t2, check.attributes = FALSE)
all.equal(t0, t1, check.attributes = FALSE)

# Clear -----------------------------------------------------
rm(df, t0, t1, t2, t3)
rm(table_name, column_names)

# Close the connection -------------------------------------------
dbDisconnect(con)
dbUnloadDriver(drv)
rm(sql_db, sql_drv, con, drv)

