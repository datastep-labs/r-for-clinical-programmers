# Answer 1-3: without desc(), the first subject of each arm is the youngest
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, ARM, AGE) |>
  arrange(ARM, AGE, USUBJID) |>
  group_by(ARM) |>
  slice_head(n = 1) |>
  ungroup()
