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
#----------------------------------------------------------------------
# 1. In DT1, on those rows where id != 2, replace valA and valB with valA+1 and valB+1 respectively.
ans1 <- DT1[id != 2, `:=`(valA = valA+1L,
                          valB = valB+1L)]
ans1

# 2. On those rows where id == 2, replace valA with valB if valA is <= 7, else with valB^2.
ans2 <- DT1[id == 2, val := ifelse(valA <= 7L, valB, as.integer(valB^2))]
ans2

# 3. Create a new column `tmp` and assign `NA` to it by reference.
ans3 <- DT1[, temp := NA]
ans3

# 4. What’s the type (or class) of `tmp` column that we just created?
class(DT1[, temp])
class(DT1$temp)

# 5. Do DT1[, tmp := NULL] and observe the output.. What’s the difference compared to (3)?
ans3[, temp := NULL][]

# 6. Create a new column named “rank” which takes value 1 where code == “a”, 2 where code == “b” and 3 where code == “c”. 
# Do it in as many different ways you could think of :-).
ans6 <- DT1[code == "a", rank := 1L][
            code == "b", rank := 2L][
            code == "c", rank := 3L]
ans6 <- DT1[, rank := as.integer(factor(code))]
tmp_dt <- data.table(keys=c("a", "b", "c"), vals =1:3)
ans6 <- DT1[tmp_dt, on=.(code=keys), rank := i.vals]

# 7. Let DT3 = DT2[!duplicated(code)]. Update both valA and valB columns with ‘valA*mul’ and ‘valB*mul’ 
# wherever DT3$code matches DT1$code.. What happens to those rows where there are no matches in DT1? Why?
DT3 = DT2[!duplicated(code)]
ans7 <- DT1[DT3, on=.(code), c("valA", "valB") := lapply(.SD, `*`, i.mul), .SDcols= valA:valB]
ans7

# 8. Add the column ‘mul’ from DT2 to DT1 by reference where DT2$id matches DT1$id. 
# What happens to those values where DT2$id has the same value occurring more than once?
ans8 <- DT1[DT2, on=.(id), mul := i.mul]
ans8
# 9. Replace DT2$mul with NA where DT1$id, DT1$code matches DT2$id, DT2$code.
ans9 <- DT2[DT1, on=.(id, code), mul := NA]
ans9





