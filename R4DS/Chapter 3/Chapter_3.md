# Chapter 3
Miguel Arias  
9/1/2017  



# Data Visualisation

R has several systems for making graphs, but `ggplot2` is one of the most elegant and versatile. It implements the **grammar of graphics**, a coherent system for describing and building graphs.

In order to use `ggplot2`, we first need to load the `tidyverse` package.



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

## Creating a ggplot

To plot `mpg`:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
```

![](Chapter_3_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

## Graphing a template

Template for making graphs:

`ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))`
    
## Exercises

1. Run `ggplot(data = mpg)`. What do you see?


```r
ggplot(data = mpg)
```

![](Chapter_3_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/scatterplot-1.png)<!-- -->

5. What happens if you make a scatter plot of `class` vs `drv`? Why is the plot not useful?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
```

![](Chapter_3_files/figure-html/trash-1.png)<!-- -->

It makes a scatter plot, however there is not enough information for this to be useful. Only portrays if a vehicle is front-wheeler, rear-wheeler, or 4-wheeler.

## 3.3 Aesthetic mappings

You can add a third variable to a two dimensional scatterplot by mapping it to an **aesthetic**. An aesthetic is a visual property of the objects in your plot. This include: size, shape, or color of the points.

For example, can map the color of the points to the `class` variable to reveal the class of each car.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

![](Chapter_3_files/figure-html/classes-1.png)<!-- -->

Using size for a discrete variable is not advised.

Could use the *alpha* aesthetic or shape.

```r
# Left
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

![](Chapter_3_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/unnamed-chunk-3-2.png)<!-- -->

ggplot2 will only use 6 discrete variables at a time for shape.

### 3.3 Exercises

1. What's gone wrong with this code? Why are the points not blue?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```

![](Chapter_3_files/figure-html/exercise1-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/exercise3-1.png)<!-- -->

With categorical variables the aesthetic affects/changes points that are not together.

4. What happens if you map the same variable to multiple aesthetics?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = hwy, color = hwy))
```

![](Chapter_3_files/figure-html/exercise4-1.png)<!-- -->

By doing so, we get a a positively slope line with a 45 degree angle.

5. What deos the `stroke` aesthetic do? What shapes does it work with?

The `stroke` aesthetic increases the size of the border or stroke of the point.

6. What happens if you map an aesthetic to something other than a variable name, like `aes(color = displ < 5)`?


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
```

![](Chapter_3_files/figure-html/exercise6-1.png)<!-- -->

It makes a boolen (True/False). The colors are different for the set rule.

## 3.5 Facets

Split plot into **facets** (subplots that each display one subset of the data).

To facet your plot by a single variable, use `facet_wrap()`. The first argument of `facet_wrap()` should be a formula, which you create with `~` followed by a variable name.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

![](Chapter_3_files/figure-html/facets-1.png)<!-- -->

To facet your plot on the combination of two variables, add `facet_grid()`.


```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
```

![](Chapter_3_files/figure-html/facets2-1.png)<!-- -->

### 3.5 Exercises

1. What happens if you facet on a continuous variable?

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cty)
```

![](Chapter_3_files/figure-html/facetsex1-1.png)<!-- -->

The number of subplots/facets is too big.

2. What do the empty cells in plot with facet_grid (drv ~ cyl) mean? How do they relate to this plot?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
```

![](Chapter_3_files/figure-html/facetsex2-1.png)<!-- -->

The empty cells just mean that there are some type of vehicles that do not have that number of cylinders or vice versa.

3. What plots does the following code make? what does `.` do?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
```

![](Chapter_3_files/figure-html/facetsex3-1.png)<!-- -->

```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
```

![](Chapter_3_files/figure-html/facetsex3-2.png)<!-- -->

The code makes the a set of subplots with the type of vehicle as the subplot and the the number of cylinders too. For the first code it separates it in different rows, while the latter does it in different columns.

4. Take the first faceted plot in this section:


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
```

![](Chapter_3_files/figure-html/facetsex4-1.png)<!-- -->

By using faceting one can see in more detail the mileage per different vehicle. The disadvantage is that it is harder to compare. With a larger dataset the faceting might not be useful in some cases as the amount of points will be too much.

5. Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other options control the layout of individual panes? Why doesn't `facet_grid()` have `nrow` and `ncol` argument?


```r
?facet_wrap
```

`nrow` and `ncol` determine the number of rows and columns that we want the facets to be divided into. `facet_grid()` does not have these arguments because the number of rows and columns are determined by the categorical variables.

6. When using `facet_grid()` you should usually put the variable with more unique levels in the columns. Why?

It makes the data more understandable.

## 3.6 Geometric objects


```r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomobj-1.png)<!-- -->

Every geom function in ggplot2 takes a `mapping` argument. Can use `linetype`.


```r
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomobj2-1.png)<!-- -->

To display multiple geoms in the same plot, add multiple geom functions to `ggplot()`:


```r
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomobj3-1.png)<!-- -->

### 3.6 Exercises

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

![](Chapter_3_files/figure-html/geomex1-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/geomex5-1.png)<!-- -->

```r
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) 
```

![](Chapter_3_files/figure-html/geomex5-2.png)<!-- -->

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

![](Chapter_3_files/figure-html/geomex6-1.png)<!-- -->

```r
# 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = drv)) + 
  geom_point(show.legend = FALSE) + 
  geom_smooth(se = FALSE, show.legend = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomex6-2.png)<!-- -->

```r
# 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomex6-3.png)<!-- -->

```r
# 4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomex6-4.png)<!-- -->

```r
# 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)
```

```
## `geom_smooth()` using method = 'loess'
```

![](Chapter_3_files/figure-html/geomex6-5.png)<!-- -->

```r
# 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(size = 4, colour = "white") + 
  geom_point(aes(colour = drv))
```

![](Chapter_3_files/figure-html/geomex6-6.png)<!-- -->

## 3.7 Statistical transformations


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
```

![](Chapter_3_files/figure-html/stats-1.png)<!-- -->

Every geom has a default stat. There are three reasons why you might need to use a stat explicitly:

1. Might want to override the default stat.
2. Might want to override the default mapping from transformed variables to aesthetics.

```r
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```

![](Chapter_3_files/figure-html/stats2-1.png)<!-- -->
3. Might want to draw greater attention to the statistical transformation in the code.

### 3.7 Exercises

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

![](Chapter_3_files/figure-html/statsex1-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/statsex5-1.png)<!-- -->

```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
```

![](Chapter_3_files/figure-html/statsex5-2.png)<!-- -->

If we fail to set `group = 1`, the proportions for each cut are calculated using the complete dataset, rather thane ach subset of `cut`. Instead, we want the graphs to look like this:


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
```

![](Chapter_3_files/figure-html/statsex5.1-1.png)<!-- -->

## 3.8 Position Adjustments

There's one more piece of magic associated with bar charts. You can colour a bar chart using the `fill` aesthetic.

In `geom_bar()` the stacking is performed automatically by the **position adjustment** specified by the `position` argument. Can use three other options:

1. `position = "identity"` will place each object exactly where it falls in the context of the graph (not very useful for bars, because it overlaps them).

2. `position = "fill"` works like stacking, but makes each set of stacked bars the same height.

3. `position = "dodge"` places overlapping objects directly *beside* one another. Makes it clear to compare individual values.


```r
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
```

![](Chapter_3_files/figure-html/position1-1.png)<!-- -->

`position = "jitter"` is useful for scatter plots.


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
```

![](Chapter_3_files/figure-html/position2-1.png)<!-- -->

### 3.8 Exercises 

1. What is the problem with this plot? How could you improve it?


```r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
```

![](Chapter_3_files/figure-html/posiex1-1.png)<!-- -->

Many of the data points overlap. We can jitter the points by adding some slight random noise, which will improve the overall visualization.


```r
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
```

![](Chapter_3_files/figure-html/posisol1-1.png)<!-- -->

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

![](Chapter_3_files/figure-html/posiex4-1.png)<!-- -->

## 3.9 Coordinate systems

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

![](Chapter_3_files/figure-html/coord1-1.png)<!-- -->

```r
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()
```

![](Chapter_3_files/figure-html/coord1-2.png)<!-- -->

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

![](Chapter_3_files/figure-html/coord2-1.png)<!-- -->

```r
bar + coord_polar()
```

![](Chapter_3_files/figure-html/coord2-2.png)<!-- -->

### 3.9 Exercises

1. Turn a stacked bar chart into a pie chart using `coord_polar()`.


```r
ex1 <- ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar()

ex1 + coord_polar()
```

![](Chapter_3_files/figure-html/coordex1-1.png)<!-- -->

2. What does `labs()` do?

Ensure the axes and legend labesl display the full variable name. Adds labels to the graph. You can add a title, subtitle, and a label for the $x$ and $y$ axes, as well as a caption.

3. What's the difference between `coord_quickmap()` and `coord_map()`?

`coord_map` projects a portion of the earth, which is approximately spherical, onto a flat 2D plane. `coord_quickmap` is a quick approximation that does preserve straight lines. It works best for smaller areas closer to the equator.

4. What does the plot below tell you about the relationship between city and highway mpg? Why is `coord_fixed()` important What does `geom_abline() do?

* The relationship between city and highway mpg is a positive linear relationship. 
* Using `coord_fixed()` the plot draws equal intervals on the $x$ and $y$ axes so they are directly comparable. `geom_abline()` draws a line that, by default, has an intercept of 0 and slope of 1. This aids us in our discovery that automobile gas efficiency is on average slightly higher for highways than city driving. Though the slope of the relationship is still roughly 1-to-1.
