# Library setup -----------------------------------------------------------
library(httr)
library(rvest)
library(knitr)
library(kableExtra)
library(ggalt)
library(statebins)
library(hrbrthemes)
library(epidata)
library(tidyverse)

options(knitr.table.format = "html")
update_geom_font_defaults(font_rc_light, size = 2.75)

# Exploring 2017 Retail Store Data ------------------------------------
# http://rpubs.com/hrbrmstr/stores_2017

# Get the data -------
closings <- list(
  kmart = "https://www.bostonglobe.com/metro/2017/01/05/the-full-list-kmart-stores-closing-around/4kJ0YVofUWHy5QJXuPBAuM/story.html",
  sears = "https://www.bostonglobe.com/metro/2017/01/05/the-full-list-sears-stores-closing-around/yHaP6nV2C4gYw7KLhuWuFN/story.html",
  macys = "https://www.bostonglobe.com/metro/2017/01/05/the-full-list-macy-stores-closing-around/6TY8a3vy7yneKV1nYcwY7K/story.html",
  jcp = "https://www.bostonglobe.com/business/2017/03/17/the-full-list-penney-stores-closing-around/vhoHjI3k75k2pSuQt2mZpO/story.html"
)

saved_pgs <- "saved_store_urls.rds"

if (file.exists(saved_pgs)) {
  pgs <- read_rds(saved_pgs)
} else {
  pgs <- map(closings, GET)
  write_rds(pgs, saved_pgs)
}

# What we get from that scraping effort ------------------------
map(pgs, content) %>%
  map(html_table) %>%
  walk(~glimpse(.[[1]]))

# Normalize -----------------------------------------------------
closings <- map(pgs, content) %>%
  map(html_table) %>%
  map(~.[[1]]) %>%
  map_df(select, abb=3, .id = "store")

closings %>%
  head()
