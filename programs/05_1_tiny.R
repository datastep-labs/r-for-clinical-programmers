# Chapter 5: two tiny tables, small enough to check every join by eye
library(dplyr)

dm <- tibble(
  USUBJID = c("S1", "S2", "S3", "S4"),
  AGE = c(63, 64, 71, 74)
)
ae <- tibble(
  USUBJID = c("S2", "S4", "S4", "S5"),
  AEDECOD = c("HEADACHE", "DIZZINESS", "NAUSEA", "RASH")
)

dm
ae
