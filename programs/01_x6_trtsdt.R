# Answer 1-6: the date of first treatment in SDTM (DM) and in ADSL, for subject 01-701-1015
library(dplyr)

pharmaversesdtm::dm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, RFXSTDTC)

pharmaverseadam::adsl |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, TRTSDT)
