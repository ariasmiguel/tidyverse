### Library ----------------------------------------------------
library(data.table)

# MELT AND CAST -----------------------------------------------
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-reshape.html


# 1. Default functionality -------------------------------------

# A. `melt`ing data.tables (wide to long)
DT <- reshape2::smiths
DT
str(DT)

# - Convert DT to long form where weight and height are together
DT.m1 <- melt(DT, id.vars = c("subject","time"),
                 measure.vars = c("age","weight", "height"))
DT.m1
str(DT.m1)

# `measure.vars` specify the set of cols we want to combine

# - Name the variable and value cols to dim and measure
DT.m1 <- melt(DT, measure.vars = c("age","weight", "height"),
              variable.name = "dim", value.name = "measure")
DT.m1

# By default when one of `id.vars` or `measure.vars` is missing,
# the rest of the columns are automatically assigned to the 
# missing argument

# B. `Cast`ing data.tables (long to wide)

# - How can we get back to the original DT from DT.m1?
dcast(DT.m1, subject + time ~ dim, value.var = "measure")

# * dcast uses formula interface. The variables on the LHS of 
# formula represents the id vars and RHS the measure vars
# * value.var denotes the column to be filled in with while
# casting the wide formal.
# * dcast also tries to preserve attributes

# - Starting from `DT.m1`, how can we get the # of dims by
# person?
dcast(DT.m1, subject ~ ., fun.agg = function(x) sum(!is.na(x)),
      value.var ="measure")

# 2. Enhanced (new) functionality ------------------------------

# A. Enhanced `melt()`:

# - Can pass a list of columns to `measure.vars`, where each
# element of the list contains the columns that should be
# combined together

# colA = paste("dob_child", 1:3, sep = "")
# colB = paste("gender_child", 1:3, sep = "")
# DT.m2 = melt(DT, measure = list(colA, colB), 
# value.name = c("dob", "gender"))
# DT.m2

# - Using `patterns()`
# 
# DT.m2 = melt(DT, measure = patterns("^dob", "^gender"),
#              value.name = c("dob", "gender"))
# DT.m2

# B. Enhanced `dcast()`:

# - Casting multiple `value.var`s simultaneously

# Can provide multiple `value.var` columns to dcast for data.tables
# directly so that the operations are taken care of internally
# and efficiently

## new 'cast' functionality - multiple value.vars
# DT.c2 = dcast(DT.m2, family_id + age_mother ~ variable, value.var = c("dob", "gender"))
# DT.c2

# Attributes are preserved in result wherever possible.
