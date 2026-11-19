# Chapter 20: a small derivation whose log tells you what each step made
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A, AGE, SEX)

weight <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT", VSBLFL == "Y") |>
  select(USUBJID, WEIGHTBL = VSSTRESN)

adsl <- adsl |>
  left_join(weight, by = "USUBJID") |>
  mutate(WGTGR = if_else(WEIGHTBL >= 70, ">=70 kg", "<70 kg"))

adsl |>
  count(TRT01A, WGTGR)
