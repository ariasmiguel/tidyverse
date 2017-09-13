# Word count challenge
library(purrr)
library(readr)
library(stringi)

# Your task ----
# Produce a named numeric vector that contains the word counts for all
# files with a *.md extension:
## geospatial-README.md           nass-README.md purrr-workshop-README.md 
##                  232                      312                      216 

# To get you started
files <- dir("Purrr/Challenges/word_count_files", pattern = "*.md", 
  full.names = TRUE)
files

?readr::read_lines
?stringi::stri_stats_latex

# Read lines from one file
file1 <- read_lines(files[1])

# Function to extract file name
file_name <- function(x) {
  strsplit(gsub("Purrr/Challenges/word_count_files.", "", x), "/")
}

# Get the names
file_names <- unlist(map(files, ~ file_name(.x)))
file_names  

# Do this to all files
word_count <- map(files, ~read_lines(.x)) %>%  # Reads the lines for all files
map(~stri_stats_latex(.x)) %>%   # Gets word count
  map_int(~.x[4]) %>%            # Creates a integer vector
  structure(names = file_names)  # Sets the name of the integer to its file
