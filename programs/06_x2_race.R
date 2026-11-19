# Exercise 6-2: race by treatment in the safety population
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  count(TRT01A, RACE)
