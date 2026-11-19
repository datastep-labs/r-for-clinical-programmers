# Exercise 6-1: the first five subjects of the placebo arm
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y", TRT01A == "Placebo") |>
  select(USUBJID, TRT01A, AGE, SEX, RACE) |>
  print(n = 5)
