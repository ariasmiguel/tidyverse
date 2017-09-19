# Weather data challenge
library(purrr)

# Your task ---
# Below you will find code that downloads, manipulates, plots and saves
# one day, Dec 8, of weather data for Corvallis.  Your job is to rewrite 
# this to replicate for Dec 6 - Dec 10

library(tidyverse)
library(stringr)

# Downloading data --------------------------------------------------------
# note date is part of url
download.file("https://www.wunderground.com/history/airport/KCVO/2016/12/8/DailyHistory.html?format=1", "Purrr/Challenges/data/weather/dec8.csv")

link <- "https://www.wunderground.com/history/airport/KCVO/2016/12/8/DailyHistory.html?format=1"
file <- "Purrr/Challenges/data/weather/dec8.csv"
dates <- c("6", "7", "8", "9", "10")

d_file_read <- function(link, dates) {
  str_sub(link, 59, 59) <- dates
  file <- "Purrr/Chalanges/data/weather/dec8.csv"
  str_sub(file, 34, 34) <- dates
  download.file(link, file)
  col_types = c("cnnnnnccccccnc")
  read_csv(file, skip = 1, na = c("-", "N/A"), col_types = col_types)
}

d_file_read <- function(link, dates) {
  new_link <- paste0()
  
  
  
}

d_file(link, dates)


# Download all files

# Read in file -----------------------------------------------------------
col_types <- c("cnnnnnccccccnc")

dec8 <- read_csv("Purrr/Challenges/data/weather/dec8.csv", skip = 1, na = c("-", "N/A"), 
  col_types = col_types)

# Add date columns --------------------------------------------------------

dec8 <- mutate(dec8, year = 2016, month = 12, day = 8)
# add add a datetime variable
dec8 <- mutate(dec8,
  datetime = as.POSIXct(strptime(
    paste(year, month, day, TimePST, sep = " "), "%Y %m %d %I:%M %p")))

# Make and save plot -------------------------------------------------------
make_plot <- function(data, x, y) {
   x <- enquo(x)
   y <- enquo(y)
   month <- str_extract(data, "^[a-z]*")
   substr(month, 1, 1) <- toupper(substr(month, 1, 1))
   day <- str_extract(data, "[0-9]+")
   title <- paste(month, day, sep = " ")
   ggplot(data, mapping = aes(x, y))+
     geom_line() +
     ggtitle(title)
}


qplot(datetime, TemperatureF, data = dec8,
  geom = "line") +
  ggtitle("Dec 8")
ggsave("Purrr/Challenges/data/weather/plots/dec8.png")

