# Exercise 5-1: semi_join() with AE first keeps AE rows, and never repeats them
library(dplyr)

dm <- tibble(USUBJID = c("S1", "S2", "S3", "S4"), AGE = c(63, 64, 71, 74))
ae <- tibble(
  USUBJID = c("S2", "S4", "S4", "S5"),
  AEDECOD = c("HEADACHE", "DIZZINESS", "NAUSEA", "RASH")
)

semi_join(ae, dm, by = join_by(USUBJID))
