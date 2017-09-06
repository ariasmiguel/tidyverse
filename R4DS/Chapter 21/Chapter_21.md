# Chapter 21
Miguel Arias  
9/6/2017  



## Iteration



### 21.2 For loops

We have this simple tibble:

```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# We want to compute the median of each col:
median(df$a)
```

```
## [1] -0.7191158
```

```r
median(df$b)
```

```
## [1] 0.2390874
```

```r
median(df$c)
```

```
## [1] 0.1554238
```

```r
median(df$d)
```

```
## [1] -0.3547319
```

Can use a loop:


```r
output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
```

```
## [1] -0.7191158  0.2390874  0.1554238 -0.3547319
```

Every loop has three components:
1. The **output**: `output <- vector("double", length(x))`. Need to allocate sufficient space for the output.

2. The **sequence**: `i in seq_along(df)`. This determines what to loop over: each run of the for loop will assign `i` to a different value from `seq_along(df)`. It's useful to think of `i` as a pronoun, like "it".

`seq_along()` is a safe version of `1:length(l)`.

3. The **body**: `output[[i]] <- median(df[[i]])`. The code that does the work. It's run repeatedly, each time with a different value for `i`. 

#### 21.2.1 Exercises

1. Write for loops to:


```r
# Compute the mean of every column in mtcars
output <- vector("double", ncol(mtcars))
names(output) <- names(mtcars)
for (i in names(mtcars)) {
  output[i] <- mean(mtcars[[i]])
}
output
```

```
##        mpg        cyl       disp         hp       drat         wt 
##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250 
##       qsec         vs         am       gear       carb 
##  17.848750   0.437500   0.406250   3.687500   2.812500
```

```r
# Determine the type of each column in nycflights13::flights
data("flights", package = "nycflights13")
output <- vector("list", ncol(flights))
names(output) <- names(flights)
for (i in names(flights)) {
  output[[i]] <- class(flights[[i]])
}
output
```

```
## $year
## [1] "integer"
## 
## $month
## [1] "integer"
## 
## $day
## [1] "integer"
## 
## $dep_time
## [1] "integer"
## 
## $sched_dep_time
## [1] "integer"
## 
## $dep_delay
## [1] "numeric"
## 
## $arr_time
## [1] "integer"
## 
## $sched_arr_time
## [1] "integer"
## 
## $arr_delay
## [1] "numeric"
## 
## $carrier
## [1] "character"
## 
## $flight
## [1] "integer"
## 
## $tailnum
## [1] "character"
## 
## $origin
## [1] "character"
## 
## $dest
## [1] "character"
## 
## $air_time
## [1] "numeric"
## 
## $distance
## [1] "numeric"
## 
## $hour
## [1] "numeric"
## 
## $minute
## [1] "numeric"
## 
## $time_hour
## [1] "POSIXct" "POSIXt"
```

```r
# Compute the number of unique values in each column of iris
data(iris)
iris_uniq <- vector("double", ncol(iris))
names(iris_uniq) <- names(iris)
for (i in names(iris)) {
  iris_uniq[i] <- length(unique(iris[[i]]))
}
iris_uniq
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##           35           23           43           22            3
```

```r
# Generate 10 random normals for each mu = -10, 0, 10, and 100

# number to draw
n <- 10
# values of the mean
mu <- c(-10, 0, 10, 100)
normals <- vector("list", length(mu))
for (i in seq_along(normals)) {
  normals[[i]] <- rnorm(n, mean = mu[i])
}
normals
```

```
## [[1]]
##  [1]  -9.605464  -7.342700 -10.199782 -10.995439  -9.788080  -9.978112
##  [7]  -9.560676 -10.213109 -10.730697  -9.719775
## 
## [[2]]
##  [1]  0.4173389  1.9787470  0.1924937  1.9401863  0.8202269  0.5108141
##  [7] -0.1110404 -1.7414134  0.2848528 -0.7737070
## 
## [[3]]
##  [1]  9.440468 10.612672 10.778746  9.298901 11.808137 10.787158  9.182927
##  [8] 11.546875 11.533502  9.132264
## 
## [[4]]
##  [1] 100.69711  99.28582  98.55819 100.14760  99.67093  99.17470  98.73434
##  [8]  99.55632  99.76084  99.82744
```

### 21.3 For loop variations

1. Modifying an existing object, instead of creating a new object.
2. Looping over names or values, instead of indices.
3. Handling outputs of unknown length.
4. Handling sequences of unknown length.

Better to use `[[` in for loops instead of `[`. As it makes it clear that I want to work with a single element.

#### 21.3.2 Looping partners

Three basic ways to loop over a vector.

1. Most general: `for (i in seq_along(xs))`, and extracting the value with `x[[i]]`.

2. Looping over the elements: `for (x in xs)`. Most useful if only care about plotting or saving a file. 

3. Looping over the names: `for (nm in names(xs))`. This gives you the name, which you can use to access the value with `x[[nm]]`. Useful if want to use the name in a plot title or a file name. 

If creating an output, make sure to name th results vector like:
`results <- vector("list", length(x))`
`names(results) <- names(x)`

#### 21.3.3 Unknown output length

Save results in a list, and then combine into a single vector.


```r
means <- c(0, 1, 2)

out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
```

```
## List of 3
##  $ : num [1:4] 0.1743 -0.3028 0.7062 0.0877
##  $ : num [1:72] -0.0428 1.6731 -0.7928 2.3331 -0.7446 ...
##  $ : num [1:78] 3.48 1.05 3.15 2.21 1.36 ...
```

```r
str(unlist(out))
```

```
##  num [1:154] 0.1743 -0.3028 0.7062 0.0877 -0.0428 ...
```

This occurs in other places:
* Might be generating a long string. Instead of `paste()`ing together each iteration with the previous, save the output in a character vector and then combine that vector in a single string with `paste(output, collaspe = "")`.
* Might be generating a big data frame. Instead of sequentially `rbind()`ing in each iteration, save the output in a list, then use `dplyr::bind_rows(output)` to combine the output into a single data frame.

#### 21.3.4 Unknown seq length

Use a while loop


```r
# while (condition) {
    #  body
# }

# How many tries it takes to get three heads in a row:
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips
```

```
## [1] 5
```

#### 21.3.5 Exercises

1. Imagine you have a directory full of CSV files that you want to read in. You have their paths in a vector, `files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)`, and now you want to read each one with `read_csv()`. Write the for loop that will load them into a single data frame.


```r
files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)

# pre-allocate a list
df <- vector("list", length(files))
# Create list of data frames
for (fname in seq_along(files)) {
  df[[i]] <- read_csv(files[[i]])
}
# Use bind_rows to create a single data frame
df <- bind_rows(df)
```

2. What happens if you use `for (nm in names(x))` and `x` has no names? What if only some of the elements are named?

If there are no names for the vector, it does not run the code in the loop. When it reaches an unnamed element it produces an error.

3. Write a function that prints the mean of each numeric column in a data frame, along with its name.


```r
library(stringr)
show_mean <- function(df, digits = 2) {
  # Get max length of any variable in the dataset
  maxstr <- max(str_length(names(df)))
  for (nm in names(df)) {
    if (is.numeric(df[[nm]])) {
      cat(str_c(str_pad(str_c(nm, ":"), maxstr + 1L, side = "right"),
                format(mean(df[[nm]]), digits = digits, nsmall = digits),
                sep = " "),
          "\n")
    }
  }
}
show_mean(iris)
```

```
## Sepal.Length: 5.84 
## Sepal.Width:  3.06 
## Petal.Length: 3.76 
## Petal.Width:  1.20
```

4. What does this code do? How does it work?


```r
trans <- list( 
  disp = function(x) x * 0.0163871,
  am = function(x) {
    factor(x, labels = c("auto", "manual"))
  }
)

for (var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}
```

This code mutates the `disp` and `am` columns:
* `disp` is multiplied by 0.0163871
* `am` is replaced by a factor variable

The code works by looping over a named list of functions. It calls the named function in the list on the column of `mtcars` with the same name, and replaces the values of that column.

### 21.4 For loops vs. functionals

Can create functions to run for loops and prevent repetition and a chance for bugs. Also, can generalise these functions in order to compute different arguments, like `col_mean()`, `col_median()` and `col_sd()`. 

For example:

```r
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}
col_summary(df, median)
```

```
## numeric(0)
```

```r
col_summary(df, mean)
```

```
## numeric(0)
```

#### 21.4.1 Exercises

1. Read the documentation for `apply()`. In the 2d case, what two for loops does it generalise.

Looping over the rows or columns of a matrix or data frame.

2. Adapt `col_summary()` so that it only applies to numeric columns. Might want to use `is_numeric()` function that returns a logical vector that has a `TRUE` corresponding to each column.


```r
col_summary2 <- function(df, fun) {
  # test whether each colum is numeric
  numeric_cols <- vector("logical", length(df))
  for (i in seq_along(df)) {
    numeric_cols[[i]] <- is.numeric(df[[i]])
  }
  # indexes of numeric columns
  idxs <- seq_along(df)[numeric_cols]
  # number of numeric columns
  n <- sum(numeric_cols)
  out <- vector("double", n)
  for (i in idxs) {
    out[i] <- fun(df[[i]])
  }
  out
}
```

### 21.5 The map functions

* `map()` makes a list
* `map_lgl()` makes a logical vector
* `map_int()` makes an integer vector
* `map_dbl()` makes a double vector
* `map_chr()` makes a character vector

Can use these functions to perform the same computations as the last for loop.

```r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

map_dbl(df, mean)
```

```
##           a           b           c           d 
## -0.24192577  0.01695518 -0.22516522  0.09768964
```

```r
map_dbl(df, median)
```

```
##           a           b           c           d 
## -0.18180774  0.08930706 -0.23677751 -0.01364196
```

```r
map_dbl(df, sd)
```

```
##         a         b         c         d 
## 0.8624747 0.8398956 0.7061386 0.8753552
```

#### 21.5.2 Base R

* `lapply()` is basically identical to `map()`, except that `map()` is consistent with all the other function in purrr, and you can use the shortcuts for `.f`.
* Base `sapply()` is a wrapper around `lapply()` that automatically simplifies the output. This is useful for interactive work but is problematic in a function because you never know what sort of output you'll get:


```r
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06), 
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)
x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78), 
  c(0.93, 0.21, 0.65, 0.13, 0.27), 
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
```

```
## List of 3
##  $ : num 0.91
##  $ : num [1:2] 0.9 0.94
##  $ : num(0)
```

```r
x2 %>% sapply(threshold) %>% str()
```

```
##  num [1:3] 0.99 0.93 0.87
```

* `vapply()` is a safe alternative to `sapply()`, but it's a lot of typing.

#### 21.5.3 Exercises

1. Write code that uses one of the map functions to:


```r
# Compute the mean of every column in `mtcars`
map_dbl(mtcars, mean)
```

```
## Warning in mean.default(.x[[i]], ...): argument is not numeric or logical:
## returning NA
```

```
##        mpg        cyl       disp         hp       drat         wt 
##  20.090625   6.187500   3.780862 146.687500   3.596563   3.217250 
##       qsec         vs         am       gear       carb 
##  17.848750   0.437500         NA   3.687500   2.812500
```

```r
# The type of every column in `nycflights13::flights`
map(nycflights13::flights, class)
```

```
## $year
## [1] "integer"
## 
## $month
## [1] "integer"
## 
## $day
## [1] "integer"
## 
## $dep_time
## [1] "integer"
## 
## $sched_dep_time
## [1] "integer"
## 
## $dep_delay
## [1] "numeric"
## 
## $arr_time
## [1] "integer"
## 
## $sched_arr_time
## [1] "integer"
## 
## $arr_delay
## [1] "numeric"
## 
## $carrier
## [1] "character"
## 
## $flight
## [1] "integer"
## 
## $tailnum
## [1] "character"
## 
## $origin
## [1] "character"
## 
## $dest
## [1] "character"
## 
## $air_time
## [1] "numeric"
## 
## $distance
## [1] "numeric"
## 
## $hour
## [1] "numeric"
## 
## $minute
## [1] "numeric"
## 
## $time_hour
## [1] "POSIXct" "POSIXt"
```

```r
map_chr(nycflights13::flights, typeof)
```

```
##           year          month            day       dep_time sched_dep_time 
##      "integer"      "integer"      "integer"      "integer"      "integer" 
##      dep_delay       arr_time sched_arr_time      arr_delay        carrier 
##       "double"      "integer"      "integer"       "double"    "character" 
##         flight        tailnum         origin           dest       air_time 
##      "integer"    "character"    "character"    "character"       "double" 
##       distance           hour         minute      time_hour 
##       "double"       "double"       "double"       "double"
```

```r
# The number of unique values in ea column of `iris`
map_int(iris, ~ length(unique(.)))
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##           35           23           43           22            3
```

```r
# Generates 10 random normals for each of mu = -10, 0, 10, and 100
map(c(-10, 0, 10, 100), rnorm, n = 10)
```

```
## [[1]]
##  [1]  -9.931754  -9.448713 -10.703413  -9.686408  -9.799388  -9.699849
##  [7]  -9.636950  -9.262491 -10.056987 -10.012085
## 
## [[2]]
##  [1] -0.8682593 -0.5296757 -0.1820634 -1.7691935 -0.2346555 -1.9048179
##  [7] -1.4168547 -0.5313830 -0.5063278  1.3640704
## 
## [[3]]
##  [1] 10.295940 10.624506 10.475384 11.365501 10.207922  8.878991 10.927116
##  [8]  9.742480 11.275939 10.812741
## 
## [[4]]
##  [1] 102.21365 100.03423 100.11633  99.09906 100.73281 100.27679  99.92444
##  [8]  99.98839 100.40006  98.49740
```

2. How can you create a single vector that for each column in a data frame indicates whether or not it's a factor?

Use `map_lgl` with the function `is.factor`.

```r
map_lgl(mtcars, is.factor)
```

```
##   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb 
## FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
```

3. What happens when you use the map functions on vectors that aren't lists? What does `map(1:5, runif)` do? Why?
The function `map` applies the function to each element of the vector.


```r
map(1:5, runif)
```

```
## [[1]]
## [1] 0.5157755
## 
## [[2]]
## [1] 0.8643425 0.4050812
## 
## [[3]]
## [1] 0.74705298 0.05752714 0.13990362
## 
## [[4]]
## [1] 0.3989926 0.2329285 0.9446861 0.4404906
## 
## [[5]]
## [1] 0.2978038 0.6458650 0.2877032 0.9718400 0.8472166
```

4. What does `map(-2:2, rnorm, n = 5)` do? Why? What does `map_dbl(-2:2, rnorm, n = 5)` do? Why?

This takes samples of `n = 5` fro normal distributions of means -2, -1, 0, 1, and 2, an returns a list with each element a numeric vector of length 5.


```r
map(-2:2, rnorm, n = 5)
```

```
## [[1]]
## [1] -1.023254 -2.494984 -1.126837 -1.246353 -1.573154
## 
## [[2]]
## [1] -0.5311772 -1.2751179 -1.6748669 -2.2338297  0.1998617
## 
## [[3]]
## [1] -0.9158055  0.6798526  0.4074109 -0.4726166 -0.4664562
## 
## [[4]]
## [1] 1.62838043 0.99446928 0.03752278 1.66980121 0.43627396
## 
## [[5]]
## [1] 2.068782 1.689759 3.012749 3.473135 3.809883
```

```r
# If we use map_dbl, it produces an error

# Can use flatten_dbl
flatten_dbl(map(-2:2, rnorm, n = 5))
```

```
##  [1] -2.6433133 -3.2675698 -1.4021071 -0.7347761 -0.3258893 -3.5622617
##  [7] -2.9892559 -1.7290485 -2.5169465 -3.0939607  1.1444382  1.9620368
## [13] -1.1611639  0.2949569 -0.1221236  0.5941101  0.5383897  1.4848111
## [19] -0.5318668  0.6272196  2.2597850  1.7153513  3.2328345  1.8555351
## [25]  2.6440123
```

5. Rewrite `map(x, function(df) lm(mpg ~ wt, data = df))` to eliminate the anonymous function.


```r
map(list(mtcars), ~ lm(mpg ~ wt, data = .))
```

```
## [[1]]
## 
## Call:
## lm(formula = mpg ~ wt, data = .)
## 
## Coefficients:
## (Intercept)           wt  
##      37.285       -5.344
```

### 21.6 Dealing with failure

Can use:
* `safely()`: takes a function (a verb) and returns a modified version.
* `possibly()`: always succeeds, just like `safely()`. Give it a default value to return when an error occurs.
* `quietly()`: same as `safely()` but instead of capturing errors, it captures printed output, messages, and warnings.

### 21.7 Mapping over multiple arguments

`map2()` iterates over two vectors in parallel:


```r
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)
map2(mu, sigma, rnorm, n = 5) %>% str()
```

```
## List of 3
##  $ : num [1:5] 5.42 3.46 4.82 5.37 3.73
##  $ : num [1:5] 14.52063 7.00871 8.85878 15.24644 0.00294
##  $ : num [1:5] -8.625 0.845 -6.902 -0.564 -11.611
```

Just like `map()` it is just a wrapper around a for loop:


```r
map2 <- function(x, y, f, ...) {
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], y[[i]], ...)
  }
  out
}
```

There's also `pmap()` which takes a list of arguments.

```r
n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>%
  pmap(rnorm) %>% 
  str()
```

```
## List of 3
##  $ : num 4.3
##  $ : num [1:3] 8.78 21.56 11.82
##  $ : num [1:5] -7.03 9.83 -6.26 3.86 -2.01
```

```r
# Since the args are the same lenght it makes sense 
# to store them in a data frame:

params <- tribble(
  ~mean, ~sd, ~n,
    5,     1,  1,
   10,     5,  3,
   -3,    10,  5
)

params %>% 
  pmap(rnorm)
```

```
## [[1]]
## [1] 3.469836
## 
## [[2]]
## [1]  9.240008  7.429937 18.215833
## 
## [[3]]
## [1]   5.368003 -16.481869 -33.734440  -4.726412 -27.065550
```


#### 21.7.1 Invoking different functions

By using `invoke_map()` we can apply different functions to different arguments simultaneously.

For example:

```r
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min = -1, max = 1), 
  list(sd = 5), 
  list(lambda = 10)
)

invoke_map(f, param, n = 5) %>% str()
```

```
## List of 3
##  $ : num [1:5] -0.00578 0.20862 0.0948 0.66856 -0.60443
##  $ : num [1:5] 1.38 6.11 -1.07 6.97 -6.28
##  $ : int [1:5] 8 6 10 5 12
```

The first argument is a list of functions or character vector of function names. The second argument is a list of lists giving the arguments that vary for each function. The subsequent arguments are passed on to every function.

Can use `tribble()` to make creating these matching pairs a little easier:


```r
sim <- tribble(
  ~f,      ~params,
  "runif", list(min = -1, max = 1),
  "rnorm", list(sd = 5),
  "rpois", list(lambda = 10)
)
sim %>% 
  mutate(sim = invoke_map(f, params, n = 10))
```

```
## # A tibble: 3 x 3
##       f     params        sim
##   <chr>     <list>     <list>
## 1 runif <list [2]> <dbl [10]>
## 2 rnorm <list [1]> <dbl [10]>
## 3 rpois <list [1]> <int [10]>
```

#### 21.9.1 Predictable functions

* `keep()`: keeps elements of the input where the predicate is `TRUE`.
* `discard()`: keeps elements of the input where the predicate is `FALSE`.
* `some()`: determines if the predicate is true for any of the elements
* `every()`: determines if the predicate is true for all of the elements.
* `detect()`: finds the first element where the predicate is true; `detect_index()` returns its position.
* `head_while()` and `tail_while()` takes elements from the start or end of a vector while a predicate is true.

#### 21.9.2 Reduce and accumulate

* `reduce()`: used to reduce lists/vectors/data frames into a single one. For example:


```r
# List
dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>% reduce(full_join)
```

```
## Joining, by = "name"
## Joining, by = "name"
```

```
## # A tibble: 2 x 4
##    name   age   sex treatment
##   <chr> <dbl> <chr>     <chr>
## 1  John    30     M      <NA>
## 2  Mary    NA     F         A
```

```r
# Vectors
vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)

vs %>% reduce(intersect)
```

```
## [1]  1  3 10
```

* `accumulate()`: similar to reduce but keeps all the interim results.

#### 21.9.3 Exercises

1. Implement your own version of `every()` using a for loop. Compare it with `purrr::every()`. 


```r
# Use ... to pass arguments to the function
every2 <- function(.x, .p, ...) {
  for (i in .x) {
    if (!.p(i, ...)) {
      # If any is FALSE we know not all of then were TRUE
      return(FALSE)
    }
  }
  # if nothing was FALSE, then it is TRUE
  TRUE  
}

every2(2:4, function(x) {x > 3})
```

```
## [1] FALSE
```

```r
every2(2:4, function(x) {x > 1})
```

```
## [1] TRUE
```

2. Create an enhanced `col_sum()` that applies a summary function to every numeric column in a data frame.


```r
col_sum2 <- function(df, f, ...) {
  map(keep(df, is.numeric), f, ...)
}

col_sum2(iris, mean)
```

```
## $Sepal.Length
## [1] 5.843333
## 
## $Sepal.Width
## [1] 3.057333
## 
## $Petal.Length
## [1] 3.758
## 
## $Petal.Width
## [1] 1.199333
```
