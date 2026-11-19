# Chapter 25: age groups for the safety population, and four subjects get no group
library(dplyr)
source("25_1_age_group.R")

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A, AGE)
adsl <- adsl |>
  mutate(AGEGR = age_group(AGE))

adsl |>
  count(AGEGR)
