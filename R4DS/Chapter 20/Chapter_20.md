# Chapter 20
Miguel Arias  
9/6/2017  



## Vectors



There are two types of vectors:

1. **Atomic** vectors: **logical**, **integer**, **double**, **character**, **complex**, and **raw**. Integer and double vectors are collectively known as **numeric** vectors.

2. **Lists**: sometimes called recursive vectors because lists can contain other lists.

Every vector has two key properties:
1. **Type**: determined with `typeof()`:

```r
typeof(letters)
```

```
## [1] "character"
```

```r
typeof(1:10)
```

```
## [1] "integer"
```

2. **Length**: determined with `length()`:

```r
x <- list("a", "b", 1:10)
length(x)
```

```
## [1] 3
```

### 20.3 Types of atomic vector

1. Logical

Only three possible values: `FALSE`, `TRUE`, and `NA`. They are usually constructed with comparison operators. Also can create them by hand with `c()`:

```r
1:10 %% 3 == 0
```

```
##  [1] FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE
```

```r
c(TRUE, TRUE, FALSE, NA)
```

```
## [1]  TRUE  TRUE FALSE    NA
```

2. Numeric

3. Character

Each element of a character vector is a string and it can contain an arbitrary amount of data.

### Missing values

Each type of atomic vector has its own missing value:

```r
NA
```

```
## [1] NA
```

```r
NA_integer_
```

```
## [1] NA
```

```r
NA_real_
```

```
## [1] NA
```

```r
NA_character_
```

```
## [1] NA
```

#### 20.3.5 Exercises

1. Describe the difference between `is.finite(x)` and `!is.infinite(x)`.


```r
x <- c(0, NA, NaN, Inf, -Inf)
is.finite(x)
```

```
## [1]  TRUE FALSE FALSE FALSE FALSE
```

```r
!is.infinite(x)
```

```
## [1]  TRUE  TRUE  TRUE FALSE FALSE
```

`is.finite` considers that only a number is finite, while `!is.infinite` considers that any value except `Inf` and `-Inf` are finite.

2. How does `dplyr::near()` work?


```r
dplyr::near
```

```
## function (x, y, tol = .Machine$double.eps^0.5) 
## {
##     abs(x - y) < tol
## }
## <environment: namespace:dplyr>
```

It checks that the the two numbers are within a certain tolerance, `tol`.

5. What functions from the **readr** package allow you to turn a string into logical, integer, and double vector:

* `parse_logical`
* `parse_integer`
* `parse_number`

#### 20.4.2 Test functions

Use the `is_*` functions provided by purrr to check the type of vector:
* `is_logical`
* `is_integer`
* `is_double`
* `is_numeric`
* `is_character`
* `is_atomic`
* `is_list`
* `is_vector`

#### 20.4.3 Scalars and recycling rules

Vector recycling can be useful but will cause problems in tidyverse. The vectorised functions in tidyverse will throw errors when you recycle anything other than a scalar. If you do want to recycle, you need to go it yourself with `rep()`:


```r
tibble(x = 1:4, y = 1:2)
```

```
## Error: Column `y` must be length 1 or 4, not 2
```

```r
tibble(x = 1:4, y = rep(1:2, 2))
```

```
## # A tibble: 4 x 2
##       x     y
##   <int> <int>
## 1     1     1
## 2     2     2
## 3     3     1
## 4     4     2
```

```r
tibble(x = 1:4, y = rep(1:2, each = 2))
```

```
## # A tibble: 4 x 2
##       x     y
##   <int> <int>
## 1     1     1
## 2     2     1
## 3     3     2
## 4     4     2
```

#### 20.4.4 Naming vectors

All vectors can be named:

```r
c(x = 1, y = 2, z = 3)
```

```
## x y z 
## 1 2 3
```

```r
set_names(1:3, c("a", "b", "c"))
```

```
## a b c 
## 1 2 3
```

#### 20.4.5 Subsetting

`x[a]` is the subsetting function.

Four types of things you can subset a vector with

1. A numeric vector containing only integers. The integers must either be all positive, all negative, or zero.


```r
x <- c("one", "two", "three", "four", "five")

# Positive integers keep the elements at those positions
x[c(3, 2, 5)]
```

```
## [1] "three" "two"   "five"
```

```r
# Repeating a position, can actually make a longer output than input
x[c(1, 1, 5, 5, 5, 2)]
```

```
## [1] "one"  "one"  "five" "five" "five" "two"
```

```r
# Negative values drop the elements at the specified position
x[c(-1, -5, -3)]
```

```
## [1] "two"  "four"
```

```r
# Zero return no values
x[0]
```

```
## character(0)
```

2. A logical vector keeps all values corresponding to a `TRUE` value. Most useful in conjuction with the comparison functions.


```r
x <- c(10, 3, NA, 5, 8, 1, NA)

# All non-missing values of x
x[!is.na(x)]
```

```
## [1] 10  3  5  8  1
```

```r
# All even (or missing!) values of x
x[x %% 2 == 0]
```

```
## [1] 10 NA  8 NA
```

3. If you have a named vector, can subset with character vector


```r
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]
```

```
## xyz def 
##   5   2
```

4. `x[]` returns the complete `x`. Useful when subsetting matrices because it lets you select all the rows or all the columns, by leaving that index blank. For example, if `x` is 2d, `x[1, ]` selects the first row and all the columns, and `x[, -1]` selects all rows and all columns except the first.

#### 20.4.6 Exercises

1. Create functions that take a vector as input and returns:


```r
# The last value. Should you use [ or [[?
last_value <- function(x){
  # check for case with no length
  if (length(x)) {
    # Use [[ because it returns one element
    x[[length(x)]]
  } else {
    x
  }
}
last_value(1)
```

```
## [1] 1
```

```r
last_value(1:10)
```

```
## [1] 10
```

```r
# The elements at even numbered positions
even_indices <- function(x) {
  if (length(x) > 0) {
    x[seq_along(x) %% 2 == 0]
  } else {
    x
  }
}
even_indices(1)
```

```
## numeric(0)
```

```r
even_indices(1:10)
```

```
## [1]  2  4  6  8 10
```

```r
# test using case to ensure that values not indices
# are being returned
even_indices(letters)
```

```
##  [1] "b" "d" "f" "h" "j" "l" "n" "p" "r" "t" "v" "x" "z"
```

```r
# Every element except the last value
not_last <- function(x) {
  if (length(x) > 0) {
    x[-length(x)]
  } else {
    x
  }
}
not_last(1:10)
```

```
## [1] 1 2 3 4 5 6 7 8 9
```

```r
# Only even numbers (and no missing values).
even_numbers <- function(x) {
  x[!is.na(x) & (x %% 2 == 0)]
}
even_numbers(-10:10)
```

```
##  [1] -10  -8  -6  -4  -2   0   2   4   6   8  10
```

2. Why is `x[-which(x > 0)]` not the same as `x[x <= 0]`?


```r
x <- c(-5:5, Inf, -Inf, NaN, NA)
x[-which(x > 0)]
```

```
## [1]   -5   -4   -3   -2   -1    0 -Inf  NaN   NA
```

```r
-which(x > 0)
```

```
## [1]  -7  -8  -9 -10 -11 -12
```

```r
x[x <= 0]
```

```
## [1]   -5   -4   -3   -2   -1    0 -Inf   NA   NA
```

```r
x <= 0
```

```
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
## [12] FALSE  TRUE    NA    NA
```

They treat missing values differently.

### 20.5 Lists

Lists can contain other lists. Makes them suitable for representing hierachical or tree-like structures.


```r
x <- list(1, 2, 3)
x
```

```
## [[1]]
## [1] 1
## 
## [[2]]
## [1] 2
## 
## [[3]]
## [1] 3
```

`str()` is useful for working with lists as it focuses on the structure, not the contents.


```r
str(x)
```

```
## List of 3
##  $ : num 1
##  $ : num 2
##  $ : num 3
```

```r
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)
```

```
## List of 3
##  $ a: num 1
##  $ b: num 2
##  $ c: num 3
```

`list()` can contain a mix of objects:


```r
y <- list("a", 1L, 1.5, TRUE)
str(y)
```

```
## List of 4
##  $ : chr "a"
##  $ : int 1
##  $ : num 1.5
##  $ : logi TRUE
```

```r
# Can contain other lists
z <- list(list(1, 2), list(3, 4))
str(z)
```

```
## List of 2
##  $ :List of 2
##   ..$ : num 1
##   ..$ : num 2
##  $ :List of 2
##   ..$ : num 3
##   ..$ : num 4
```

#### 20.5.2 Subsetting

Three ways to subset a list, which I'll illustrate with a list named `a`:


```r
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
```

1. `[` extracts a sub-list. The result will always be a list.


```r
str(a[1:2])
```

```
## List of 2
##  $ a: int [1:3] 1 2 3
##  $ b: chr "a string"
```

```r
str(a[4])
```

```
## List of 1
##  $ d:List of 2
##   ..$ : num -1
##   ..$ : num -5
```

2. `[[` extracts a single component from a list. It removes a level of hierarchy from the list.


```r
str(a[[1]])
```

```
##  int [1:3] 1 2 3
```

```r
str(a[[4]])
```

```
## List of 2
##  $ : num -1
##  $ : num -5
```

3. `$` used for extracting named elements of a list. Works similarly to `[[` but you don't need to use quotes.


```r
a$a
```

```
## [1] 1 2 3
```

```r
a[["a"]]
```

```
## [1] 1 2 3
```

#### 20.5.4 Exercises

2. What happens if you subset a tibble as if you're subsetting a list? What are the key differences between a list and a tibble?

Subsetting works the same way for both; a data framce can be though of as a list of columns. The key difference is that a tibble has the restriction that all its elements (columns) must have the same length.


```r
x <- tibble(a = 1:2, b = 3:4)
x[["a"]]
```

```
## [1] 1 2
```

```r
x["a"]
```

```
## # A tibble: 2 x 1
##       a
##   <int>
## 1     1
## 2     2
```

```r
x[1]
```

```
## # A tibble: 2 x 1
##       a
##   <int>
## 1     1
## 2     2
```

```r
x[1, ]
```

```
## # A tibble: 1 x 2
##       a     b
##   <int> <int>
## 1     1     3
```

### 20.6 Attributes

Named list of vector that can be attached to any object. Can get and set individual attribute values with `attr()` or see them all at once with `attributes()`.

Three very important attributes:
1. **Names** are used to name the elements of a vector
2. **Dimensions** (dims, for short) make a vector behave like a matrix or array
3. **Class** is used to implement the S3 object oriented system.

### 20.7 Augmented vectors

#### Factors

Designed to represent categorical data that can take a fixed set of possible values. Built on top of integers, and have a levels attribute:


```r
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
```

```
## [1] "integer"
```

```r
attributes(x)
```

```
## $levels
## [1] "ab" "cd" "ef"
## 
## $class
## [1] "factor"
```

#### Dates and date-times

Numeric vectors that represent the number of days since 1 January 1970.


```r
x <- as.Date("1971-01-01")
unclass(x)
```

```
## [1] 365
```

```r
typeof(x)
```

```
## [1] "double"
```

```r
attributes(x)
```

```
## $class
## [1] "Date"
```

```r
x <- lubridate::ymd_hm("1970-01-01 01:00")
typeof(x)
```

```
## [1] "double"
```

```r
attributes(x)
```

```
## $tzone
## [1] "UTC"
## 
## $class
## [1] "POSIXct" "POSIXt"
```

```r
# The tzone attribute is option. 
# Controls how time is printed
attr(x, "tzone") <- "US/Pacific"
x
```

```
## [1] "1969-12-31 17:00:00 PST"
```

```r
attr(x, "tzone") <- "US/Eastern"
x
```

```
## [1] "1969-12-31 20:00:00 EST"
```

#### Tibbles

Augmented lists: have the class `tbl_df` + `tbl` + `data.frame`, and `names` (column) and `row.names` attributes:


```r
tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb)
```

```
## [1] "list"
```

```r
attributes(tb)
```

```
## $names
## [1] "x" "y"
## 
## $class
## [1] "tbl_df"     "tbl"        "data.frame"
## 
## $row.names
## [1] 1 2 3 4 5
```

```r
# Traditional data.frames have a similiar structure
df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
```

```
## [1] "list"
```

```r
attributes(df)
```

```
## $names
## [1] "x" "y"
## 
## $row.names
## [1] 1 2 3 4 5
## 
## $class
## [1] "data.frame"
```

#### Exercises

1. What does `hms::hms(3000)` return? How does it print? What primitive type is the augmented vector build on top of? What attributes does it use?


```r
x <- hms::hms(3600)
x
```

```
## 01:00:00
```

```r
class(x)
```

```
## [1] "hms"      "difftime"
```

```r
typeof(x)
```

```
## [1] "double"
```

```r
attributes(x)
```

```
## $units
## [1] "secs"
## 
## $class
## [1] "hms"      "difftime"
```

2. Try and make a tibble that has columns with different lengths. What happens?


```r
tibble(x = 1, y = 1:5)
```

```
## # A tibble: 5 x 2
##       x     y
##   <dbl> <int>
## 1     1     1
## 2     1     2
## 3     1     3
## 4     1     4
## 5     1     5
```

```r
# No problems with a scalar
# However will cause error with another vector
```


3. Is it ok to have a list as a column of a tibble?


```r
tibble(x = 1:3, y = list("a", 1, list(1:3)))
```

```
## # A tibble: 3 x 2
##       x          y
##   <int>     <list>
## 1     1  <chr [1]>
## 2     2  <dbl [1]>
## 3     3 <list [1]>
```

It is.
