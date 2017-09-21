# Library ----------------------------------------------------------
library(data.table)

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


# 1a. Subset all rows where id column equals 1 & code column is not equal to "c"
ans1a <- DT1[id == 1 & code != "c"]

# 1b. Same as (1) but perform the subset using with(). See ?with if necessary
ans1b <- with(DT1, id == 1 & code != "c")

# 2. Select valA and valB columns from DF1 and store it in variable tmp1
ans2 <- DT1[, .(valA, valB)]

# 3. Get sum(valA) and sum(valB) for id > 1 as a 1-row, 2-col data.frame
ans3 <- DT1[id>1, lapply(.SD, sum), .SDcols = c("valA","valB")]

# 4. Replace valB with valB+1 for all rows where code == "c"
ans4 <- DT1[code == "c", valB := valB + 1L] 

# 5. Add a new column valC column with values equal to valB^2 - valA^2
ans5 <- DT1[, valC := valB^2 - valA^2]

# 6. Get sum(valA) and sum(valB) grouped by id and code (i.e., for each unique combination of id,code)
ans6 <- DT1[, lapply(.SD, sum), by = c("id","code"), .SDcols = c("valA", "valB")]

# 7. Get sum(valA) and sum(valB) grouped by id for id >= 2 & code %in% c("a", "c")
ans7 <- DT1[id >= 2 & code %in% c("a", "c"), lapply(.SD, sum), by = id, .SDcols = c("valA", "valB")]

# 8. Replace valA with max(valA)-min(valA) grouped by code
ans8 <- DT1[, valA := max(valA)-min(valA), by = code]

# 9. Create a new col named valD with max(valB)-min(valA) grouped by code
ans9 <- DT1[, valD := max(valB) - min(valA), by = code]

# 10. Subset DF1 by DF2 on id,code column. That is, for each row of DF2$id, DF2$code, get valA and valB cols from DF1. Include rows that have no matches as well.
ans10 <- DT1[DT2, on = c("id","code"), c("valA", "valB")]

# 11. Same as (10), but fetch just the first matching row of DF1 for each row of DF2$id, DF2$code. Exclude non-matching rows.
ans11 <- DT1[DT2, on = c("id","code"), c("valA", "valB"), mult = "first"]

# 12. For every row of DF2$id, DF2$code that matches with DF1’s, update  valA with valA*mul.
ans12 <- DT1[DT2, on = c("id","code"), valA := valA*mul]

# 13. Add a new column val to DF1 with values from DF2$mul where DF2$id, DF2$code matches with DF1’s. Rows that don’t match should have NA.
ans13 <- DT1[DT2, on = c("id", "code"), new_col := mul]

# 14. Compute sum(valA)*mul for every row of DF2$id, DF2$code by matching it against DF1.
ans14 <- DT1[DT2, on = c("id", "code"), list(sum(valA)*mul), nomatch = 0]

# 15. For every row of DF2$id, DF2$code that matches with DF1’s, update valB with valB*mul.
ans15 <- DT1[DT2, on = c("id", "code"), valB := valB*mul]


