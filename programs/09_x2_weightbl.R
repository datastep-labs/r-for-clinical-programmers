# Answer 9-2: WEIGHTBL, the weight at baseline, as step 070 with one row per subject
library(dplyr)

adsl <- readRDS("data/adsl.rds")

vs_weightbl <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT", VSBLFL == "Y") |>
  select(USUBJID, WEIGHTBL = VSSTRESN)

adsl_070 <- adsl |>
  left_join(vs_weightbl, by = join_by(USUBJID), relationship = "one-to-one") |>
  mutate(WEIGHTBL = round(WEIGHTBL, 1))

nrow(adsl_070)
adsl_070 |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, WEIGHTBL)
adsl_070 |>
  filter(is.na(WEIGHTBL)) |>
  select(USUBJID, WEIGHTBL)
