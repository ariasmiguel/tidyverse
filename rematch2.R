# Library -----------------------------------------------
library(tidyverse)
library(rematch2)

# rematch2 ----------------------------------------------------------
# https://github.com/r-lib/rematch2
# text is first, pattern is second
dates <- c("2016-04-20", "1977-08-08", "not a date", "2016",
           "76-03-02", "2012-06-30", "2015-01-21 19:58")
isodate <- "([0-9]{4})-([0-1][0-9])-([0-3][0-9])"
re_match(text = dates, pattern = isodate)


# Named capture groups --------------------------------------------
isodaten <- "(?<year>[0-9]{4})-(?<month>[0-1][0-9])-(?<day>[0-3][0-9])"
re_match(text = dates, pattern = isodaten)


# More complex examples -----------------------------------------------
# First
github_repos <- c(
  "metacran/crandb",
  "jeroenooms/curl@v0.9.3",
  "jimhester/covr#47",
  "hadley/dplyr@*release",
  "r-lib/remotes@550a3c7d3f9e1493a2ba",
  "/$&@R64&3"
)
owner_rx   <- "(?:(?<owner>[^/]+)/)?"
repo_rx    <- "(?<repo>[^/@#]+)"
subdir_rx  <- "(?:/(?<subdir>[^@#]*[^@#/]))?"
ref_rx     <- "(?:@(?<ref>[^*].*))"
pull_rx    <- "(?:#(?<pull>[0-9]+))"
release_rx <- "(?:@(?<release>[*]release))"

subtype_rx <- sprintf("(?:%s|%s|%s)?", ref_rx, pull_rx, release_rx)
github_rx  <- sprintf(
  "^(?:%s%s%s%s|(?<catchall>.*))$",
  owner_rx, repo_rx, subdir_rx, subtype_rx
)
re_match(text = github_repos, pattern = github_rx)

# Second --------------------------------------------------------
name_rex <- paste0(
  "(?<first>[[:upper:]][[:lower:]]+) ",
  "(?<last>[[:upper:]][[:lower:]]+)"
)
notables <- c(
  "The  Ben Franklin and Jefferson Davis",
  "\tMillard Fillmore"
)
not <- re_match_all(notables, name_rex)
not
not$first

# re_exec and re_exec_all ---------------------------------------
pos <- re_exec(notables, name_rex)
pos
pos$first$match
pos$first$start
pos$first$end

allpos <- re_exec_all(notables, name_rex)
allpos
allpos$first$match
allpos$first$start
allpos$first$end
