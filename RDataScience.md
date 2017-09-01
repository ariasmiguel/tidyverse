# R for Data Science
Miguel Arias  
9/1/2017  



# R For Data Science

## Data Visualisation

R has several systems for making graphs, but `ggplot2` is one of the most elegant and versatile. It implements the **grammar of graphics**, a coherent system for describing and building graphs.

In order to use `ggplot2`, we first need to load the `tidyverse` package.


```r
library(tidyverse)
```

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

1. Do cars with big engines use more fuel than cars with small engines? Use the `mpg` **data frame** found in ggplot2.


```r
mpg
```

```
## # A tibble: 234 x 11
##    manufacturer      model displ  year   cyl      trans   drv   cty   hwy
##           <chr>      <chr> <dbl> <int> <int>      <chr> <chr> <int> <int>
##  1         audi         a4   1.8  1999     4   auto(l5)     f    18    29
##  2         audi         a4   1.8  1999     4 manual(m5)     f    21    29
##  3         audi         a4   2.0  2008     4 manual(m6)     f    20    31
##  4         audi         a4   2.0  2008     4   auto(av)     f    21    30
##  5         audi         a4   2.8  1999     6   auto(l5)     f    16    26
##  6         audi         a4   2.8  1999     6 manual(m5)     f    18    26
##  7         audi         a4   3.1  2008     6   auto(av)     f    18    27
##  8         audi a4 quattro   1.8  1999     4 manual(m5)     4    18    26
##  9         audi a4 quattro   1.8  1999     4   auto(l5)     4    16    25
## 10         audi a4 quattro   2.0  2008     4 manual(m6)     4    20    28
## # ... with 224 more rows, and 2 more variables: fl <chr>, class <chr>
```

```r
?mpg
```

Among the variables in `mpg` are:

1. `displ`, a car's engine size, in litres.
2. `hwy`, a car's fuel efficiency on the highway, in miles per gallon (mpg). A car with low fuel efficiency consumes more fuel than a car with high fuel efficiency when they travel the same distance.

### Creating a ggplot

To plot `mpg`:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](RDataScience_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

### Graphing a template

Template for making graphs:

`ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))`
    
### Exercises

1. Run `ggplot(data = mpg)`. What do you see?


```r
ggplot(data = mpg)
```

![](RDataScience_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

There's an empty grey box.

2. How many rows are in `mpg`? How many columns?


```r
mpg
```

```
## # A tibble: 234 x 11
##    manufacturer      model displ  year   cyl      trans   drv   cty   hwy
##           <chr>      <chr> <dbl> <int> <int>      <chr> <chr> <int> <int>
##  1         audi         a4   1.8  1999     4   auto(l5)     f    18    29
##  2         audi         a4   1.8  1999     4 manual(m5)     f    21    29
##  3         audi         a4   2.0  2008     4 manual(m6)     f    20    31
##  4         audi         a4   2.0  2008     4   auto(av)     f    21    30
##  5         audi         a4   2.8  1999     6   auto(l5)     f    16    26
##  6         audi         a4   2.8  1999     6 manual(m5)     f    18    26
##  7         audi         a4   3.1  2008     6   auto(av)     f    18    27
##  8         audi a4 quattro   1.8  1999     4 manual(m5)     4    18    26
##  9         audi a4 quattro   1.8  1999     4   auto(l5)     4    16    25
## 10         audi a4 quattro   2.0  2008     4 manual(m6)     4    20    28
## # ... with 224 more rows, and 2 more variables: fl <chr>, class <chr>
```

```r
?mpg
```

There's 234 rows and 11 variables (columns).

3. What does `drv` variable describe?

`drv`: f = front-wheel drive, r = rear wheel drive, 4 = 4wd.

4. Make a scatterplot of `hwy` vs `cyl`


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))
```

![](RDataScience_files/figure-html/scatterplot-1.png)<!-- -->

5. What happens if you make a scatter plot of `class` vs `drv`? Why is the plot not useful?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
```

![](RDataScience_files/figure-html/trash-1.png)<!-- -->

It makes a scatter plot, however there is not enough information for this to be useful. Only portrays if a vehicle is front-wheeler, rear-wheeler, or 4-wheeler.

## Aesthetic mappings

You can add a third variable to a two dimensional scatterplot by mapping it to an **aesthetic**. An aesthetic is a visual property of the objects in your plot. This include: size, shape, or color of the points.

For example, can map the color of the points to the `class` variable to reveal the class of each car.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

![](RDataScience_files/figure-html/classes-1.png)<!-- -->

Using size for a discrete variable is not advised.

Could use the *alpha* aesthetic or shape.

```r
# Left
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

![](RDataScience_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
# Right
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

```
## Warning: The shape palette can deal with a maximum of 6 discrete values
## because more than 6 becomes difficult to discriminate; you have 7.
## Consider specifying shapes manually if you must have them.
```

```
## Warning: Removed 62 rows containing missing values (geom_point).
```

![](RDataScience_files/figure-html/unnamed-chunk-5-2.png)<!-- -->

ggplot2 will only use 6 discrete variables at a time for shape.

### Exercises

1. What's gone wrong with this code? Why are the points not blue?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```

![](RDataScience_files/figure-html/exercise1-1.png)<!-- -->

The points are not blue because `blue` is not a variable within `mpg`. As such, it does not make sense to have it inside `aes()`. If we want the points to turn blue, we need to write `color = blue` outside `aes()`.

2. Which variables in `mpg` are categorical? Which variables are continuous? How can you see this information when you run `mpg`?

* Categorical: manufacturer, model, trans, drv, fl, class, cyl 
* Continuous: year, displ,cty, hwy

In order to see this information: `?mpg`, `str(mpg)`, or go through the entire data `mpg`.

3. Map a continuous variable to `color`, `size`, and `shape`. How do these aesthetics behave differently for categorical vs. continuous variables?

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = year))
```

![](RDataScience_files/figure-html/exercise3-1.png)<!-- -->

With categorical variables the aesthetic affects/changes points that are not together.

4. What happens if you map the same variable to multiple aesthetics?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = hwy, color = hwy))
```

![](RDataScience_files/figure-html/exercise4-1.png)<!-- -->

By doing so, we get a a positively slope line with a 45 degree angle.

5. What deos the `stroke` aesthetic do? What shapes does it work with?

The `stroke` aesthetic increases the size of the border or stroke of the point.

6. What happens if you map an aesthetic to something other than a variable name, like `aes(color = displ < 5)`?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
```

![](RDataScience_files/figure-html/exercise6-1.png)<!-- -->

It makes a boolen (True/False). The colors are different for the set rule.

## Facets

Split plot into **facets** (subplots that each display one subset of the data).

To facet your plot by a single variable, use `facet_wrap()`. The first argument of `facet_wrap()` should be a formula, which you create with `~` followed by a variable name.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

![](RDataScience_files/figure-html/facets-1.png)<!-- -->

To facet your plot on the combination of two variables, add `facet_grid()`.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
```

![](RDataScience_files/figure-html/facets2-1.png)<!-- -->

### Exercises

1. What happens if you facet on a continuous variable?

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cty)
```

![](RDataScience_files/figure-html/exercise311-1.png)<!-- -->

The number of subplots/facets is too big.

2. What do the empty cells in plot with facet_grid (drv ~ cyl) mean? How do they relate to this plot?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
```

![](RDataScience_files/figure-html/example2-1.png)<!-- -->

The empty cells just mean that there are some type of vehicles that do not have that number of cylinders or vice versa.

3. What plots does the following code make? what does `.` do?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
```

![](RDataScience_files/figure-html/example3-1.png)<!-- -->

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
```

![](RDataScience_files/figure-html/example3-2.png)<!-- -->

The code makes the a set of subplots with the type of vehicle as the subplot and the the number of cylinders too. For the first code it separates it in different rows, while the latter does it in different columns.

4. Take the first faceted plot in this section:


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

![](RDataScience_files/figure-html/example4-1.png)<!-- -->

By using faceting one can see in more detail the mileage per different vehicle. The disadvantage is that it is harder to compare. With a larger dataset the faceting might not be useful in some cases as the amount of points will be too much.

5. Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other options control the layout of individual panes? Why doesn't `facet_grid()` have `nrow` and `ncol` argument?


```r
?facet_wrap
```

`nrow` and `ncol` determine the number of rows and columns that we want the facets to be divided into. `facet_grid()` does not have these arguments because the number of rows and columns are determined by the categorical variables.

6. When using `facet_grid()` you should usually put the variable with more unique levels in the columns. Why?

It makes the data more understandable.


