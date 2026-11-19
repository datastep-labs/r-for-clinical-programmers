# Chapter 11: partial start dates in AE. Compare the part you know with the first dose
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AESEQ, AEDECOD, AESTDTC) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one") |>
  mutate(precision = case_when(
    nchar(AESTDTC) == 10 ~ "day",
    nchar(AESTDTC) == 7 ~ "month",
    nchar(AESTDTC) == 4 ~ "year"
  ))

ae |>
  count(precision)

# the first dose, cut to the length of the partial date: 2013-03-18 -> 2013-03
ae |>
  filter(precision != "day") |>
  mutate(dose_known = substr(as.character(TRTSDT), 1, nchar(AESTDTC))) |>
  count(precision, decided = case_when(
    AESTDTC < dose_known ~ "before the first dose",
    AESTDTC > dose_known ~ "after the first dose",
    .default = "open: same month or year"
  ))
