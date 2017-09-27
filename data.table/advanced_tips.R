# Library ----------------------------------------------------------
library(data.table)

# Data: mtcars
# http://brooksandrew.github.io/simpleblog/articles/advanced-data-table/#using-shift-for-to-leadlag-vectors-and-lists
# Advanced tricks and trips (data.table) ---------------------------
# 1. Data Structures & Assignment ----------------------------------

# A. Columns of lists
# - Summary table (long and narrow)
dt <- data.table(mtcars)[, .(cyl, gear)]
dt[, unique(gear), by=cyl]

# - Summary table (short and narrow)
dt <- data.table(mtcars)[, .(gear, cyl)]
dt[, gearsL:=list(list(unique(gear))), by=cyl] # original, ugly
dt[, gearsL:=.(list(unique(gear))), by = cyl]  # improved, pretty
head(dt)

# A.1 Accessing elements from a column of lists
# Extract second element of each list in `gearL1` and create row
# `gearL1`.
dt[, gearL1:=lapply(gearsL, function(x) x[2])][]
dt[, gearS1:=sapply(gearsL, function(x) x[2])][]

head(dt)
str(head(dt[, gearL1]))
str(head(dt[, gearS1]))

# Better way of doing this:
dt[, gearL1:=lapply(gearsL, `[`, 2)][]
dt[, gearS1:=sapply(gearsL, `[`, 2)][]

# B. Suppressing intermediate output with {}
dt <- data.table(mtcars)

# Defaults to just returning the last object defined in the braces
# unnamed
dt[,{tmp1=mean(mpg); tmp2=mean(abs(mpg-tmp1)); 
     tmp3=round(tmp2, 2)}, by=cyl]
# More explicit by passing a named list of what we want to keep
dt[,{tmp1=mean(mpg); tmp2=mean(abs(mpg-tmp1));
      tmp3=round(tmp2, 2); 
      list(tmp2=tmp2, tmp3=tmp3)}, by=cyl]

# C. Fast looping with set
dt <- data.table(mtcars)[,1:5, with=F]
for (j in c(1L,2L,4L)) set(dt, j=j, value=-dt[[j]]) # integers using 'L' passed for efficiency
for (j in c(3L,5L)) set(dt, j=j, value=paste0(dt[[j]],'!!'))
head(dt)

# D. Using shift for to lead/lag vectors and lists
dt <- data.table(mtcars)[,.(mpg, cyl)]
dt[,mpg_lag1:=shift(mpg, 1)][]
dt[,mpg_forward1:=shift(mpg, 1, type='lead')][]
head(dt)

# E. Create multiple columns with `:=`
dt <- data.table(mtcars)[,.(mpg, cyl)]
dt[,`:=`(avg=mean(mpg), med=median(mpg), min=min(mpg)), by=cyl]
head(dt)

# 2. BY --------------------------------------------------------
# Used to calculate a function over a group (using by)

# A. Method 1: in-line
# Simple mean by cyl
dt <- data.table(mtcars)[,.(cyl, gear, mpg)]
dt[, mpg_biased_mean:=mean(mpg), by=cyl] 
head(dt)

# .GRP without setting key (unbiased mean)
dt[, dt[!gear %in% unique(dt$gear)[.GRP], 
        mean(mpg), by=cyl], by=gear] #unbiased mean

# Better way:
dt[, dt[!gear %in% .BY[[1]], 
        mean(mpg), by=cyl], by=gear] #unbiased mean

# Method 3
dt <- data.table(mtcars)[,.(mpg,cyl,gear)]
dt[,`:=`(avg_mpg_cyl=mean(mpg), Ncyl=.N), by=cyl]
dt[,`:=`(Ncylgear=.N, avg_mpg_cyl_gear=mean(mpg)), 
        by=.(cyl, gear)]
dt[,unbmean:=(avg_mpg_cyl*Ncyl-(Ncylgear*avg_mpg_cyl_gear))/(Ncyl-Ncylgear)]
setkey(dt, cyl, gear)  
head(dt)

# Wrapping into a function:
leaveOneOutMean <- function(dt, ind, bybig, bysmall) {
  dtmp <- copy(dt) # copy so as not to alter original dt object w intermediate assignments
  dtmp <- dtmp[is.na(get(ind))==F,]
  dtmp[,`:=`(avg_ind_big=mean(get(ind)), Nbig=.N),
            by=.(get(bybig))]
  dtmp[,`:=`(Nbigsmall=.N, avg_ind_big_small=mean(get(ind))),
            by=.(get(bybig), get(bysmall))]
  dtmp[,unbmean:=(avg_ind_big*Nbig-(Nbigsmall*avg_ind_big_small))/(Nbig-Nbigsmall)]
  return(dtmp[,unbmean])
}

# B. Using [1],[.N], setkey and by for within group subsetting
dt <- data.table(mtcars)[, .(cyl, mpg, qsec)]

# Max of qsec for each cat of cyl
dt[, max(qsec), by = cyl][]

# Value of qsec when mpg is the highest per category of cyl
dt[, qsec[.N], by = cyl][]

# Value of qsec when mpg is the lowest
dt[, qsec[1], by = cyl][]

# Value of qsec when mpg is the median per category of cyl
dt[, qsec[round(.N/2)], by = cyl]

# Subset rows within by statements
# V1 is the standard deviation of mpg by cyl. V2 is the std. dev.
# of mpg for just the first half of mpg
dt <- data.table(mtcars)
setkey(dt, mpg)
dt[, .(sd(mpg), sd(mpg[1:round(.N/2)])), by = cyl]


# 3. Functions -----------------------------------------------
# Passing data.table column names as function args

# Method 1:  No quotes, and deparse + subs
dt <- data.table(mtcars)[,.(cyl, mpg)]
myfunc <- function(dt, v) {
  v2=deparse(substitute(v))
  dt[,v2, with=F][[1]] # [[1]] returns a vector instead of a data.table
}

myfunc(dt, mpg)

# Method 2: quotes and get
dt <- data.table(mtcars)
myfunc <- function(dt, v) dt[,get(v)]

myfunc(dt, 'mpg')

# USEFUL INFO
dt <- data.table(mtcars)
add_column_dt <- function(dat) {
  datloc <- copy(dat)
  datloc[,addcol:='not sticking_to_dt!'] # hits dt in glob env
  return(datloc)
}
head(add_column_dt(dt)) # addcol here
head(dt) # addcol not here
