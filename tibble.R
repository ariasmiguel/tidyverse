# Library ------------------------------------------------------------
library(tidyverse)
library(coda)

# tibble() -----------------------------------------------------------
quantiles <- quantile(mtcars$hp, probs = c(.1, .25, .5, .75, .9))
quantiles

# enframe(): can convert simple named vectors into tibbles
quantiles %>%
  enframe("quantile", "value")

# rowid_to_column() ------------------------------------------------
# automates assigning an ID-number to each sample (i.e., primary key)
data(line, package = "coda")
line1 <- as.matrix(line$line1) %>% 
  as_tibble()
line1
line1 %>% rowid_to_column("draw")

# By doing this we can reshape the data into a long format or draw
# some samples for use in a plot, all while preserving the draw
# number

# rownames_to_column -----------------------------------
library(seplyr)
groupingVars = c("cyl", "gear")

datasets::mtcars %>%
  tibble::rownames_to_column('CarName') %>%
  select_se(c('CarName', 'cyl', 'gear', 'hp', 'wt')) %>%
  add_group_indices(groupingVars = groupingVars,
                    indexColumn = 'groupID') %>%
  add_group_sub_indices(groupingVars = groupingVars,
                        arrangeTerms = c('desc(hp)', 'wt'),
                        orderColumn = 'orderInGroup') %>%
  arrange_se(c('groupID', 'orderInGroup'))
