# Chapter 6: put a group statistic on every row with group_by() and mutate()
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")

with_n <- adsl |>
  group_by(TRT01A) |>
  mutate(BIGN = n(), MEANAGE = round(mean(AGE), 1)) |>
  ungroup() |>
  select(USUBJID, TRT01A, AGE, BIGN, MEANAGE)
with_n |> filter(USUBJID == "01-701-1015")

# percent of the arm: count, then divide by the arm total
adsl |>
  count(TRT01A, SEX) |>
  group_by(TRT01A) |>
  mutate(pct = round(100 * n / sum(n), 1)) |>
  ungroup()
