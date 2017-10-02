# -----------------------------------------------------------------
set.seed(20170703L)
DF1 = data.frame(id = sample(1:2, 9L, TRUE), 
                 code = sample(letters[1:3], 9, TRUE), 
                 valA = 1:9, valB = 10:18, 
                 stringsAsFactors = FALSE)
DF2 = data.frame(id = c(3L, 1L, 1L, 2L, 3L), 
                 code = c("b", "a", "c", "c", "d"), 
                 mul = 5:1, stringsAsFactors = FALSE)

#create data tables
library(data.table)
DT1 <- as.data.table(DF1)
DT2 <- as.data.table(DF2)

# 1. Get all rows where valA > 5 and valB is <= 16 from DT1.
ans1 <- DT1[valA > 5 & valB <= 16]

# 2. Get all rows where valA is in between 5 and 8 (both included) from DT1.
ans2 <- DT1[valA %between% c(5,8)]

# 3. Order DT1 by code in increasing order, and within that by valA in decreasing order.
ans3 <- DT1[order(code, -valA)]

# 4. Return the last two rows of DT1.
ans4a <- DT1[(.N-1):.N]
ans4b <- tail(DT1, 2)

# 5. Return a random sample of 4 rows.
ans5<- DT1[sample(.N, 4L)]
ans5

# 6. Get median of valA and valB cols where code is not “a”. Name the columns ‘mA’ and ‘mB’.
ans6 <- DT1[code != "a", `:=`("mA" = median(valA),
                              "mB" = median(valB))][]
ans6

# 7. Remove all rows in DT2 where DT2$code is duplicated. Store the result in DT3. Hint: see ?duplicated.
DT3 <- DT2[duplicated(DT2[,code])]
DT3

# 8. Return all unique combinations of id, code (as a two column data.table) where valA^2 > valB. 
# Hint: you’ll need to use the function `unique()` in `j`.
ans8 <- DT1[valA^2 > valB, unique(as.data.table(list(id,code)))]
ans8

# 9. Read ?`.SD` and check explanation and examples and try to use `.SD` in `j` to solve (8). 
# Hint: you might also need `.SDcols` argument.
ans9 <- DT1[valA^2 > valB, unique(.SD), .SDcols = c("id", "code")]
ans9

# 10. For every DT3$code, return the last matching values of valA from DT1 along with ‘id’ column from DT3. i.e.,
# result should contain code, valA and id (from DT3) columns. Do not remove non-matching rows.
ans10 <- DT1[DT3, on = .(code), .(code, valA, i.id)][.N,]
ans10




