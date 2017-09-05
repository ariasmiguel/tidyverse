# Chapter 10
Miguel Arias  
9/5/2017  



# Tibbles


```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```

In order to coerce a data frame into a tibble. You can do that with `as_tibble()`:


```r
as_tibble(iris)
```

```
## # A tibble: 150 x 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl>  <fctr>
##  1          5.1         3.5          1.4         0.2  setosa
##  2          4.9         3.0          1.4         0.2  setosa
##  3          4.7         3.2          1.3         0.2  setosa
##  4          4.6         3.1          1.5         0.2  setosa
##  5          5.0         3.6          1.4         0.2  setosa
##  6          5.4         3.9          1.7         0.4  setosa
##  7          4.6         3.4          1.4         0.3  setosa
##  8          5.0         3.4          1.5         0.2  setosa
##  9          4.4         2.9          1.4         0.2  setosa
## 10          4.9         3.1          1.5         0.1  setosa
## # ... with 140 more rows
```

Can create a new tibble from individual vectors with `tibble()`.


```r
tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)
```

```
## # A tibble: 5 x 3
##       x     y     z
##   <int> <dbl> <dbl>
## 1     1     1     2
## 2     2     1     5
## 3     3     1    10
## 4     4     1    17
## 5     5     1    26
```

Another way to create a tibble is with `tribble()`.


```r
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
```

```
## # A tibble: 2 x 3
##       x     y     z
##   <chr> <dbl> <dbl>
## 1     a     2   3.6
## 2     b     1   8.5
```

The comment line `#--|--|----` is useful to make it really clear where the header is.

## 10.3 Tibbles vs. data frame

**Printing**

Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen. In addition to its name, each column reports its type, a nice feature borrowed from `str()`:


```r
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
```

```
## # A tibble: 1,000 x 5
##                      a          b     c          d     e
##                 <dttm>     <date> <int>      <dbl> <chr>
##  1 2017-09-05 17:31:55 2017-09-30     1 0.45852380     w
##  2 2017-09-05 17:59:58 2017-09-12     2 0.83509501     f
##  3 2017-09-06 08:25:13 2017-09-15     3 0.59748707     k
##  4 2017-09-06 03:56:03 2017-09-12     4 0.18331997     a
##  5 2017-09-06 00:32:30 2017-09-23     5 0.30841463     b
##  6 2017-09-06 11:39:41 2017-09-06     6 0.18402952     b
##  7 2017-09-06 10:35:26 2017-09-27     7 0.37666282     y
##  8 2017-09-06 06:17:31 2017-09-14     8 0.49977366     j
##  9 2017-09-05 23:55:10 2017-09-26     9 0.08783385     x
## 10 2017-09-06 10:44:20 2017-09-09    10 0.55199030     o
## # ... with 990 more rows
```

You can explictly `print()` the data frame and control the number of rows(`n`) and the `width` of the display. `width = Inf` displays all columns:


```r
nycflights13::flights %>%
  print(n = 10, width = Inf)
```

### 10.3.2 Subsetting

If you want to pull out a single variable, you need some new tools, `$` and `[[`. `[[` can extract by name or position; `$` only extracts by name but is a little less typing.


```r
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x
```

```
## [1] 0.07203957 0.68558132 0.59528891 0.59949238 0.08380062
```

```r
df[["x"]]
```

```
## [1] 0.07203957 0.68558132 0.59528891 0.59949238 0.08380062
```

```r
# Extract by position
df[[1]]
```

```
## [1] 0.07203957 0.68558132 0.59528891 0.59949238 0.08380062
```

Can be used in a pipe. Only need to use the special placeholder `.`:

```r
df %>% .$x
```

```
## [1] 0.07203957 0.68558132 0.59528891 0.59949238 0.08380062
```

```r
df %>% .[["x"]]
```

```
## [1] 0.07203957 0.68558132 0.59528891 0.59949238 0.08380062
```

Some older functions don't work with tibbles. Need to use `as.data.frame()`


```r
#class(as.data.frame(tb))
```

## 10.5 Exercises

1. How can you tell if an object is a tibble?

A data frame will print the entire contents. A tibble will only print (by default) the first 10 rows and as many columns as will fit in the console.

2. Compare and contrast the following operations on a `data.frame` and equivalent tibble. What is different? Why might the default data frame behaviours cause you frustration?


```r
# on a data frame
df <- data.frame(abc = 1, xyz = "a")
df$x
```

```
## [1] a
## Levels: a
```

```r
df[, "xyz"]
```

```
## [1] a
## Levels: a
```

```r
df[, c("abc", "xyz")]
```

```
##   abc xyz
## 1   1   a
```

```r
# on a tibble
df <- tibble(abc = 1, xyz = "a")
df$x
```

```
## Warning: Unknown or uninitialised column: 'x'.
```

```
## NULL
```

```r
df[, "xyz"]
```

```
## # A tibble: 1 x 1
##     xyz
##   <chr>
## 1     a
```

```r
df[, c("abc", "xyz")]
```

```
## # A tibble: 1 x 2
##     abc   xyz
##   <dbl> <chr>
## 1     1     a
```

* Tibbles never do partial matching; data frames do.
* Subsetting tibbles using `[[` will always return a tibble; subsetting data frames using `[[` can potentially return a vector.

3. If you have the name of a variable stored in an object, e.g. `var <- "mpg"`, how can you extract the reference variable from a tibble?


```r
var <- "hwy"
mpg[[var]]
```

```
##   [1] 29 29 31 30 26 26 27 26 25 28 27 25 25 25 25 24 25 23 20 15 20 17 17
##  [24] 26 23 26 25 24 19 14 15 17 27 30 26 29 26 24 24 22 22 24 24 17 22 21
##  [47] 23 23 19 18 17 17 19 19 12 17 15 17 17 12 17 16 18 15 16 12 17 17 16
##  [70] 12 15 16 17 15 17 17 18 17 19 17 19 19 17 17 17 16 16 17 15 17 26 25
##  [93] 26 24 21 22 23 22 20 33 32 32 29 32 34 36 36 29 26 27 30 31 26 26 28
## [116] 26 29 28 27 24 24 24 22 19 20 17 12 19 18 14 15 18 18 15 17 16 18 17
## [139] 19 19 17 29 27 31 32 27 26 26 25 25 17 17 20 18 26 26 27 28 25 25 24
## [162] 27 25 26 23 26 26 26 26 25 27 25 27 20 20 19 17 20 17 29 27 31 31 26
## [185] 26 28 27 29 31 31 26 26 27 30 33 35 37 35 15 18 20 20 22 17 19 18 20
## [208] 29 26 29 29 24 44 29 26 29 29 29 29 23 24 44 41 29 26 28 29 29 29 28
## [231] 29 26 26 26
```

4. Practice referring to non-systematic names in the following data frame by:


```r
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# 1  Extracting the variable called `1`.
annoying %>% .$`1`
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
# 2 Plotting a scatterplot of `1` vs `2`.
ggplot(annoying, aes(`1`, `2`)) +
  geom_point()
```

![](Chapter_10_files/figure-html/tibbleex4-1.png)<!-- -->

```r
# 3 Creating a new column called `3` which is `2` divided by `1`
(annoying <- mutate(annoying, `3` = `2` / `1`))
```

```
## # A tibble: 10 x 3
##      `1`       `2`      `3`
##    <int>     <dbl>    <dbl>
##  1     1  2.076249 2.076249
##  2     2  2.701803 1.350902
##  3     3  4.545976 1.515325
##  4     4  6.901713 1.725428
##  5     5  9.238609 1.847722
##  6     6 13.418289 2.236381
##  7     7 16.042394 2.291771
##  8     8 15.274740 1.909343
##  9     9 16.353772 1.817086
## 10    10 19.644289 1.964429
```

```r
# 4 Renaming the columns to `one`, `two` and `three`
rename(annoying,
       one = `1`,
       two = `2`,
       three = `3`)
```

```
## # A tibble: 10 x 3
##      one       two    three
##    <int>     <dbl>    <dbl>
##  1     1  2.076249 2.076249
##  2     2  2.701803 1.350902
##  3     3  4.545976 1.515325
##  4     4  6.901713 1.725428
##  5     5  9.238609 1.847722
##  6     6 13.418289 2.236381
##  7     7 16.042394 2.291771
##  8     8 15.274740 1.909343
##  9     9 16.353772 1.817086
## 10    10 19.644289 1.964429
```

5. What does `tibble::enframe()` do? When might you use it?

`enframe()` is a helper function that converts named atomic vectors or lists to two-column data frames. You might use it if you have data stored in a named vector and you want to add it to a data frame and preserve both the name attribute and the actual value.

6. What option control how many additional column names are printed at the footer of a tibble?

`getOption("tibble.max_extra_cols")`
