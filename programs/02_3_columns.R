# Chapter 2: mutate() works on whole columns, so one step can use the mean of all rows
library(dplyr)

pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail") |>
  select(USUBJID, AGE) |>
  mutate(
    MEAN_AGE = mean(AGE),
    DIFF = AGE - MEAN_AGE
  ) |>
  print(n = 3)
