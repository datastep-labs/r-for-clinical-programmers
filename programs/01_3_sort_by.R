# Chapter 1: sort, then work in groups. The oldest subject of each arm
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, ARM, AGE) |>
  arrange(ARM, desc(AGE), USUBJID) |>
  group_by(ARM) |>
  slice_head(n = 1) |>
  ungroup()
