# Chapter 6: look at a data frame before you use it
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  select(STUDYID, USUBJID, ARM, TRT01A, AGE, SEX, RACE, SAFFL, TRTSDT)

dim(adsl)
names(adsl)
glimpse(adsl)

# the labels, as PROC CONTENTS lists them
sapply(adsl, attr, "label")

adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A, AGE, SEX, RACE) |>
  print(n = 5)
