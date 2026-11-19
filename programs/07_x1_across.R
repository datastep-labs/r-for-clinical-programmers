# Exercise 7-1: two more population flags in the same across() call
library(dplyr)

pharmaversesdtm::suppdm |>
  tidyr::pivot_wider(id_cols = USUBJID, names_from = QNAM, values_from = QVAL) |>
  mutate(across(
    c(SAFETY, ITT, EFFICACY, COMPLT8, COMPLT16, COMPLT24),
    ~ if_else(.x == "Y", 1, 0, missing = 0),
    .names = "{.col}N"
  )) |>
  summarise(across(ends_with("N"), sum))
