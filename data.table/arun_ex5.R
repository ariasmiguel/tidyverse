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
library(purrr)
DT1 <- as.data.table(DF1)
DT2 <- as.data.table(DF2)
#----------------------------------------------------------------------

# 1) Update valB with valB*<no: of rows in that group> grouped by code
ans1 <- DT1[, valB := valB*(.N), by = code]

# 2) Update both valA and valB with valA*max(valA) and valB*max(valB) respectively grouped by id, code
ans2b <- DT1[, c("valA", "valB") := lapply(.SD, function(x) x*max(x)), by=.(id,code), .SDcols = valA:valB]

# 3) Create two new columns ‘A2’, ‘B2’, while grouped by code, by randomly sampling 
# (with replacement) the same number of rows in the group from valA and valB respectively.
ans3 <- DT1[, c("A2", "B2") := lapply(.SD, function(x) sample(x, .N)), by=code, .SDcols=valA:valB]
ans3b <- DT1[, c("A2", "B2") := map(.SD, ~sample(.x, .N)), by = code, .SDcols = valA:valB]

# 4. Add a column named ‘uniq_N’ which contains the count of unique ‘code’ values, while grouped by ‘id’.
ans4 <- DT1[, uniq_N := uniqueN(code), by = id]
ans4

# 5. Update all rows of valB with NA where DT3$id, DT3$code *don’t* match with DT1$id, DT1$code.
DT3 = DT2[!duplicated(code)]
ans5 <- DT1[!DT3, on = .(id, code), valB := NA]
ans5

# 6. Let DT3 = DT2[!duplicated(id)]. For each DT3$id, find all rows in DT1$id that is <= DT3$id and compute sum(valA)*mul.
ans6 <- DT1[DT3, on = .(id <= id),
            sum(valA)*mul, by=.EACHI]
ans6





