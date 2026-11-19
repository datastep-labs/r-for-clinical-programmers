# Chapter 7: across() applies one rule to many columns
library(dplyr)

flags <- pharmaversesdtm::suppdm |>
  tidyr::pivot_wider(id_cols = USUBJID, names_from = QNAM, values_from = QVAL) |>
  select(USUBJID, SAFETY, ITT, EFFICACY, COMPLT24)

# one rule, four columns: "Y" becomes 1, anything else 0
num <- flags |>
  mutate(across(
    c(SAFETY, ITT, EFFICACY, COMPLT24),
    ~ if_else(.x == "Y", 1, 0, missing = 0),
    .names = "{.col}N"
  ))
num |> filter(USUBJID == "01-701-1015")

# one rule in summarise(): the sum of every new column
num |> summarise(across(ends_with("N"), sum))
