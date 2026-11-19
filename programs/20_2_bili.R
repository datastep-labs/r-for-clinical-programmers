# Chapter 20: two problems that do not stop the run, and the suspicious log finds both
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A)

bili <- pharmaversesdtm::lb |>
  filter(LBTESTCD == "BILI") |>
  mutate(BILI = as.numeric(LBORRES)) |>
  select(USUBJID, VISIT, BILI)

adsl_bili <- adsl |>
  left_join(bili, by = "USUBJID")

nrow(adsl_bili)
