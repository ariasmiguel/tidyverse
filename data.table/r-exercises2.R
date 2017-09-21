# Library ----------------------------------------------------------
library(data.table)
library(ggplot2)
library(purrr)

# Exercise 1 ----
# Create a data.table from diamonds. Create key using setkey
# over cut and color. Now select first entry of the groups 
# Ideal and Premium
diamonds <- as.data.table(diamonds)
setkeyv(diamonds, c("cut","color"))
diamonds[c("Ideal", "Premium"), mult="first"]

# Exercise 2 ----
# Select the first and last entry of the groups Ideal and Premium
diamonds[c("Ideal", "Premium"), 
         .SD[c(1,.N)], by = .EACHI]

# Exercise 3 ----
# Make columns x,y,z value squaread. 
diamonds[, map(.SD, ~.x^2), .SDcols = c("x","y","z")]
cols = c("x","y","z")
for (i in cols)set(diamonds,j = i,value = diamonds[[i]]^2) # Using for loop and set

# Exercise 4 ----
# Capitalize the first letter of column names
setnames(diamonds, names(diamonds),
                   gsub("^([a-z])", "\\U\\1", 
                        names(diamonds), perl=TRUE))
head(diamonds)

# Exercise 5 ----
# Reorder your diamonds data.table's column by sorting 
# alphabetically
setcolorder(diamonds, sort(names(diamonds)))
str(diamonds)

# Exercise 6 ----
# Create a metric on diamonds where we find for each group of
# cut `maximum of x * mean of depth` and name it `a`
# and also create another metric which is `a*max(y)`
# for each group of cut
diamonds[, my_int_feature := max(X)*mean(Depth), by = Cut][
        , my_int_f2 := my_int_feature*max(Y), by = Cut] # Chaining
diamonds[,{m= mean(Depth)
          my_int_feature= max(X)*m
          my_int_feature2 = max(Y)*my_int_feature
          list("my_int_feature" = my_int_feature,
          "my_int_feature2"=my_int_feature2)},
          by=Cut]

# Exercise 7 ----
# Merge iris and airquality, akin to the functionality of rbind
# Want to do it fast ant want to keep track of rows with their
# original dataset, and keep all the columns of both the data set
# in the merged data set as well.
iris <- as.data.table(iris)
airquality <- as.data.table(airquality)
str(iris)
str(airquality)
?rbindlist
my_list = list("iris" = iris, "airquality" = airquality)
rbindlist(my_list, fill = TRUE, idcol = "my_list")

# The next exercises are on rolling Join like features
# Exercise 8 ----
# Create a data.table:
set.seed(1024)
x <- data.frame(rep(letters[1:2],6), c(1,2,3,4,6,7), sample(100,6))
names(x) <- c("id","day","value")
test_dt <-setDT(x)
str(test_dt)
setkey(test_dt, id, day)
test_dt[.("a", 5L), roll = TRUE]

# Exercise 9 ----
# You want the nearest
test_dt[.("a", 5L), roll = "nearest"]

# Exercise 10 ----
# Use ans for q8 to find the value for day 5 and 9 for b.
# Now since 9 falls beyond last observation of 7 you might want
# to avoid copying it.
test_dt[.("b", c(5L, 9L)), roll = TRUE, rollends = FALSE]
# By using rollends = FALSE, prevents to get data past last point
