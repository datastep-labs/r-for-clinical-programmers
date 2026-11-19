# Chapter 26: subjects with a severe treatment-emergent adverse event per arm, a first draft
library(dplyr)

adae <- pharmaverseadam::adae

adae |>
  filter(TRTEMFL == "Y", AESEV == "SEVERE") |>
  group_by(TRT01A) |>
  summarise(subjects = n())
