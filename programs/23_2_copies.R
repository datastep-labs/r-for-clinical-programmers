# Chapter 23: add the disposition to ADSL, and the join copies the subjects
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A)

adsl_ds <- adsl |>
  left_join(pharmaversesdtm::ds, by = "USUBJID") |>
  select(USUBJID, TRT01A, DSCAT, DSDECOD)

adsl_ds |>
  count(TRT01A)
