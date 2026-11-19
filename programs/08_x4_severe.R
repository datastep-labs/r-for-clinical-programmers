# Exercise 8-4: count_by() on the TEAEs of one arm, by severity
library(dplyr)
source("R/count_by.R")

pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y", TRT01A == "Placebo") |>
  count_by(c(TRT01A, AESEV))
