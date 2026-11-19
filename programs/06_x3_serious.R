# Exercise 6-3: subjects with at least one serious TEAE, as a percent of the big N
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adae <- pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y", AESER == "Y")

bign <- adsl |> count(TRT01A, name = "BIGN")
n_ser <- adae |>
  group_by(TRT01A) |>
  summarise(n = n_distinct(USUBJID))

bign |>
  left_join(n_ser, by = join_by(TRT01A)) |>
  mutate(n = coalesce(n, 0L), pct = round(100 * n / BIGN, 1))
