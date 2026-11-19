# Chapter 6: subjects with at least one TEAE, as a percent of the big N
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adae <- pharmaverseadam::adae |> filter(SAFFL == "Y", TRTEMFL == "Y")

bign <- adsl |> count(TRT01A, name = "BIGN")
n_teae <- adae |>
  group_by(TRT01A) |>
  summarise(n = n_distinct(USUBJID))

bign |>
  left_join(n_teae, by = join_by(TRT01A)) |>
  mutate(pct = round(100 * n / BIGN, 1))
