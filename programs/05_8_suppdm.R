# Chapter 5: turn SUPPDM qualifiers into columns, then join them to DM
library(dplyr)

suppdm <- pharmaversesdtm::suppdm
suppdm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, QNAM, QLABEL, QVAL)

# one row per subject, one column per QNAM
flags <- suppdm |>
  tidyr::pivot_wider(id_cols = USUBJID, names_from = QNAM, values_from = QVAL)
flags |> filter(USUBJID == "01-701-1015")

dm <- pharmaversesdtm::dm |>
  select(USUBJID, ARM) |>
  left_join(flags, by = join_by(USUBJID), relationship = "one-to-one")
c(dm = nrow(dm), flags = nrow(flags))

dm |> count(ARM, EFFICACY)
