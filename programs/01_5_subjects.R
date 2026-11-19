# Chapter 1: count subjects, not records
library(dplyr)

pharmaverseadam::adae |>
  filter(TRTEMFL == "Y") |>
  group_by(TRT01A) |>
  summarise(
    records = n(),
    subjects = n_distinct(USUBJID)
  )
