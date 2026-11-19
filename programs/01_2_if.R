# Chapter 1: if_else() makes a new column from an old one
library(dplyr)

adsl_age <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, ARM, AGE) |>
  mutate(AGEGRP = if_else(AGE >= 65, "65 or older", "under 65"))

adsl_age |>
  count(AGEGRP)
