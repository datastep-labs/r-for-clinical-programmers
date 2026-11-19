# Chapter 5: stack tables with bind_rows()
library(dplyr)

dm <- tibble(USUBJID = c("S1", "S2", "S3", "S4"), AGE = c(63, 64, 71, 74))
more <- tibble(USUBJID = c("S0", "S5"), AGE = c(58, 80))

# stack, and record where each row came from
bind_rows(DM = dm, MORE = more, .id = "SOURCE")

# a column that only one table has: the other rows get NA
late <- tibble(USUBJID = "S6", SEX = "F")
bind_rows(dm, late)

# interleave: stack, then sort by the key
bind_rows(dm, more) |>
  arrange(USUBJID)
