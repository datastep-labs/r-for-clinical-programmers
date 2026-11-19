# Chapter 3: clean free text before you sort, join or print it
library(stringr)

raw <- "  Mild headache\r\nafter  dosing "
raw
str_length(raw)

str_trim(raw)
clean <- str_squish(raw)
clean
str_length(clean)

str_to_upper(clean)
str_sub(clean, 1, 8)
str_pad("1015", width = 6, pad = "0")
