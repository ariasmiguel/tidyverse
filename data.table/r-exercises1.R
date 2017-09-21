# Library ----------------------------------------------------------
library(data.table)
library(ggplot2)

# Exercise 1 ----
# Load the iris dataset, make it a data.table
# Print mean of Petal.Length, grouping by first letter of Species
iris_dt <- as.data.table(iris)
head(iris_dt)
iris_dt[, mean(Petal.Length), by = substr(Species,1,1)]

# Exercise 2 ----
# Load the diamonds dataset from ggplot2 package as (a data.table)
# Find mean price for each group of cut and color
diamonds <- as.data.table(diamonds)
head(diamonds)
diamonds[, mean(price), by = .(cut, color)][1:5]

# Exercise 3 ----
# Load the diamonds dataset from ggplot2 as dt. Group the dataset
# by price per carat and print top 5 in terms of count per group.
diamonds[, .N, by = .(price_per_carat = price/carat)][
                    order(-N)][1:5]

# Exercise 4 ----
# Use the already loaded diamonds dataset and print the last two
# carat value for each cut
diamonds[, .(tail(carat,2)), by = cut]

# Exercise 5 ----
# Find median of the columns x,y,z per cut
head(diamonds)
diamonds[, lapply(.SD, median), 
           by = cut, .SDcols = c("x","y","z")]

# Exercise 6 ----
# Load the airquality dataset as data.table
# Find the log of wind rate for each month and for days 
# greater than 15
airquality <- as.data.table(airquality)
str(airquality)
airquality[Day > 15, log10(Wind), by = Month]
airquality[,lapply(.SD,log10),by=.(by1=Month,by2=Day>15),
           .SDcols=c("Wind")][by2==TRUE]

# Exercise 7 ----
# For all the odd rows, update Temp column by adding 10
airquality[rep(c(TRUE, FALSE), length = .N), Temp := Temp + 10L]

# Exercise 8 ----
head(airquality)
airquality[, `:=`(Solar.R = Solar.R + 10L,
                  Wind = Wind + 10)]

# Exercise 9 ----
airquality[, `:=`(Solar.R = NULL,
                  Wind = NULL,
                  Temp = NULL)]
head(airquality)

# Exercise 10 ----
rm(airquality)
airquality <- as.data.table(airquality)
str(airquality)
# Create two columns a, b which indicates temp in Celsius and 
# Kelvin scale. 
# Celcius = (Temp-32)*5/9
# Kelvin = Celcius + 273.15
airquality[, Celcius := (Temp-32)*5/9][,Kelvin := Celcius + 273.15]
head(airquality)
airquality[,c("a","b"):= list(celcius <- (Temp-32)*5/9,
                       kelvin <- celcius+273.15)]
head(airquality)
