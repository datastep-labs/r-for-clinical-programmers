# Chapter 4: summarise() keeps a group, so the next step works inside it. ungroup() or .by = prevents that
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

adsl |>
  group_by(ARM, SEX) |>
  summarise(n = n()) |>
  mutate(PCT = round(100 * n / sum(n), 1))

adsl |>
  summarise(n = n(), .by = c(ARM, SEX)) |>
  mutate(PCT = round(100 * n / sum(n), 1))
