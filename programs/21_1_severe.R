# Chapter 21: severe treatment-emergent adverse events, records and subjects per arm
library(dplyr)

adsl <- pharmaverseadam::adsl
adae <- pharmaverseadam::adae

adae |>
  filter(TRTEMFL == "Y", AESEV == "SEVERE") |>
  group_by(TRT01A) |>
  summarise(records = n(), subjects = n_distinct(USUBJID))
