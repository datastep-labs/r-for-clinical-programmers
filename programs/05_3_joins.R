# Chapter 5: the four joins differ only in the rows without a partner
library(dplyr)

dm <- tibble(USUBJID = c("S1", "S2", "S3", "S4"), AGE = c(63, 64, 71, 74))
ae <- tibble(
  USUBJID = c("S2", "S4", "S4", "S5"),
  AEDECOD = c("HEADACHE", "DIZZINESS", "NAUSEA", "RASH")
)

inner_join(dm, ae, by = join_by(USUBJID))
left_join(dm, ae, by = join_by(USUBJID))
right_join(dm, ae, by = join_by(USUBJID))
full_join(dm, ae, by = join_by(USUBJID))
