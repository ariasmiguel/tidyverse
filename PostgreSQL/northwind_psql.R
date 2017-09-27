# Library --------------------------------------------------------------------------
lapply(c("sqldf", "gdata", "RPostgreSQL","datamodelr","tidyverse", "DiagrammeR"),
       FUN = function(X) {suppressMessages(do.call("require", list(X)))})
options(stringsAsFactors=FALSE)

# Setup -----------------------------------------------------------------------------
# change driver to mysql and use : 
# https://github.com/bergant/datamodelr

# Loads data into northwind database
# system("psql -U ma -d northwind -f ./northwind.postgre.sql")

# Connect to DataBase ---------------------------------------------
# pw <- {
  "welcome1"
}

# Load PostgreSQL driver 
drv <- dbDriver("PostgreSQL")

# create con to postgres database
con <- dbConnect(drv, dbname = "northwind",
                 host = "localhost", port = 5432,
                 user = "ma")
# rm(pw) # removes password

sQuery <- dm_re_query("postgres")
dm_northwind <- dbGetQuery(con, sQuery)
dbDisconnect(con)

dm_northwind <- as.data_model(dm_northwind)

# Add references (If not placed previously) --------------------------
# dm_northwind <- dm_add_references(
#   dm_northwind,
#   
#   products$SupplierID = suppliers$SupplierID,
#   products$CategoryID = categories$CategoryID,
#   order_details$OrderID = orders$OrderID,
#   order_details$ProductID = products$ProductID,
#   customercustomerdemo$CustomerID = customers$CustomerID,
#   customercustomerdemo$CustomerTypeID = customerdemographics$CustomerTypeID,
#   orders$CustomerID = customers$CustomerID,
#   orders$EmployeeID = employees$EmployeeID,
#   orders$ShipVia = shippers$ShipperID,
#   employeeterritories$EmployeeID = employees$EmployeeID,
#   employeeterritories$TerritoryID = terriroties$TerritoryID,
#   territories$RegionID = region$RegionID,
#   employees$ReportsTo = employees$EmployeeID
# )

# Show model ---------------------------------------------------------
graph <- dm_create_graph(dm_northwind, rankdir = "BT")
dm_render_graph(graph)
