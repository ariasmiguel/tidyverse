# Links ---------------------------------------------------------
# https://www.dataquest.io/blog/sql-intermediate/
# https://github.com/tidyverse/dbplyr/blob/master/vignettes/dbplyr.Rmd
# https://www.r-bloggers.com/getting-started-with-postgresql-in-r/

# Library --------------------------------------------------------
require("RPostgreSQL")
require("tidyverse")

# Connect to DataBase ---------------------------------------------
pw <- {
  "welcome1"
}

# Load PostgreSQL driver 
drv <- dbDriver("PostgreSQL")
# create con to postgres database
con <- dbConnect(drv, dbname = "consumer_complaints",
                 host = "localhost", port = 5432,
                 user = "oracle", password = pw)
rm(pw) # removes password

# Check for the bank_account and credit_card tables ---------------
dbExistsTable(con, "bank_account_complaints")
dbExistsTable(con, "credit_card_complaints")

# Load the data into R -------------------------------------------
bank_db <- dbGetQuery(con, "SELECT * from bank_account_complaints")
credit_db <- dbGetQuery(con, "SELECT * from credit_card_complaints")

# Use dbplyr with dplyr to do queries -----------------------------
# Count rows
credit_db %>% summarise(count = n())
bank_db %>% summarise(count = n())

# Counting with conditionals
# Not nulls
credit_db %>% filter(!is.na(consumer_complaint_narrative)) %>%
  summarise(count = n())
bank_db %>% filter(!is.na(consumer_complaint_narrative)) %>%
  summarise(count = n())

# Nulls
credit_db %>% filter(is.na(consumer_complaint_narrative)) %>%
  summarise(count = n())
bank_db %>% filter(is.na(consumer_complaint_narrative)) %>%
  summarise(count = n()) 

# Using views -----------------------------------------------------
# A view is a logical representation of a query's result.
# Cannot insert into, update, or delete from it.

# Operator %>>% for views
`%>>%` <- function( expr, x) {
  x <- substitute(x)
  call <-   match.call()[-1]
  fun <- function() {NULL}
  body(fun) <- call$expr
  makeActiveBinding(sym = deparse(x), fun = fun, env = parent.frame())
  invisible(NULL)
}

# Credit card with complaints view
credit_db %>% 
  filter(!is.na(consumer_complaint_narrative)) %>>% 
  credit_w_complaint

# Credit card without complaints view
credit_db %>% 
  filter(is.na(consumer_complaint_narrative)) %>>% 
  credit_wo_complaint

# Bank account with complaints view
bank_db %>% 
  filter(!is.na(consumer_complaint_narrative)) %>>%
  bank_w_complaints
  
# Bank account without complaints view
bank_db %>% 
  filter(is.na(consumer_complaint_narrative)) %>>%
  bank_wo_complaints

# Query info from view ------------------------------------------
credit_w_complaint %>%
  head(5)

# Union and Union ALL -------------------------------------------
# Consolidate w_complaint and wo_complaint
union_all(credit_w_complaint, bank_w_complaints) %>>%
  with_complaints

union_all(credit_wo_complaint, bank_wo_complaints) %>>%
  without_complaints

head(with_complaints)
head(without_complaints)

# Intersect and except (setdiff) --------------------------------
credit_wo_complaint %>% summarise(count = n())

# Should be able to intersect the without_complaints view with
# the credit_wo_complaint view and return the same amount of 
# records
intersect(without_complaints, credit_wo_complaint) %>%
  summarise(count = n())

# Conversely, if we replace the intersect operator with an except
# operator, we should get difference in record counts between
# the without_complaints view and the 70,285 record count that
# was returned previously. 
# The difference should be 70,951 (141,236 - 70,285)
setdiff(without_complaints, credit_wo_complaint) %>%
  summarise(count = n())

# String concatenation ------------------------------------------
credit_db %>% select(complaint_id, product, company, zip_code) %>%
  mutate(concat = paste(complaint_id, "-", product, "-", 
                        company, "-", zip_code)) %>%
  head(10)

# Subqueries ----------------------------------------------------
query1 <- dbGetQuery(con, "SELECT ccd.complaint_id, ccd.product, ccd.company, ccd.zip_code
FROM (SELECT complaint_id, product, company, zip_code
                        FROM credit_card_complaints
                        WHERE zip_code = '91701') ccd 
                        LIMIT 10")
query1

# Get the same with dbplyr
ex1 <- credit_db %>% 
  select(complaint_id, product, company, zip_code) %>%
  filter(zip_code == '91701') %>%
  head(10)

# Query the company name, state, zip code associated with the
# number of complaints
query2 <- dbGetQuery(con, "SELECT company, state, zip_code, count(complaint_id) AS complaint_count
FROM credit_card_complaints
                        WHERE company = 'Citibank'
                        AND state IS NOT NULL
                        GROUP BY company, state, zip_code
                        ORDER BY 4 DESC
                        LIMIT 10")
query2

# Get the same with dbplyr
ex2 <- credit_db %>%
  select(company, state, zip_code) %>%
  filter(company == 'Citibank' & !is.na(state)) %>%
  group_by(company, state, zip_code) %>%
  summarise(complaint_count = n()) %>%
  arrange(desc(complaint_count)) # %>%
# head(10)

# Return the records with the highest number of complaints by 
# each state using subquery 2 as a subquery we can return
# the records with the highest number of complaints by each 
# state.

query3 <- dbGetQuery(con, "SELECT ppt.company, ppt.state, max(ppt.complaint_count) AS complaint_count
FROM (SELECT company, state, zip_code, count(complaint_id) AS complaint_count
                     FROM credit_card_complaints
                     WHERE company = 'Citibank'
                     AND state IS NOT NULL
                     GROUP BY company, state, zip_code
                     ORDER BY 4 DESC) ppt
                     GROUP BY ppt.company, ppt.state
                     ORDER BY 3 DESC
                     LIMIT 10")
query3

# Do it in dplyer
ex3 <- ex2 %>%
  group_by(company, state) %>%
  summarise(complaint_count = max(complaint_count)) %>%
  arrange(desc(complaint_count)) # %>%
  # head(10)

# Expand the query and return the state and zip_code with the
# highest number of complaints
query4 <- dbGetQuery(con, "SELECT ens.company, ens.state, ens.zip_code, ens.complaint_count
FROM (SELECT company, state, zip_code, count(complaint_id) AS complaint_count
      FROM credit_card_complaints
      WHERE state IS NOT NULL
      GROUP BY company, state, zip_code) ens
INNER JOIN
   (SELECT ppx.company, max(ppx.complaint_count) AS complaint_count
    FROM (SELECT ppt.company, ppt.state, max(ppt.complaint_count) AS complaint_count
          FROM (SELECT company, state, zip_code, count(complaint_id) AS complaint_count
                FROM credit_card_complaints
                WHERE company = 'Citibank' 
                 AND state IS NOT NULL
                GROUP BY company, state, zip_code
                ORDER BY 4 DESC) ppt
          GROUP BY ppt.company, ppt.state
          ORDER BY 3 DESC) ppx
   GROUP BY ppx.company) apx
ON apx.company = ens.company
  AND apx.complaint_count = ens.complaint_count
ORDER BY 4 DESC
LIMIT 10")
query4

# Do it in dplyr
# Inner Select Statement
ex2 <- credit_db %>%
  select(company, state, zip_code) %>%
  filter(company == 'Citibank' & !is.na(state)) %>%
  group_by(company, state, zip_code) %>%
  summarise(complaint_count = n()) %>%
  arrange(desc(complaint_count))

# Second Inner Select Statement
ex3 <- ex2 %>%
  group_by(company, state) %>%
  summarise(complaint_count = max(complaint_count)) %>%
  arrange(desc(complaint_count))

# Third Inner Select Statement
ex4 <- ex3 %>%
  group_by(company) %>%
  summarise(complaint_count = max(complaint_count))

# First part of the select stament (Before join)
ex5 <- credit_db %>%
  select(company, state, zip_code) %>%
  filter(!is.na(state)) %>%
  group_by(company, state, zip_code) %>%
  summarise(complaint_count = n())

ans1 <- inner_join(ex5, ex4, by = c("company" = "company",
                            "complaint_count" = "complaint_count")) %>%
  select(company, state, zip_code, complaint_count) %>%
  arrange(desc(complaint_count))

# Remove company filter ------------------------------------------
query5 <- dbGetQuery(con, "SELECT ens.company, ens.state, ens.zip_code, ens.complaint_count
FROM (SELECT company, state, zip_code, count(complaint_id) AS complaint_count
                     FROM credit_card_complaints
                     WHERE state IS NOT NULL
                     GROUP BY company, state, zip_code) ens
                     INNER JOIN
                     (select ppx.company, max(ppx.complaint_count) AS complaint_count
                     FROM (select ppt.company, ppt.state, max(ppt.complaint_count) AS complaint_count
                     FROM (select company, state, zip_code, count(complaint_id) AS complaint_count
                     FROM credit_card_complaints
                     WHERE state IS NOT NULL
                     GROUP BY company, state, zip_code
                     ORDER BY 4 DESC) ppt
                     GROUP BY ppt.company, ppt.state
                     ORDER BY 3 DESC) ppx
                     GROUP BY ppx.company) apx
                     ON apx.company = ens.company
                     AND apx.complaint_count = ens.complaint_count
                     ORDER BY 4 DESC
                     LIMIT 10")
query5

# Do it in dplyr (Same without company == 'Citibank')
ex2.1 <- credit_db %>%
  select(company, state, zip_code) %>%
  filter(!is.na(state)) %>%
  group_by(company, state, zip_code) %>%
  summarise(complaint_count = n()) %>%
  arrange(desc(complaint_count))

# Second Inner Select Statement
ex3.1 <- ex2.1 %>%
  group_by(company, state) %>%
  summarise(complaint_count = max(complaint_count)) %>%
  arrange(desc(complaint_count))

# Third Inner Select Statement
ex4.1 <- ex3.1 %>%
  group_by(company) %>%
  summarise(complaint_count = max(complaint_count))

# First part of the select stament (Before join)
ex5 <- credit_db %>%
  select(company, state, zip_code) %>%
  filter(!is.na(state)) %>%
  group_by(company, state, zip_code) %>%
  summarise(complaint_count = n())

ans2 <- inner_join(ex5, ex4.1, by = c("company" = "company",
                                    "complaint_count" = "complaint_count")) %>%
  select(company, state, zip_code, complaint_count) %>%
  arrange(desc(complaint_count)) %>%
  head(10)
ans2

# Casting Data Types --------------------------------------------
# CAST (source_column AS type);
# Used to change field type on the fly

dbGetQuery(con, "SELECT CAST(complaint_id AS float) AS complaint_id
FROM bank_account_complaints LIMIT 10")

bank_db %>% select(complaint_id) %>%
  mutate(complaint_id = as.double(complaint_id)) %>%
  head(10)

# Test query that's going to be used to define a new view

dbGetQuery(con, "SELECT CAST(complaint_id AS int) AS complaint_id,
       date_received, product, sub_product, issue, company,
           state, zip_code, submitted_via, date_sent, company_response_to_consumer,
           timely_response, consumer_disputed
           FROM bank_account_complaints 
           WHERE state = 'CA'  
           AND consumer_disputed = 'false' 
           AND company = 'Wells Fargo & Company'
           LIMIT 5")

bank_db %>% 
  select(complaint_id, date_received, product, sub_product,
        issue, company, state, zip_code, submitted_via,
        date_sent, company_response_to_consumer, timely_response,
        consumer_disputed) %>%
  mutate(complaint_id = as.integer(complaint_id)) %>%
  filter(state == 'CA',
         consumer_disputed == 'false',
         company == 'Wells Fargo & Company') %>%
  head(5)

# Create a view in PostgreSQL
dbSendQuery(con, "CREATE VIEW wells_complaints_v AS (
    SELECT CAST(complaint_id AS int) AS complaint_id,
            date_received, product, sub_product, issue, company,
            state, zip_code, submitted_via, date_sent, company_response_to_consumer,
            timely_response, consumer_disputed
            FROM bank_account_complaints 
            WHERE state = 'CA'  
            AND consumer_disputed = 'No' 
            AND company = 'Wells Fargo & Company')")

# Create view in R
bank_db %>% 
  select(complaint_id, date_received, product, sub_product,
         issue, company, state, zip_code, submitted_via,
         date_sent, company_response_to_consumer, timely_response,
         consumer_disputed) %>%
  mutate(complaint_id = as.integer(complaint_id)) %>%
  filter(state == 'CA',
         consumer_disputed == 'false',
         company == 'Wells Fargo & Company') %>>%
  wells_complaints_v

# Challenges ---------------------------------------------------
# 1 
challenge1 <- credit_db %>%
  group_by(company) %>%
  summarise(company_amt = n()) %>%
  arrange(desc(company_amt))
challenge1 %>% head(5)

# 2
total <- credit_db %>%
  summarise(total = n())

challenge2 <- credit_db %>%
  group_by(company) %>%
  summarise(company_amt = n(), total = unlist(total)) %>%
  arrange(desc(company_amt))

# 3
challenge3 <- credit_db %>%
  group_by(company) %>%
  summarise(company_amt = n(), total = unlist(total),
            percent = company_amt/total * 100) %>%
  arrange(desc(company_amt))
challenge3

credit_db %>%
  group_by(company) %>%
  summarise(company_amt = n(), total = unlist(total),
            percent = company_amt/total * 100) %>%
  arrange(desc(company_amt)) %>%
  head(5)

# Close the connection -------------------------------------------
dbDisconnect(con)
dbUnloadDriver(drv)
