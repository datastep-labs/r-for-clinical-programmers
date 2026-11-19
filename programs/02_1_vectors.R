# Chapter 2: a vector holds values of one type; a data frame is named vectors of the same length
library(dplyr)

ages <- c(63, 64, 71)
ages
length(ages)
ages * 12
ages >= 65

subjects <- tibble(
  USUBJID = c("01-701-1015", "01-701-1023", "01-701-1028"),
  AGE = ages,
  SEX = c("F", "M", "M")
)
subjects

subjects$AGE
nrow(subjects)
