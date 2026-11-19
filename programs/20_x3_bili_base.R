# Answer 20-3: one baseline bilirubin per subject, so the join copies nothing
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A)

bili <- pharmaversesdtm::lb |>
  filter(LBTESTCD == "BILI", LBBLFL == "Y") |>
  mutate(BILI = as.numeric(LBORRES)) |>
  select(USUBJID, BILI)

adsl_bili <- adsl |>
  left_join(bili, by = "USUBJID")

nrow(adsl_bili)
