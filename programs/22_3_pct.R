# Chapter 22: a small function, used twice: go to its definition, find its uses, rename it
library(dplyr)

pct_subjects <- function(n, total) {
  round(100 * n / total, 1)
}

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

adsl |>
  count(TRT01A, SEX) |>
  mutate(pct = pct_subjects(n, sum(n)), .by = TRT01A)

adsl |>
  count(AGEGR1) |>
  mutate(pct = pct_subjects(n, sum(n)))
