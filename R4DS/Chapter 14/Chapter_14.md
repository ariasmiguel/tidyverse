# Chapter 14
Miguel Arias  
9/5/2017  



# Strings


```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```

Most common special characters:
* `"\n"`: newline
* `"\t"`: tab
* Complete list: `?'"'`

Stringr commands:
* `str_length()`: tells you the number of characters in a string:

```r
str_length(c("a", "R for data science", NA))
```

```
## [1]  1 18 NA
```

* `str_c()`: combines strings

```r
str_c("x", "y")
```

```
## [1] "xy"
```

```r
str_c("x", "y", "z")
```

```
## [1] "xyz"
```

Use the `sep` argument to control how they're separated:

```r
str_c("x", "y", sep = ", ")
```

```
## [1] "x, y"
```

Use `str_replace_na()` to show missing values as `"NA"`:

```r
x <- c("abc", NA)
str_c("|-", x, "-|")
```

```
## [1] "|-abc-|" NA
```

```r
str_c("|-", str_replace_na(x), "-|")
```

```
## [1] "|-abc-|" "|-NA-|"
```

* `str_sub`: takes `start` and `end` arguments which give the (inclusive) position of the substring:

```r
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
```

```
## [1] "App" "Ban" "Pea"
```

```r
str_sub(x, -3, -1)
```

```
## [1] "ple" "ana" "ear"
```

Can be used to modify strings:

```r
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
```

```
## [1] "apple"  "banana" "pear"
```

* `str_wrap()`: wraps text so that it fits withi a certain width. Useful for wrapping long strings of text to be typeset.

* `str_trim()`: trims the whitespace of a string:

```r
str_trim(" abc ")
```

```
## [1] "abc"
```

```r
str_trim(" abc ", side = "left")
```

```
## [1] "abc "
```

```r
str_trim(" abc ", side = "right")
```

```
## [1] " abc"
```

* `str_pad()`: opposite of `str_trim()`:

```r
str_pad("abc", 5, side = "both")
```

```
## [1] " abc "
```

```r
str_pad("abc", 5, side = "left")
```

```
## [1] "  abc"
```

```r
str_pad("abc", 5, side = "right")
```

```
## [1] "abc  "
```

* `str_view()`: takes a character vector and a regular expression, and show you how they match.

```r
x <- c("apple", "banana", "pear")
str_view(x, "an")
```

<!--html_preserve--><div id="htmlwidget-18a1e2845108fbdce303" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-18a1e2845108fbdce303">{"x":{"html":"<ul>\n  <li>apple<\/li>\n  <li>b<span class='match'>an<\/span>ana<\/li>\n  <li>pear<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# "." matches any character (except a newline)
str_view(x, ".a.")
```

<!--html_preserve--><div id="htmlwidget-6bf357c9fb77f51d0540" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-6bf357c9fb77f51d0540">{"x":{"html":"<ul>\n  <li>apple<\/li>\n  <li><span class='match'>ban<\/span>ana<\/li>\n  <li>p<span class='match'>ear<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# To create a regular expression, we need \\
dot <- "\\."

# But the expression itself only contains one:
writeLines(dot)
```

```
## \.
```

```r
# This tells R to look for an explicit
str_view(c("abc", "a.c", "bef"), "a\\.c")
```

<!--html_preserve--><div id="htmlwidget-48db4daee172736d4990" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-48db4daee172736d4990">{"x":{"html":"<ul>\n  <li>abc<\/li>\n  <li><span class='match'>a.c<\/span><\/li>\n  <li>bef<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# ^ to match beg of string, $ to match end of string
str_view(x, "^a")
```

<!--html_preserve--><div id="htmlwidget-dfb73c1df55450ed9e20" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-dfb73c1df55450ed9e20">{"x":{"html":"<ul>\n  <li><span class='match'>a<\/span>pple<\/li>\n  <li>banana<\/li>\n  <li>pear<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, "a$")
```

<!--html_preserve--><div id="htmlwidget-206d111adfbd4d6bd6ee" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-206d111adfbd4d6bd6ee">{"x":{"html":"<ul>\n  <li>apple<\/li>\n  <li>banan<span class='match'>a<\/span><\/li>\n  <li>pear<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, "^apple$")
```

<!--html_preserve--><div id="htmlwidget-b50c685b70594d2a9cd4" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-b50c685b70594d2a9cd4">{"x":{"html":"<ul>\n  <li><span class='match'>apple<\/span><\/li>\n  <li>banana<\/li>\n  <li>pear<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## 14.1 String Basic Exercises

3. Use `str_length()` and `str_sub()` to extract the middle character from a string. What will you do if the string has an even number of characters?

The following function extracts teh middle character. If the string has an even number of character the choice is arbitrary.


```r
x <- c("a", "abc", "abcd", "abcde", "abcdef")
L <- str_length(x)
m <- ceiling(L / 2)
str_sub(x, m, m)
```

```
## [1] "a" "b" "b" "c" "c"
```

6. Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.

```r
str_commasep <- function(x, sep = ", ", last = ", and ") {
  if (length(x) > 1) {
    str_c(str_c(x[-length(x)], collapse = sep),
          x[length(x)],
          sep = last)
  } else {
    x
  }
}
str_commasep("")
```

```
## [1] ""
```

```r
str_commasep("a")
```

```
## [1] "a"
```

```r
str_commasep(c("a", "b"))
```

```
## [1] "a, and b"
```

```r
str_commasep(c("a", "b", "c"))
```

```
## [1] "a, b, and c"
```

### 14.3.3 Characters and classes

* `\d` matches any digit (need to type `\\d`)
* `\s` matches any whitespace (need to type `\\s`)
* `[abc]` matches a, b, or c
* `[^abc]` matches anything but a, b, or c

#### 14.3.3.1 Exercises

1. Create a regular expressions to find all words that:

* Start with a vowel.
* Only contain consonants
* End with `ed`, but not with `eed`
* End with `ing` or `ise`


```r
# str_view(stringr::words, "^[aeiou]")
# str_view(stringr::words, "^[^aeiou]+$", match = TRUE)
# str_view(stringr::words, "^ed$|[^e]ed$", match = TRUE)
# str_view(stringr::words, "i(ng|se)$", match = TRUE)
```

2. Empirically verify the rule "i before e except after c"


```r
# str_view(stringr::words, "(cei|[^c]ie)", match = TRUE)
# str_view(stringr::words, "(cie|[^c]ei)", match = TRUE)

# Using str_detect()
sum(str_detect(stringr::words, "(cei|[^c]ie)"))
```

```
## [1] 14
```

```r
sum(str_detect(stringr::words, "(cie|[^c]ei)"))
```

```
## [1] 3
```

5. Create a regular expression that will match telephone numbers as commonly written in your country


```r
x <- c("123-456-7890", "1235-2351")
str_view(x, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")
```

<!--html_preserve--><div id="htmlwidget-661bc23e61c38959ea65" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-661bc23e61c38959ea65">{"x":{"html":"<ul>\n  <li><span class='match'>123-456-7890<\/span><\/li>\n  <li>1235-2351<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# Using stuff from the next chapter
str_view(x, "\\d{3}-\\d{3}-\\d{4}")
```

<!--html_preserve--><div id="htmlwidget-c009fa18850261766432" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-c009fa18850261766432">{"x":{"html":"<ul>\n  <li><span class='match'>123-456-7890<\/span><\/li>\n  <li>1235-2351<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

### 14.3.4 Repetition

Controlling how many times a pattern matches:
* `?`: 0 or 1
* `+`: 1 or more
* `*`: 0 or more


```r
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
```

<!--html_preserve--><div id="htmlwidget-f865361682421c824b02" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-f865361682421c824b02">{"x":{"html":"<ul>\n  <li>1888 is the longest year in Roman numerals: MD<span class='match'>CC<\/span>CLXXXVIII<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, "CC+")
```

<!--html_preserve--><div id="htmlwidget-bf44a5332d2933b6d866" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-bf44a5332d2933b6d866">{"x":{"html":"<ul>\n  <li>1888 is the longest year in Roman numerals: MD<span class='match'>CCC<\/span>LXXXVIII<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, 'C[LX]+')
```

<!--html_preserve--><div id="htmlwidget-a3eda2208298f5624ff4" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-a3eda2208298f5624ff4">{"x":{"html":"<ul>\n  <li>1888 is the longest year in Roman numerals: MDCC<span class='match'>CLXXX<\/span>VIII<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Can specify the number of matches:
* `{n}`: exactly n
* `{n,}`: n or more
* `{,m}`: at most m
* `{n,m}`: between n and m

### 14.3.5 Grouping and backreferences

Parentheses define "groups" that you can refer with _backreferences_, like `\1`, `\2` etc. For example, the following regular expression finds all fruits that have a repeated pair of letters.

```r
# str_view(fruit, "(..)\\1", match = TRUE)
```

#### 14.3.5.1 Exercises

1. Describe in words, what these expressions will match:

* `(.)\1\1`: the same character appearing three times in a row. E.g "aaa"
* `"(.)(.)\\2\\1"`: A pair of characters followed by the same pair of characters in reversed order. E.g. "abba"
* `(..)\1`: Any two characters repeated. E.g. "a1a1"
* `"(.).\\1.\\1"`: A character followed by any character, the original character, any other character, the original chracter again. E.g. "abaca", "b8b.b"
* `"(.)(.)(.).*\\3\\2\\1"`: There character followed by zero or more characters of any kind followed by the same three characters but in reverse order. E.g. “abcsgasgddsadgsdgcba” or “abccba” or “abc1cba”.

2. Construct regular expresions to match:


```r
# Start and end with the same character
# str_view(words, "^(.).*\\1$", match = TRUE)

# Contain a repeated pair of letters (e.g. "church") contains "ch" repeated twice

# Any two characters repeated
# str_view(words, "(..).*\\1", match = TRUE)

# More stringent, letters only, but also allowing for differences in capitalization
#str_view(str_to_lower(words), "([a-z][a-z]).*\\1", match = TRUE)
```

3. Contains one letter repeated in at least three places (e.g. "eleven" contains three "e"s)

```r
# str_view(words, "(.).*\\1.*\\1", match = TRUE)
```

## 14.4 Tools

To determine if a character vector matches a pattern, use `str_detect()`. It returns a logical vector the same length as the input:

```r
x <- c("apple", "banana", "pear")
str_detect(x, "e")
```

```
## [1]  TRUE FALSE  TRUE
```

Two ways to find all words that don't contain any vowels:

```r
no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)
```

```
## [1] TRUE
```

* A common use of `str_detect()` is to select the elemens that match a pattern. You can do this with logical subsetting, or the convenient `str_subset()` wrapper:


```r
words[str_detect(words, "x$")]
```

```
## [1] "box" "sex" "six" "tax"
```

```r
str_subset(words, "x$")
```

```
## [1] "box" "sex" "six" "tax"
```

* `str_count()` tells you how many matches are in a string:

```r
x <- c("apple", "banana", "pear")
str_count(x, "a")
```

```
## [1] 1 3 1
```

```r
mean(str_count(words, "[aeiou]"))
```

```
## [1] 1.991837
```

### 14.4.2 Exercises

1. All words that start or end with `x`.

```r
starts_with_x <- str_detect(words, "^x")
ends_with_x <- str_detect(words, "x$")
words[starts_with_x | ends_with_x]
```

```
## [1] "box" "sex" "six" "tax"
```

2. All words that start with a vowel and end with a consonant.

```r
starts_with_vowel <- str_detect(words, "^[aeiou]")
ends_with_cons <- str_detect(words, "[^aeiou]$")
words[starts_with_vowel | ends_with_cons] %>% head()
```

```
## [1] "a"        "able"     "about"    "absolute" "accept"   "account"
```

3. Any words that contain at least one of each different vowel?

```r
words[str_detect(words, "a") &
        str_detect(words, "e") &
        str_detect(words, "i") &
        str_detect(words, "o") &
        str_detect(words, "u")]
```

```
## character(0)
```

4. What word has the highest number of vowels? What word has the highest proportion of vowels? (Hint: what is the denominator?)

```r
prop_vowels <- str_count(words, "[aeiou]") / str_length(words)
words[which(prop_vowels == max(prop_vowels))]
```

```
## [1] "a"
```

### 14.4.3 Extract matches

`str_extract()` is used to extract the actual text of a match.


```r
length(sentences)
```

```
## [1] 720
```

```r
head(sentences)
```

```
## [1] "The birch canoe slid on the smooth planks." 
## [2] "Glue the sheet to the dark blue background."
## [3] "It's easy to tell the depth of a well."     
## [4] "These days a chicken leg is a rare dish."   
## [5] "Rice is often served in round bowls."       
## [6] "The juice of lemons makes fine punch."
```

```r
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match
```

```
## [1] "red|orange|yellow|green|blue|purple"
```

```r
# Can select sentences that contain a colour, and extract the colour to 
# figure out which one it is
has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)
```

```
## [1] "blue" "blue" "red"  "red"  "red"  "blue"
```

```r
more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)
```

<!--html_preserve--><div id="htmlwidget-de3d08b688a125e774b3" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-de3d08b688a125e774b3">{"x":{"html":"<ul>\n  <li>It is hard to erase <span class='match'>blue<\/span> or <span class='match'>red<\/span> ink.<\/li>\n  <li>The <span class='match'>green<\/span> light in the brown box flicke<span class='match'>red<\/span>.<\/li>\n  <li>The sky in the west is tinged with <span class='match'>orange<\/span> <span class='match'>red<\/span>.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_extract(more, colour_match)
```

```
## [1] "blue"   "green"  "orange"
```

```r
# The _all version returns lists
str_extract_all(more, colour_match)
```

```
## [[1]]
## [1] "blue" "red" 
## 
## [[2]]
## [1] "green" "red"  
## 
## [[3]]
## [1] "orange" "red"
```

```r
# By setting simplify = TRUE, it returns a matrix
str_extract_all(more, colour_match, simplify = TRUE)
```

```
##      [,1]     [,2] 
## [1,] "blue"   "red"
## [2,] "green"  "red"
## [3,] "orange" "red"
```

```r
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)
```

```
##      [,1] [,2] [,3]
## [1,] "a"  ""   ""  
## [2,] "a"  "b"  ""  
## [3,] "a"  "b"  "c"
```

**Exercises**

1. In the previous example, the regular expression matched "flickered", which is not a color. Modify it.

Add the `\b` before and after the pattern

```r
colour_match2 <- str_c("\\b(", str_c(colours, collapse = "|"), ")\\b")
colour_match2
```

```
## [1] "\\b(red|orange|yellow|green|blue|purple)\\b"
```

```r
more2 <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more2, colour_match2, match = TRUE)
```

<!--html_preserve--><div id="htmlwidget-9ab403308d0c3b55d62b" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-9ab403308d0c3b55d62b">{"x":{"html":"<ul>\n  <li>It is hard to erase <span class='match'>blue<\/span> or <span class='match'>red<\/span> ink.<\/li>\n  <li>The <span class='match'>green<\/span> light in the brown box flickered.<\/li>\n  <li>The sky in the west is tinged with <span class='match'>orange<\/span> <span class='match'>red<\/span>.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

2. Find the first word from each sentence

```r
str_extract(sentences, "[a-zA-X]+") %>% head()
```

```
## [1] "The"   "Glue"  "It"    "These" "Rice"  "The"
```

3. All words ending in `ing`:

```r
pattern <- "\\b[A-Za-z]+ing\\b"
sentences_with_ing <- str_detect(sentences, pattern)
unique(unlist(str_extract_all(sentences[sentences_with_ing], pattern))) %>%
  head()
```

```
## [1] "spring"  "evening" "morning" "winding" "living"  "king"
```

### 14.4.4 Grouped matches

If we want to extract nouns from the sentences. Look at any word that comes after "a" or "the".


```r
noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)
```

```
##  [1] "the smooth" "the sheet"  "the depth"  "a chicken"  "the parked"
##  [6] "the sun"    "the huge"   "the ball"   "the woman"  "a helps"
```

```r
# str_match() gives each individual components
has_noun %>% 
  str_match(noun)
```

```
##       [,1]         [,2]  [,3]     
##  [1,] "the smooth" "the" "smooth" 
##  [2,] "the sheet"  "the" "sheet"  
##  [3,] "the depth"  "the" "depth"  
##  [4,] "a chicken"  "a"   "chicken"
##  [5,] "the parked" "the" "parked" 
##  [6,] "the sun"    "the" "sun"    
##  [7,] "the huge"   "the" "huge"   
##  [8,] "the ball"   "the" "ball"   
##  [9,] "the woman"  "the" "woman"  
## [10,] "a helps"    "a"   "helps"
```

**Exercises**

1. Find all words that come after a number.


```r
numword <- "(one|two|three|four|five|six|seven|eight|nine|ten) +(\\S+)"
sentences[str_detect(sentences, numword)] %>%
  str_extract(numword)
```

```
##  [1] "ten served"    "one over"      "seven books"   "two met"      
##  [5] "two factors"   "one and"       "three lists"   "seven is"     
##  [9] "two when"      "one floor."    "ten inches."   "one with"     
## [13] "one war"       "one button"    "six minutes."  "ten years"    
## [17] "one in"        "ten chased"    "one like"      "two shares"   
## [21] "two distinct"  "one costs"     "ten two"       "five robins." 
## [25] "four kinds"    "one rang"      "ten him."      "three story"  
## [29] "ten by"        "one wall."     "three inches"  "ten your"     
## [33] "six comes"     "one before"    "three batches" "two leaves."
```

2. Find all contractions. Separate out the pieces before and after teh apostrophe.

```r
contraction <- "([A-Za-z]+)'([A-Za-z]+)"
sentences %>%
  `[`(str_detect(sentences, contraction)) %>%
  str_extract(contraction)
```

```
##  [1] "It's"       "man's"      "don't"      "store's"    "workmen's" 
##  [6] "Let's"      "sun's"      "child's"    "king's"     "It's"      
## [11] "don't"      "queen's"    "don't"      "pirate's"   "neighbor's"
```

### 14.4.5 Replacing matches

`str_replace()` and `str_replace_all()` allow you to replace matches with new strings. The simplest use is to replace a pattern with a fixed string:


```r
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
```

```
## [1] "-pple"  "p-ar"   "b-nana"
```

```r
str_replace_all(x, "[aeiou]", "-")
```

```
## [1] "-ppl-"  "p--r"   "b-n-n-"
```

```r
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
```

```
## [1] "one house"    "two cars"     "three people"
```

### 14.4.6 Splitting

Use `str_split()` to split a string up into pieces.

```r
sentences %>%
  head(5) %>%
  str_split(" ")
```

```
## [[1]]
## [1] "The"     "birch"   "canoe"   "slid"    "on"      "the"     "smooth" 
## [8] "planks."
## 
## [[2]]
## [1] "Glue"        "the"         "sheet"       "to"          "the"        
## [6] "dark"        "blue"        "background."
## 
## [[3]]
## [1] "It's"  "easy"  "to"    "tell"  "the"   "depth" "of"    "a"     "well."
## 
## [[4]]
## [1] "These"   "days"    "a"       "chicken" "leg"     "is"      "a"      
## [8] "rare"    "dish."  
## 
## [[5]]
## [1] "Rice"   "is"     "often"  "served" "in"     "round"  "bowls."
```

```r
# Can use simplify to return a matrix
sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)
```

```
##      [,1]    [,2]    [,3]    [,4]      [,5]  [,6]    [,7]    
## [1,] "The"   "birch" "canoe" "slid"    "on"  "the"   "smooth"
## [2,] "Glue"  "the"   "sheet" "to"      "the" "dark"  "blue"  
## [3,] "It's"  "easy"  "to"    "tell"    "the" "depth" "of"    
## [4,] "These" "days"  "a"     "chicken" "leg" "is"    "a"     
## [5,] "Rice"  "is"    "often" "served"  "in"  "round" "bowls."
##      [,8]          [,9]   
## [1,] "planks."     ""     
## [2,] "background." ""     
## [3,] "a"           "well."
## [4,] "rare"        "dish."
## [5,] ""            ""
```

Instead of splitting up strings by patterns, you can also split up by character, line, sentence and word `boundary()`s:

```r
x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))
```

<!--html_preserve--><div id="htmlwidget-9c4d128050a770b12664" style="width:960px;height:auto;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-9c4d128050a770b12664">{"x":{"html":"<ul>\n  <li><span class='match'>This<\/span> <span class='match'>is<\/span> <span class='match'>a<\/span> <span class='match'>sentence<\/span>.  <span class='match'>This<\/span> <span class='match'>is<\/span> <span class='match'>another<\/span> <span class='match'>sentence<\/span>.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_split(x, " ")[[1]]
```

```
## [1] "This"      "is"        "a"         "sentence." ""          "This"     
## [7] "is"        "another"   "sentence."
```

```r
str_split(x, boundary("word"))[[1]]
```

```
## [1] "This"     "is"       "a"        "sentence" "This"     "is"      
## [7] "another"  "sentence"
```

**Exercises**

1. Split up a string like `"apples, pears, and bananas"` into individual components.

```r
x <- c("apples, pears, and bananas")
str_split(x, ", +(and +)?")[[1]]
```

```
## [1] "apples"  "pears"   "bananas"
```

2. Why is it better to split up by `boundary("word")` than `" "`?
Spltting by `boundary("word")` splits on punctuation and not just whitespace.

3. What does splitting with an empty (`""`) do?

```r
str_split("ab. cd|agt", "")[[1]]
```

```
##  [1] "a" "b" "." " " "c" "d" "|" "a" "g" "t"
```

It splits the string into individual characters.

* `str_locate` and `str_locate_all()` give you the starting and ending positions of each match. Can use `str_locate()` to find the matching pattern, `str_sub()` to extract and/or modify them.

## 14.5 Other types

* `ignore_case = TRUE` allows characters to match either their uppercase or lowercase forms.

* `multiline = TRUE` allows `^` and `$` to match the start and end of each line rather than the start and end of the complete string.

* `comments = TRUE` allows you to use comments and white space to make complex regular expressions more understandable. Spaces are ignored, as is everything after `#`. To match a literal space, you'll need to escape it: `"\\ "`.

* `dotall = TRUE` allows `.` to match everything, including `\n`.

* `fixed()`: matches exactly the specified sequence of bytes. It ignores all special regular expressions.

* `coll()`: compare strings using standard **coll**ation rues. Useful for doing case insensitive matching. Relatively slow compared to `fixed()` and `regex()`.

**Exercises**

1. How would you find all strings containing `\` with `regex()` vs. with `fixed()`?

```r
str_subset(c("a\\b", "ab"), "\\\\")
```

```
## [1] "a\\b"
```

```r
str_subset(c("a\\b", "ab"), fixed("\\"))
```

```
## [1] "a\\b"
```

2. What are the five most common words in sentences?

```r
str_extract_all(sentences, boundary("word")) %>%
  unlist() %>%
  str_to_lower() %>%
  tibble() %>%
  set_names("word") %>%
  group_by(word) %>%
  count(sort = TRUE) %>%
  head(5)
```

```
## Warning in grouped_df_impl(data, unname(vars), drop): '.Random.seed' is not
## an integer vector but of type 'NULL', so ignored
```

```
## # A tibble: 5 x 2
## # Groups:   word [5]
##    word     n
##   <chr> <int>
## 1   the   751
## 2     a   202
## 3    of   132
## 4    to   123
## 5   and   118
```

## 14.7 stringi functions

1. `stri_count_words`: counts the number of words
2. `stri_duplicated`: finds duplicated strings
3. `stri_rand_`, `stri_rand_lipsum`, `stri_rand_strings`, `stri_rand_shuffle`: generates random text
4. Use `locale` argument to control the language that `stri_sort()` uses for sorting.

