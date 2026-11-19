# Answer 23-3: keep only the disposition event, so each subject stays one row
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A)

adsl_ds <- adsl |>
  left_join(
    pharmaversesdtm::ds |>
      filter(DSCAT == "DISPOSITION EVENT"),
    by = "USUBJID"
  ) |>
  select(USUBJID, TRT01A, DSDECOD)

adsl_ds |>
  count(TRT01A)
