# Chapter 11
Miguel Arias  
9/5/2017  



# Data Import



Csv files are one of the most common forms of data storage, but once you understand `read_csv()`, you can easily apply your knowledge on all the other functions of readr (`read_csv2()`, `read_tsv()`, `read_delim()`, `read_fwf()`, `read_log()`).


```r
# heights <- read_csv("data/heights.csv")
read_csv("a,b,c
         1,2,3
         3,4,5")
```

```
## # A tibble: 2 x 3
##       a     b     c
##   <int> <int> <int>
## 1     1     2     3
## 2     3     4     5
```

`read_csv()` uses the first line of the data for column names (very common). However, there's sometimes a few lines of metadata at the top of the file.

1. Can skip this by using `skip = n` or `comment = "#"` to drop all lines that start with `#`.


```r
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)
```

```
## # A tibble: 1 x 3
##       x     y     z
##   <int> <int> <int>
## 1     1     2     3
```

```r
read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")
```

```
## # A tibble: 1 x 3
##       x     y     z
##   <int> <int> <int>
## 1     1     2     3
```

2. The data might not have column names. Use `col_names = FALSE`


```r
read_csv("1,2,3\n4,5,6", col_names = FALSE)
```

```
## # A tibble: 2 x 3
##      X1    X2    X3
##   <int> <int> <int>
## 1     1     2     3
## 2     4     5     6
```

`"\n"` is a convenient shortcut for adding a new line.

Also, can add column names with `col_names`. And `na` is used to specify the value (or values) that are used to represent missing values in the data.


```r
read_csv("a,b,c\n1,2,.", na = ".")
```

```
## # A tibble: 1 x 3
##       a     b     c
##   <int> <int> <chr>
## 1     1     2  <NA>
```

### 11.2.2 Exercises

1. What function would you use to read a file where fields were separated with "`|`"?

`read_delim(file, delim = "|")`

2. Apart from `file`, `skip`, and `comment`, what other arguments do `read_csv()` and `read_tsv()` have in commong?

* `col_names` and `col_types`
* `locale`
* `na` and `quoted_na`
* `trim_ws`
* `n_max` how many rows to read
* `guess_max` how many rows to use when guessing the column type
* `progress`

3. Most important arguments to `read_fwf()`?

`col_positions` which tells the function where data columns begin and end.

4. How can you read the following text into a data frame?

`"x,y\n1, 'a,b'"`


```r
x <- "x,y\n1,'a,b'"
read_delim(x, ",", quote = "'")
```

```
## # A tibble: 1 x 2
##       x     y
##   <int> <chr>
## 1     1   a,b
```

## 11.3 Parsing a vector

`parse_*()` functions take a character vector and return a more specialised vector like a logical, integer, or date:


```r
str(parse_logical(c("TRUE", "FALSE", "NA")))
```

```
##  logi [1:3] TRUE FALSE NA
```

```r
str(parse_integer(c("1","2","3")))
```

```
##  int [1:3] 1 2 3
```

```r
str(parse_date(c("2010-01-01", "1979-10-14")))
```

```
##  Date[1:2], format: "2010-01-01" "1979-10-14"
```

### 11.3.1 Numbers


```r
parse_double("1.23")
```

```
## [1] 1.23
```

```r
parse_double("1,23", locale = locale(decimal_mark = ","))
```

```
## [1] 1.23
```


```r
# Used in America
parse_number("$123,456,789")
```

```
## [1] 123456789
```

```r
# Used in many parts of Europe
parse_number("123.456.789", locale = locale(grouping_mark = "."))
```

```
## [1] 123456789
```

```r
# Used in Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))
```

```
## [1] 123456789
```

### 11.3.4 Dates, date-times, and times

* `parse_datetime()` expects an ISO8601 date-time.


```r
parse_datetime("2010-10-01T2010")
```

```
## [1] "2010-10-01 20:10:00 UTC"
```

```r
# If time is omitted, it will be set to midnight
parse_datetime("20101010")
```

```
## [1] "2010-10-10 UTC"
```

* `parse_date()` expects a four digit year, a `-` or `/`, the month, a `-` or `/`, the the day:


```r
parse_date("2010-10-01")
```

```
## [1] "2010-10-01"
```

* `parse_time()` expects the hour, :, minutes, optionally : and seconds, and an optional am/pm specifier:


```r
library(hms)
parse_time("01:10 am")
```

```
## 01:10:00
```

```r
parse_time("20:10:01")
```

```
## 20:10:01
```

### 11.3.5 Exercises

1. What are the most important arguments to `locale()`?

The locale controls:

* date and time formats: `date_names`, `date_format`, and `time_format`
* time_zone: `tz`
* numbers: `decimal_mark`, `grouping_mark`
* encoding: `encoding`

2. What happens if `decimal_mark` and `grouping_mark` are set to the same character?

If the `decimal_mark` is set to the comma `","`, then the `grouping_mark` must be set to the period `"."`

5. What's the difference between `read_csv()` and `read_csv2()`?

The delimeter since `read_csv2()` uses a semi-colon (`;`) instead of a comma (`,`).

7. Generate the correct format string to parse each of the following dates and times:


```r
# First
d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")
```

```
## [1] "2010-01-01"
```

```r
# Second
d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")
```

```
## [1] "2015-03-07"
```

```r
# Third
d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")
```

```
## [1] "2017-06-06"
```

```r
# Fourth
d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")
```

```
## [1] "2015-08-19" "2015-07-01"
```

```r
# Fifth
d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")
```

```
## [1] "2014-12-30"
```

```r
# Six
t1 <- "1705"
parse_time(t1, "%H%M")
```

```
## 17:05:00
```

```r
# Seven
t2 <- "11:15:10.12 PM"
parse_time(t2, "%I:%M:%OS %p")
```

```
## 23:15:10.12
```

## 11.5 Writing to a file

Can use `write_csv()` and `write_tsv()`. Although a little unreliable for catching interim results. Alternatives:

1. `write_rds()` and `read_rds()` are uniform wrappers around the base functions `readRDS()` and `saveRDS()`. These store data in R's custom binary format called RDS:

2. The feather package implements a fast binary file format that can be shared across programming languages:

`library(feather)`
`write_feather()`
`read_feather("challenge.feather")`

## 11.6 Other types of data

1. **haven** reads SPSS, Stata, and SAS files
2. **readxl** reads excel files (both `.xls` and `xlsx`).
3. **DBI**, along with a database specific backend (e.g. **RMySQL**, **RSQLite**, **RPostgreSQL** etc) allows you to run SQL queries against a database and return a data frame.

For hierarchical data: use **jsonlite** (by Jeroen Ooms) for json, and **xml2** for XML.
