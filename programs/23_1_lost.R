# Chapter 23: treatment-emergent adverse events from SDTM, and some records get lost on the way
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A, TRTSDT)
ae <- pharmaversesdtm::ae

teae <- ae |>
  inner_join(adsl, by = "USUBJID") |>
  mutate(ASTDT = as.Date(AESTDTC), ASTDY = as.numeric(ASTDT - TRTSDT) + 1) |>
  filter(ASTDY >= 1) |>
  select(USUBJID, AESEQ, AEDECOD, AESTDTC, ASTDY, TRT01A)

teae |>
  summarise(records = n(), subjects = n_distinct(USUBJID))
