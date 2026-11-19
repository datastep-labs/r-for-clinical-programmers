# Chapter 1: a first program. Read ADSL, keep five columns, count the subjects per arm
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  select(USUBJID, ARM, AGE, SEX, SAFFL)

adsl |>
  count(ARM)
