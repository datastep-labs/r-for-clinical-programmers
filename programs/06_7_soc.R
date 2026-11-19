# Chapter 6: TEAEs per system organ class: subjects and records
library(dplyr)

teae <- pharmaverseadam::adae |> filter(SAFFL == "Y", TRTEMFL == "Y")

teae |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AESOC, AEDECOD)

teae |>
  group_by(AESOC) |>
  summarise(subjects = n_distinct(USUBJID), records = n()) |>
  arrange(desc(subjects)) |>
  print(n = 5)
