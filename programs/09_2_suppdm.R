# Chapter 9: SUPPDM is tall. It holds only the "Y" values, so a missing record means "no"
library(dplyr)

suppdm <- pharmaversesdtm::suppdm

suppdm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, QNAM, QVAL)

suppdm |>
  count(QNAM, QVAL)

ds <- pharmaversesdtm::ds
ds |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, DSSEQ, DSCAT, DSDECOD, DSSTDTC)
