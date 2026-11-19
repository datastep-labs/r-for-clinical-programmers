# Exercise 5-4: the week-24 completers per arm, from SUPPDM joined to ADSL
library(dplyr)

comp24 <- pharmaversesdtm::suppdm |>
  filter(QNAM == "COMPLT24") |>
  select(USUBJID, COMP24FL = QVAL)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adsl_c <- left_join(adsl, comp24, by = join_by(USUBJID), relationship = "one-to-one")
c(before = nrow(adsl), after = nrow(adsl_c))

adsl_c |> count(TRT01A, COMP24FL)
