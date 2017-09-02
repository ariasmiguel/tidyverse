# R for Data Science
Miguel Arias  
9/1/2017  



# R For Data Science

## 3. Data Visualisation

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

Among the variables in `mpg` are:

1. `displ`, a car's engine size, in litres.
2. `hwy`, a car's fuel efficiency on the highway, in miles per gallon (mpg). A car with low fuel efficiency consumes more fuel than a car with high fuel efficiency when they travel the same distance.

#### Creating a ggplot

To plot `mpg`:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](RDataScience_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

#### Graphing a template

Template for making graphs:

`ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))`
    
#### Exercises

1. Run `ggplot(data = mpg)`. What do you see?


```r
ggplot(data = mpg)
```

![](RDataScience_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

There's an empty grey box.

2. How many rows are in `mpg`? How many columns?

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

### 3.3 Aesthetic mappings

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

![](RDataScience_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

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

![](RDataScience_files/figure-html/unnamed-chunk-3-2.png)<!-- -->

ggplot2 will only use 6 discrete variables at a time for shape.

#### Exercises

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

### 3.5 Facets

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

#### Exercises

1. What happens if you facet on a continuous variable?

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cty)
```

![](RDataScience_files/figure-html/facetsex1-1.png)<!-- -->

The number of subplots/facets is too big.

2. What do the empty cells in plot with facet_grid (drv ~ cyl) mean? How do they relate to this plot?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
```

![](RDataScience_files/figure-html/facetsex2-1.png)<!-- -->

The empty cells just mean that there are some type of vehicles that do not have that number of cylinders or vice versa.

3. What plots does the following code make? what does `.` do?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
```

![](RDataScience_files/figure-html/facetsex3-1.png)<!-- -->

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
```

![](RDataScience_files/figure-html/facetsex3-2.png)<!-- -->

The code makes the a set of subplots with the type of vehicle as the subplot and the the number of cylinders too. For the first code it separates it in different rows, while the latter does it in different columns.

4. Take the first faceted plot in this section:


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

![](RDataScience_files/figure-html/facetsex4-1.png)<!-- -->

By using faceting one can see in more detail the mileage per different vehicle. The disadvantage is that it is harder to compare. With a larger dataset the faceting might not be useful in some cases as the amount of points will be too much.

5. Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other options control the layout of individual panes? Why doesn't `facet_grid()` have `nrow` and `ncol` argument?


```r
?facet_wrap
```

`nrow` and `ncol` determine the number of rows and columns that we want the facets to be divided into. `facet_grid()` does not have these arguments because the number of rows and columns are determined by the categorical variables.

6. When using `facet_grid()` you should usually put the variable with more unique levels in the columns. Why?

It makes the data more understandable.

### 3.6 Geometric objects


```r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomobj-1.png)<!-- -->

Every geom function in ggplot2 takes a `mapping` argument. Can use `linetype`.


```r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomobj2-1.png)<!-- -->

To display multiple geoms in the same plot, add multiple geom functions to `ggplot()`:


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomobj3-1.png)<!-- -->

#### Exercises

1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?

* line chart: geom_line()
* boxplot: geom_boxplot()
* histogram: geom_histogram()
* area chart: geom_area()

2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex1-1.png)<!-- -->

3. What does `show.legend = FALSE` do? What happens if you remove it? Why do you think I used it earlier in the chapter?

`show.legend = FALSE` prevents the legend to be shown in the graph. If you remove it the legend is shown. 

4. What does the `se` argument to `geom_smooth()` do?

It asks if you want to display the confidence interval around the line/smooth (TRUE by default).

5. Will these two graphs look different? Why/why not?


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex5-1.png)<!-- -->

```r
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) 
```

![](RDataScience_files/figure-html/geomex5-2.png)<!-- -->

These two graphs will look the same as they are graphing the exact same thing. The only difference is that the code is repeated inside `geom_point()` and `geom_smooth()`.

6. Recreate the R code necessary to generate the following graphs.


```r
# 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex6-1.png)<!-- -->

```r
# 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = drv)) + 
  geom_point(show.legend = FALSE) + 
  geom_smooth(se = FALSE, show.legend = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex6-2.png)<!-- -->

```r
# 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex6-3.png)<!-- -->

```r
# 4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex6-4.png)<!-- -->

```r
# 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](RDataScience_files/figure-html/geomex6-5.png)<!-- -->

```r
# 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(size = 4, colour = "white") + 
  geom_point(aes(colour = drv))
```

![](RDataScience_files/figure-html/geomex6-6.png)<!-- -->

### 3.7 Statistical transformations


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
```

![](RDataScience_files/figure-html/stats-1.png)<!-- -->

Every geom has a default stat. There are three reasons why you might need to use a stat explicitly:

1. Might want to override the default stat.
2. Might want to override the default mapping from transformed variables to aesthetics.

```r
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```

![](RDataScience_files/figure-html/stats2-1.png)<!-- -->
3. Might want to draw greater attention to the statistical transformation in the code.

#### Exercises

1. What is the default geom associated with `stat_summary()`? How could you rewrite the previous plot to use that geom function instead of the stat function?

The default geom is `geom_pointrange()`.

```r
ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth),
                  stat = "summary",
                  fun.ymin = min,
                  fun.ymax = max,
                  fun.y = median)
```

![](RDataScience_files/figure-html/statsex1-1.png)<!-- -->

2. What does `geom_col()` do? How is it different to `geom_bar()`?

`geom_bar()` makes the height of the bar proportional to the number of cases in each group (or if the weight aesthetic is supplied, the sum of the weights). If you want the heights of the bars to represent values in the data, use `geom_col` instead.

3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?

4. What variables does `stat_smooth()` compute? What parameters control its behaviour?

`stat_smooth()` calculates:

  1. `y`: predicted value
  2. `ymin`: lower pointwise confidence interval around the mean
  3. `ymax`: upper pointwise confidence interval around the mean
  4. `se`: standard error

5. In our proportion bar chart, we need to set `group = 1`. Why? In other words what is the problem with these two graphs?


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
```

![](RDataScience_files/figure-html/statsex5-1.png)<!-- -->

```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
```

![](RDataScience_files/figure-html/statsex5-2.png)<!-- -->

If we fail to set `group = 1`, the proportions for each cut are calculated using the complete dataset, rather thane ach subset of `cut`. Instead, we want the graphs to look like this:


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```

![](RDataScience_files/figure-html/statsex5.1-1.png)<!-- -->

### 3.8 Position Adjustments

There's one more piece of magic associated with bar charts. You can colour a bar chart using the `fill` aesthetic.

In `geom_bar()` the stacking is performed automatically by the **position adjustment** specified by the `position` argument. Can use three other options:

1. `position = "identity"` will place each object exactly where it falls in the context of the graph (not very useful for bars, because it overlaps them).

2. `position = "fill"` works like stacking, but makes each set of stacked bars the same height.

3. `position = "dodge"` places overlapping objects directly *beside* one another. Makes it clear to compare individual values.


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
```

![](RDataScience_files/figure-html/position1-1.png)<!-- -->

`position = "jitter"` is useful for scatter plots.


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
```

![](RDataScience_files/figure-html/position2-1.png)<!-- -->

#### Exercises 

1. What is the problem with this plot? How could you improve it?


```r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
```

![](RDataScience_files/figure-html/posiex1-1.png)<!-- -->

Many of the data points overlap. We can jitter the points by adding some slight random noise, which will improve the overall visualization.


```r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
```

![](RDataScience_files/figure-html/posisol1-1.png)<!-- -->

2. What parameters to `geom_jitter()` control the amount of jittering?

`width` and `height`

3. Compare and contrast `geom_jitter()` with `geom_count()`.

`geom_count()` depicts the number of observations in an specific point, while `geom_jitter()` adds random noise.

4. What's the default position adjustment for `geom_boxplot()`? Create a visualisation of the `mpg` dataset that demonstrates it.

`position = "dodge"` is the default position for `geom_boxplot()`. 


```r
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy, color = drv))
```

![](RDataScience_files/figure-html/posiex4-1.png)<!-- -->

### 3.9 Coordinate systems

* `coord_flip()` switches the $x$ and $y$ axes. Useful if you want horizontal boxplots and for long labels.

* `coord_quickmap()` sets the aspect ratio correctly for maps. Very important if you're plotting spatial data with ggplot2.


```r
nz <- map_data("nz")
```

```
## 
## Attaching package: 'maps'
```

```
## The following object is masked from 'package:purrr':
## 
##     map
```

```r
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")
```

![](RDataScience_files/figure-html/coord1-1.png)<!-- -->

```r
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()
```

![](RDataScience_files/figure-html/coord1-2.png)<!-- -->

* `coord_polar()` uses polar coordinates. They reveal an interesting connection between a bar chart and a Coxcomb chart.


```r
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
```

![](RDataScience_files/figure-html/coord2-1.png)<!-- -->

```r
bar + coord_polar()
```

![](RDataScience_files/figure-html/coord2-2.png)<!-- -->

#### Exercises

1. Turn a stacked bar chart into a pie chart using `coord_polar()`.


```r
ex1 <- ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar()

ex1 + coord_polar()
```

![](RDataScience_files/figure-html/coordex1-1.png)<!-- -->

2. What does `labs()` do?

Ensure the axes and legend labesl display the full variable name. Adds labels to the graph. You can add a title, subtitle, and a label for the $x$ and $y$ axes, as well as a caption.

3. What's the difference between `coord_quickmap()` and `coord_map()`?

`coord_map` projects a portion of the earth, which is approximately spherical, onto a flat 2D plane. `coord_quickmap` is a quick approximation that does preserve straight lines. It works best for smaller areas closer to the equator.

4. What does the plot below tell you about the relationship between city and highway mpg? Why is `coord_fixed()` important What does `geom_abline() do?

* The relationship between city and highway mpg is a positive linear relationship. 
* Using `coord_fixed()` the plot draws equal intervals on the $x$ and $y$ axes so they are directly comparable. `geom_abline()` draws a line that, by default, has an intercept of 0 and slope of 1. This aids us in our discovery that automobile gas efficiency is on average slightly higher for highways than city driving. Though the slope of the relationship is still roughly 1-to-1.

## 4. Workflow 

### 4.1 Coding basics

You can create new objects with `<-`:

```r
x <- 3 * 4
```

All R statements where you create objects, **assignemnet** statements, have the same form:

`object_name <- value`

### 4.2 What's in a name?

Recommend using **snake_case** where you separete lowercase words with `_`.

This is how object/function names should look: `i_use_snake_case`

### 4.3 Calling functions

R has a large collection of built-in functions that are called like this:
`function_name(arg1 = val1, arg2 = val2, ...)`

To create and call out an object:

```r
(y <- seq(1,10, length.out = 5))
```

```
## [1]  1.00  3.25  5.50  7.75 10.00
```

### 4.4 Practice

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

![](RDataScience_files/figure-html/codprac2-1.png)<!-- -->

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

## 5. Data Transformation


```r
library(nycflights13)
library(tidyverse)
```

**Tibbles*: data frames, but slightly tweaked to work better in the tidyverse.

* `int`: integers
* `dbl`: doubles, or real numbers
* `chr`: character vectors, or strings
* `dttm`: date-times (a date + a time)
* `lgl`: logical, `TRUE` or `FALSE`
* `fctr`: factors, R uses it to represent categorical variables with fixed possible values
* `date`: dates

### 5.1 Dplyr basics

* `filter()`: pick observations by their values
* `arrange()`: reorder the rows
* `select()`: pick variables by their names
* `mutate()`: create new variables with functions of existing variables
* `summarise()`: collapse many values down to a single summary.

### 5.2 Filter rows with filter

Filter `flights` for the flights that happened on January 1st.


```r
jan1 <- filter(flights, month == 1, day == 1)
```

Flights on December 25 (Christmas)

```r
(dec25 <- filter(flights, month == 12, day == 25))
```

```
## # A tibble: 719 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013    12    25      456            500        -4      649
##  2  2013    12    25      524            515         9      805
##  3  2013    12    25      542            540         2      832
##  4  2013    12    25      546            550        -4     1022
##  5  2013    12    25      556            600        -4      730
##  6  2013    12    25      557            600        -3      743
##  7  2013    12    25      557            600        -3      818
##  8  2013    12    25      559            600        -1      855
##  9  2013    12    25      559            600        -1      849
## 10  2013    12    25      600            600         0      850
## # ... with 709 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

#### 5.2.2 Logical operators

`&` is "and", `|` is "or", and `!` is "not".

The following code finds all the flights that departed in November or December:

```r
filter(flights, month == 11 | month == 12)
```

```
## # A tibble: 55,403 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013    11     1        5           2359         6      352
##  2  2013    11     1       35           2250       105      123
##  3  2013    11     1      455            500        -5      641
##  4  2013    11     1      539            545        -6      856
##  5  2013    11     1      542            545        -3      831
##  6  2013    11     1      549            600       -11      912
##  7  2013    11     1      550            600       -10      705
##  8  2013    11     1      554            600        -6      659
##  9  2013    11     1      554            600        -6      826
## 10  2013    11     1      554            600        -6      749
## # ... with 55,393 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

```r
nov_dec <- filter(flights, month %in% c(11,12))
```

Can simplify complicated subsetting by remembering De Morgan's law: `!(x &  y)` is the same as `!x | !y`, and `!(x | y)` is the same as `!x & !y`.

Find flights that weren't delayed (on arrival or departure) by more than two hours, you could use either of the following two filters:


```filter
filter(flights, !(arr_delay > 120 | dep_delay > 120))

filter(flights, arr_delay <= 120, dep_delay <= 120)
```

If you want to determine if a value is missing, use `is.na()`:


```r
x <- NA
is.na(x)
```

```
## [1] TRUE
```

#### 5.2.4 Exercises

1. Find all flights that

  * Had an arrival delay of two or more hours
  

```r
library(nycflights13)
filter(flights, arr_delay >= 120)
```

```
## # A tibble: 10,200 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      811            630       101     1047
##  2  2013     1     1      848           1835       853     1001
##  3  2013     1     1      957            733       144     1056
##  4  2013     1     1     1114            900       134     1447
##  5  2013     1     1     1505           1310       115     1638
##  6  2013     1     1     1525           1340       105     1831
##  7  2013     1     1     1549           1445        64     1912
##  8  2013     1     1     1558           1359       119     1718
##  9  2013     1     1     1732           1630        62     2028
## 10  2013     1     1     1803           1620       103     2008
## # ... with 10,190 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```
  
  * Flew to Houston (`IAH` or `HOU`)

```r
filter(flights, dest %in% c('IAH','HOU'))
```

```
## # A tibble: 9,313 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      517            515         2      830
##  2  2013     1     1      533            529         4      850
##  3  2013     1     1      623            627        -4      933
##  4  2013     1     1      728            732        -4     1041
##  5  2013     1     1      739            739         0     1104
##  6  2013     1     1      908            908         0     1228
##  7  2013     1     1     1028           1026         2     1350
##  8  2013     1     1     1044           1045        -1     1352
##  9  2013     1     1     1114            900       134     1447
## 10  2013     1     1     1205           1200         5     1503
## # ... with 9,303 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

```r
filter(flights, dest == "IAH" | dest == "HOU")
```

```
## # A tibble: 9,313 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      517            515         2      830
##  2  2013     1     1      533            529         4      850
##  3  2013     1     1      623            627        -4      933
##  4  2013     1     1      728            732        -4     1041
##  5  2013     1     1      739            739         0     1104
##  6  2013     1     1      908            908         0     1228
##  7  2013     1     1     1028           1026         2     1350
##  8  2013     1     1     1044           1045        -1     1352
##  9  2013     1     1     1114            900       134     1447
## 10  2013     1     1     1205           1200         5     1503
## # ... with 9,303 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

  * Were operated by United, American, or Delta

```r
filter(flights, carrier %in% c("UA","AA","DL"))
```

```
## # A tibble: 139,504 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      517            515         2      830
##  2  2013     1     1      533            529         4      850
##  3  2013     1     1      542            540         2      923
##  4  2013     1     1      554            600        -6      812
##  5  2013     1     1      554            558        -4      740
##  6  2013     1     1      558            600        -2      753
##  7  2013     1     1      558            600        -2      924
##  8  2013     1     1      558            600        -2      923
##  9  2013     1     1      559            600        -1      941
## 10  2013     1     1      559            600        -1      854
## # ... with 139,494 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

  * Departed in summer (July, August, and September)

```r
filter(flights, month %in% c(6,7,8))
```

```
## # A tibble: 86,995 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     6     1        2           2359         3      341
##  2  2013     6     1      451            500        -9      624
##  3  2013     6     1      506            515        -9      715
##  4  2013     6     1      534            545       -11      800
##  5  2013     6     1      538            545        -7      925
##  6  2013     6     1      539            540        -1      832
##  7  2013     6     1      546            600       -14      850
##  8  2013     6     1      551            600        -9      828
##  9  2013     6     1      552            600        -8      647
## 10  2013     6     1      553            600        -7      700
## # ... with 86,985 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

  * Arrived more than two hours late, but didn't leave late

```r
filter(flights, arr_delay >= 120 & dep_delay <= 0)
```

```
## # A tibble: 29 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1    27     1419           1420        -1     1754
##  2  2013    10     7     1350           1350         0     1736
##  3  2013    10     7     1357           1359        -2     1858
##  4  2013    10    16      657            700        -3     1258
##  5  2013    11     1      658            700        -2     1329
##  6  2013     3    18     1844           1847        -3       39
##  7  2013     4    17     1635           1640        -5     2049
##  8  2013     4    18      558            600        -2     1149
##  9  2013     4    18      655            700        -5     1213
## 10  2013     5    22     1827           1830        -3     2217
## # ... with 19 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

  * Were delayed by at least an hour, but made up over 30 minutes in flight

```r
filter(flights, dep_delay >=60 & (dep_delay - arr_delay) <=60)
```

```
## # A tibble: 26,772 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      811            630       101     1047
##  2  2013     1     1      826            715        71     1136
##  3  2013     1     1      848           1835       853     1001
##  4  2013     1     1      957            733       144     1056
##  5  2013     1     1     1114            900       134     1447
##  6  2013     1     1     1120            944        96     1331
##  7  2013     1     1     1301           1150        71     1518
##  8  2013     1     1     1337           1220        77     1649
##  9  2013     1     1     1400           1250        70     1645
## 10  2013     1     1     1505           1310       115     1638
## # ... with 26,762 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

  * Departed between midnight and 6am (inclusive)

```r
filter(flights, dep_time >= 0, dep_time <= 600)
```

```
## # A tibble: 9,344 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1      517            515         2      830
##  2  2013     1     1      533            529         4      850
##  3  2013     1     1      542            540         2      923
##  4  2013     1     1      544            545        -1     1004
##  5  2013     1     1      554            600        -6      812
##  6  2013     1     1      554            558        -4      740
##  7  2013     1     1      555            600        -5      913
##  8  2013     1     1      557            600        -3      709
##  9  2013     1     1      557            600        -3      838
## 10  2013     1     1      558            600        -2      753
## # ... with 9,334 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

2. Another useful dplyr filtering helper is `between()`. What does it do? Can you use it to simplify the code needed to answer the previous challenges?

It's a shorcut for `x >= left & x <= right`. It can be used to answer the previous questions in a simpler manner.

For example:


```r
filter(flights, month >= 7, month <= 9)
```

```
## # A tibble: 86,326 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     7     1        1           2029       212      236
##  2  2013     7     1        2           2359         3      344
##  3  2013     7     1       29           2245       104      151
##  4  2013     7     1       43           2130       193      322
##  5  2013     7     1       44           2150       174      300
##  6  2013     7     1       46           2051       235      304
##  7  2013     7     1       48           2001       287      308
##  8  2013     7     1       58           2155       183      335
##  9  2013     7     1      100           2146       194      327
## 10  2013     7     1      100           2245       135      337
## # ... with 86,316 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

```r
filter(flights, between(month, 7, 9))
```

```
## # A tibble: 86,326 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     7     1        1           2029       212      236
##  2  2013     7     1        2           2359         3      344
##  3  2013     7     1       29           2245       104      151
##  4  2013     7     1       43           2130       193      322
##  5  2013     7     1       44           2150       174      300
##  6  2013     7     1       46           2051       235      304
##  7  2013     7     1       48           2001       287      308
##  8  2013     7     1       58           2155       183      335
##  9  2013     7     1      100           2146       194      327
## 10  2013     7     1      100           2245       135      337
## # ... with 86,316 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

3. How many flights have a missing `dep_time`? What other variables are missing? What might these rows represent?


```r
filter(flights, is.na(dep_time))
```

```
## # A tibble: 8,255 x 19
##     year month   day dep_time sched_dep_time dep_delay arr_time
##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
##  1  2013     1     1       NA           1630        NA       NA
##  2  2013     1     1       NA           1935        NA       NA
##  3  2013     1     1       NA           1500        NA       NA
##  4  2013     1     1       NA            600        NA       NA
##  5  2013     1     2       NA           1540        NA       NA
##  6  2013     1     2       NA           1620        NA       NA
##  7  2013     1     2       NA           1355        NA       NA
##  8  2013     1     2       NA           1420        NA       NA
##  9  2013     1     2       NA           1321        NA       NA
## 10  2013     1     2       NA           1545        NA       NA
## # ... with 8,245 more rows, and 12 more variables: sched_arr_time <int>,
## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
## #   minute <dbl>, time_hour <dttm>
```

There are 8,245 flights missing `dep_time`. There are also missing values for arrival time and departure/arrival delay. These flights were most likely cancelled.

4. Why is `NA ^ 0` not missing? Why is `NA | TRUE` not missing? Why is `FALSE & NA` not missing? Can you figure out the general rule? (`NA * 0` is a tricky counterexample)

`NA ^ 0`: by definition anything to the 0th power is 1.

`NA | TRUE`: as long as one condition is `TRUE`, the result is `TRUE`.

`FALSE & NA`: `NA` indicates the absence of a value, so the conditional expression ignores it.
