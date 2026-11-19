# Chapter 6: count rows per value with count(), and add a percent
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")

adsl |> count(SEX)

adsl |>
  count(SEX) |>
  mutate(pct = round(100 * n / sum(n), 1))

adsl |> count(TRT01A, SEX)

# count() keeps NA as a value of its own
pharmaversesdtm::vs |>
  filter(VISIT == "BASELINE") |>
  count(VSPOS)
