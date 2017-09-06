# Chapter 19
Miguel Arias  
9/5/2017  



## Functions

You should write a funciton whenever you've copied and pasted a block of code more than twice.


```r
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
```

To write a function you need to first analyze the code.

```r
(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
```

```
##  [1] 1.0000000 0.6753981 0.2571463 0.4827391 0.6108663 0.7518868 0.0000000
##  [8] 0.3164585 0.4250835 0.7047674
```

There are three key steps to creating a new function:
1. Need to pick a **name** for the function. 
2. List the inputs, or **arguments**, to the function inside `function(x)`. If more arguments, `function(x, y, z, etc)`.
3. Place the code you have developed in **body** of the function, a `{` block that immidiately follows `function(...)`.


```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

Functions have multiple advantages:
1. Eliminate repetition and copy-paste errors.
2. Makes code easier to understand
3. If need to make changes, only need to make them to the function.

#### 19.2.1 Practice

1. Why is `TRUE` not a paramenter to `rescale01()`? What would happen if `x` contained a single missing value, and `na.rm` was `FALSE`?
`TRUE` is not a parameter because it is implicit within the function. Also, if `na.rm` was `FALSE`, the function would return `NA`. 

2. In the second variant of `rescale01()`, infinite values are left unchanged. Rewrite `rescale01()1 so that `-Inf` is mapped to 0, and `Inf` is mapped to 1.


```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
  y[y == -Inf] <- 0
  y[y == Inf] <- 1
}
```

3. Practice turning the following code snippets into functions. Think about what each function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?


```r
# 1
prop_na <- function(x){
  mean(is.na(x))
}

# 2
weights <- function(x){
  x / sum(x, na.rm = TRUE)
}

# 3
coef_variation <- function(x){
  sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
}
```

4. Write your own function to compute the variance and skew of a numeric vector.


```r
variance <- function(x){
  # remove missing values
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  sq_err <- (x - m) ^ 2
  ans <- sum(sq_err)/(n-1)
  ans
}

skewness <- function(x){
  # remove missing values
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  m3 <- sum((x - m) ^ 3) / n
  s3 <- sqrt(sum((x - m) ^ 2) / (n - 1)) ^ 3
  ans <- m3 / s3
}
```

5. Write `both_na()`, a function that takes two vectors of the same length and returns the number of positions that have an `NA` in both vectors.


```r
both_na <- function(x, y) {
  sum(is.na(x) & is.na(y))
}
```

### 19.4 Conditional execution

An `if` statement allows you to conditionally execute code.


```r
# if (condition) {
# code executed when condition is TRUE
# } else {
# code executed when condition is FALSE
# }
```

Here is a simple function that returns a logical vector describing whether or not each element of a vector is named.


```r
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
```

The `condition` must evaluate to either `TRUE` or `FALSE`.

Can use `||` (or) and `&&` (and) to combine multiple logical expressions. As soon as `||` sees the first `TRUE` it returns `TRUE` without computing anything else. As soon as `&&` sees the first `FALSE` it returns `FALSE`. 

Be careful when testing equality. `==` is vectorised, which means that it's easy to get more than one output. Either check the length is already 1, collapse with `all()` or `any()`, or use the non-vectorised `identical()`. `identical()` is very strict: it always returns either a single `TRUE` or a single `FALSE`, and doesnt coerce types.

It's better to use `dplyr::near()` for comparisons.

`x == NA` doesn't do anything useful.

The `switch()` function allows you to evaluate selected code based on position or name. `cut()` is also useful to eliminate long chains of `if` statements.

#### 19.4.4 Exercises

1. What's the difference between `if` and `ifelse()`? 

The keyword `if` tests a single condition, while `ifelse` tests each element.

2. Write a greeting function that says "good morning", "good afternoon", or "good evening", depending on the time of day. (Hint: use a time argument that defaults to `lubridate::now()`. It will make it easier to test your function.)


```r
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following object is masked from 'package:base':
## 
##     date
```

```r
greet <- function(time = lubridate::now()){
  hr <- hour(time)
  # Not sure of what to do about times after midnight,
  # is it evening or morning
  if (hr < 12) {
  print("good morning")
  } else if (hr < 17){
  print("good afternoon")
  } else {
  print("good evening")
  }
}
greet()
```

```
## [1] "good morning"
```

3. Implement a `fizzbuzz` function. It takes a single number as input. If the number is divisible by three, it returns "fizz". If it's divisible by five it returns "buzz". If it's divisible by three and five, it returns "fizzbuzz". Otherwise, it returns the number. Make sure you first write working code before you create the function.


```r
fizzbuzz <- function(x){
  stopifnot(length(x) == 1)
  stopifnot(is.numeric(x))
  # More eficient by minimizing the number of tests
  if (!(x %% 3) & !(x %% 5)) {
    print("fizzbuzz")
  } else if (!(x %% 3)) {
    print("fizz")
  } else if (!(x %% 5)) {
    print("buzz")
  } else {
    print(x)
  }
}
fizzbuzz(6)
```

```
## [1] "fizz"
```

```r
fizzbuzz(15)
```

```
## [1] "fizzbuzz"
```

```r
fizzbuzz(14)
```

```
## [1] 14
```

```r
fizzbuzz(20)
```

```
## [1] "buzz"
```

4. How could you use `cut()` to simplify this set of nested if-else statements?


```r
temp = 0
if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}
```

```
## [1] "freezing"
```

How would you change the call to `cut()` if I’d used `<` instead of `<=`? What is the other chief advantage of cut() for this problem? (Hint: what happens if you have many values in temp?)


```r
temp <- seq(-10, 50, by = 5)
cut(temp, c(-Inf, 0, 10, 20, 30, Inf), right = TRUE,
    lables = c("freezing", "cold", "cool", "warm", "hot"))
```

```
##  [1] (-Inf,0]  (-Inf,0]  (-Inf,0]  (0,10]    (0,10]    (10,20]   (10,20]  
##  [8] (20,30]   (20,30]   (30, Inf] (30, Inf] (30, Inf] (30, Inf]
## Levels: (-Inf,0] (0,10] (10,20] (20,30] (30, Inf]
```

To have intervals open on the left (using `<`), I change the argument to `right = FALSE`.


```r
temp <- seq(-10, 50, by = 5)
cut(temp, c(-Inf, 0, 10, 20, 30, Inf), right = FALSE,
    lables = c("freezing", "cold", "cool", "warm", "hot"))
```

```
##  [1] [-Inf,0)  [-Inf,0)  [0,10)    [0,10)    [10,20)   [10,20)   [20,30)  
##  [8] [20,30)   [30, Inf) [30, Inf) [30, Inf) [30, Inf) [30, Inf)
## Levels: [-Inf,0) [0,10) [10,20) [20,30) [30, Inf)
```

`cut` works on vectors, wherease `if` only works on a single value, and that to change comparisons I only needed to change the argument to `right`, but I would have had to change four operators in the `if` expression.

### 19.5 Function arguments

The arguments to a function typically fall into two broad sets: one set supplies the **data** to compute on, and the other supplies arguments that control the **details** of the computation. For example:

* In `log()`, the data is `x`, and the detail is the `base` of the logarithm
* In `mean()`, the data is `x`, and the details are hor much data to trim from the ends (`trim`) and how to handle missing values (`na.rm`).
* In `t.test()`, the data are `x` and `y`, and the details of the test are `alternative`, `mu`, `paired`, `var.equal`, and `conf.level`.
* In `str_c()` you can supply any number of strings to `...`, and the details of the concatenation are controlled by `sep` and `collapse`.


```r
# Compute confidence interval around mean using normal approximation
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
```

```
## [1] 0.4394764 0.5522688
```

```r
mean_ci(x, conf = 0.99)
```

```
## [1] 0.4217554 0.5699898
```

#### 19.5.1 Choosing names

* `x`, `y`, `z`: vectors
* `w`: a vector of weights
* `df`: a data frame
* `i`, `j`: numeric indices (typically rows and columns).
* `n`: length, or number of rows
* `p`: number of columns

#### 19.5.2 Checking values

Important to have preconditions, and throw and error (with `stop()`), if they are not true. Also, its good to use the built-in `stopifnot()`: it checks that each argument is `TRUE`, and produces a generic error message if not.


```r
wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(w * x) / sum(w)
}
```

#### 19.5.3 Dot-dot-dot (...)

The special argument `...` (pronounced dot-dot-dot) captures any number of arguments that aren't otherwise matched. 

It's useful because you can then send those `...` on to another function. For example:


```r
commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])
```

```
## [1] "a, b, c, d, e, f, g, h, i, j"
```

```r
rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")
```

```
## Important output ------------------------------------------------------
```

However, this makes it easy for typos to go unnoticed. If you just want to capture the values of the `...`, use `list(...)`.

#### 19.5.5 Exercises

1. What does `commas(letters, collapse = "-")` do? Why?
It throws an error, because the argument `collapse` is passed to `str_c` as part of `...`, so it tries to run `str_c(letters, collapse = "-", collapse = ", ")`.

2. It'd be nice if you could supply multiple characters to the `pad` argument, e.g. `rule("Title", `pad = "-+")`. Why doesn't this currently work? How could you fix it?

It does not work because it duplicates pad by the width minus the length of the string. Can adjust this in the code:


```r
rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  padchar <- nchar(pad)
  cat(title, " ",
      stringr::str_dup(pad, width %/% padchar),
      # if not multiple, fill in the remaining characters
      stringr::str_sub(pad, 1, width %% padchar),
      "\n", sep = "")
}

rule("Important output")
```

```
## Important output ------------------------------------------------------
```

```r
rule("Important output", pad = "-+")
```

```
## Important output -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

```r
rule("Important output", pad = "-+-")
```

```
## Important output -+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-
```

3. What does the `trim` argument to `mean()` do? When might you use it?

It trims a fraction of observations from each end of the vector (meaning the range) before calculating the mean. This is useful for calculatin a measure of central tendancy that is robust to outliers.

4. The default value for the `method` argument to `cor()` is `c("pearson", "kendall", "spearman")`. What does that mean? What value is used by default?

It means that the `method` argument can take one of those three values. The first value, `"pearson"`, is used by default.

