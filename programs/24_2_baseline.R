# Chapter 24: baseline weight, the last value on or before the first dose, taken from the wrong visit
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRTSDT)
weight <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT")

base <- weight |>
  inner_join(adsl, by = "USUBJID") |>
  filter(as.Date(VSDTC) <= TRTSDT) |>
  arrange(USUBJID, VISIT) |>
  group_by(USUBJID) |>
  slice_tail(n = 1) |>
  ungroup() |>
  select(USUBJID, VISIT, VSDTC, BASE = VSSTRESN)

base |>
  filter(USUBJID == "01-701-1015")
