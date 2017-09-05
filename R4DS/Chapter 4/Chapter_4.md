# Chapter 4
Miguel Arias  
9/5/2017  



# Workflow 



## 4.1 Coding basics

You can create new objects with `<-`:

```r
x <- 3 * 4
```

All R statements where you create objects, **assignemnet** statements, have the same form:

`object_name <- value`

## 4.2 What's in a name?

Recommend using **snake_case** where you separete lowercase words with `_`.

This is how object/function names should look: `i_use_snake_case`

## 4.3 Calling functions

R has a large collection of built-in functions that are called like this:
`function_name(arg1 = val1, arg2 = val2, ...)`

To create and call out an object:

```r
(y <- seq(1,10, length.out = 5))
```

```
## [1]  1.00  3.25  5.50  7.75 10.00
```

## 4.4 Practice

1. Why does this code not work?


```r
my_variable <- 10
#my_varıable
```

It does not work because `my_variable` is misspelled the second time.

2. Tweak each of the following R commands so that they run correctly:


```r
library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](Chapter_4_files/figure-html/codprac2-1.png)<!-- -->

```r
filter(mpg, cyl == 8)
```

```
## # A tibble: 70 x 11
##    manufacturer              model displ  year   cyl      trans   drv
##           <chr>              <chr> <dbl> <int> <int>      <chr> <chr>
##  1         audi         a6 quattro   4.2  2008     8   auto(s6)     4
##  2    chevrolet c1500 suburban 2wd   5.3  2008     8   auto(l4)     r
##  3    chevrolet c1500 suburban 2wd   5.3  2008     8   auto(l4)     r
##  4    chevrolet c1500 suburban 2wd   5.3  2008     8   auto(l4)     r
##  5    chevrolet c1500 suburban 2wd   5.7  1999     8   auto(l4)     r
##  6    chevrolet c1500 suburban 2wd   6.0  2008     8   auto(l4)     r
##  7    chevrolet           corvette   5.7  1999     8 manual(m6)     r
##  8    chevrolet           corvette   5.7  1999     8   auto(l4)     r
##  9    chevrolet           corvette   6.2  2008     8 manual(m6)     r
## 10    chevrolet           corvette   6.2  2008     8   auto(s6)     r
## # ... with 60 more rows, and 4 more variables: cty <int>, hwy <int>,
## #   fl <chr>, class <chr>
```

```r
filter(diamonds, carat > 3)
```

```
## # A tibble: 32 x 10
##    carat     cut color clarity depth table price     x     y     z
##    <dbl>   <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl> <dbl>
##  1  3.01 Premium     I      I1  62.7    58  8040  9.10  8.97  5.67
##  2  3.11    Fair     J      I1  65.9    57  9823  9.15  9.02  5.98
##  3  3.01 Premium     F      I1  62.2    56  9925  9.24  9.13  5.73
##  4  3.05 Premium     E      I1  60.9    58 10453  9.26  9.25  5.66
##  5  3.02    Fair     I      I1  65.2    56 10577  9.11  9.02  5.91
##  6  3.01    Fair     H      I1  56.1    62 10761  9.54  9.38  5.31
##  7  3.65    Fair     H      I1  67.1    53 11668  9.53  9.48  6.38
##  8  3.24 Premium     H      I1  62.1    58 12300  9.44  9.40  5.85
##  9  3.22   Ideal     I      I1  62.6    55 12545  9.49  9.42  5.92
## 10  3.50   Ideal     H      I1  62.8    57 12587  9.65  9.59  6.03
## # ... with 22 more rows
```
