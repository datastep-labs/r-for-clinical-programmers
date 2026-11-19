# Chapter 1: write a value once, in a variable, and use it many times
library(dplyr)

arm <- "Placebo"

pharmaverseadam::adsl |>
  filter(SAFFL == "Y", ARM == arm) |>
  summarise(
    arm = arm,
    n = n(),
    mean = round(mean(AGE), 1),
    min = min(AGE),
    max = max(AGE)
  )
