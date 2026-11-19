# Chapter 1: summary statistics per arm
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  group_by(ARM) |>
  summarise(
    n = n(),
    mean = round(mean(AGE), 1),
    sd = round(sd(AGE), 1),
    min = min(AGE),
    max = max(AGE)
  )
