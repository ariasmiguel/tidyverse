# Chapter 18
Miguel Arias  
9/5/2017  



## Pipes



Pipes are meant to help you write code in a way that is easier to read and understand. In other words, it facilitates reading the code. 

For example:

```r
# foo_foo %>%
#   hop(through = forest) %>%
#   scoop(up = field_mouse) %>%
#   bop(on = head)
```

**Do not use the pipe:**
1. With functions that use the current environment (`assign()`, `get()`, `load()`).
2. Functions that use lazy evaluation. In R, function arguments are only computed when the function uses them, not prior to calling the function. The pipe computes each element in turn, so you can't rely on this behaviour.

A place that is a problem is `tryCatch()`.

```r
# tryCatch(stop("!"), error = function(e) "An error")

# stop("!") %>% 
#   tryCatch(error = function(e) "An error")
```

Other functions that work similarly: `try()`, `suppressMessages()`, and `suppressWarnings()` in base R.

### Types of pipe

* `%T>%`: returns the left-hand side instead of the right-hand side.
* `%$%`: It "explodes" out the variables in a data frame so that you can refer to them explicitly. 
* `%<>%`: assignment operator that allows to replace code like:

```r
mtcars <- mtcars %>%
  transform(cyl = cyl * 2)

# With
mtcars %<>% transform(cyl = cyl * 2)
```
