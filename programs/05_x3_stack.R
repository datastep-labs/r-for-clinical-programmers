# Exercise 5-3: stack the AE and CM records of one subject into one table
library(dplyr)

ae <- pharmaversesdtm::ae |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, TERM = AEDECOD, START = AESTDTC)
cm <- pharmaversesdtm::cm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, TERM = CMDECOD, START = CMSTDTC)

events <- bind_rows(AE = ae, CM = cm, .id = "DOMAIN")
events |> count(DOMAIN)
events |> arrange(START) |> print(n = 3)
