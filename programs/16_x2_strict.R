# Answer 16-2: a new decision D1: only a weight strictly before the dose
library(dplyr)

adsl <- readRDS("data/adsl.rds")

wt_010 <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT", !is.na(VSSTRESN)) |>
  transmute(USUBJID, VSSEQ, VISIT, ADT = as.Date(VSDTC), AVAL = VSSTRESN) |>
  inner_join(select(adsl, USUBJID, TRTSDT), by = join_by(USUBJID))

# Step 020 is the only step that changes: < instead of <=
wt_020 <- wt_010 |>
  filter(ADT < TRTSDT) |>
  arrange(USUBJID, ADT, VSSEQ) |>
  slice_tail(n = 1, by = USUBJID)

adsl_wt <- adsl |>
  left_join(
    wt_020 |> select(USUBJID, WEIGHTBL = AVAL, WTBLVIS = VISIT),
    by = join_by(USUBJID), relationship = "one-to-one"
  )
count(adsl_wt, WTBLVIS)
adsl_wt |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, WEIGHTBL, WTBLVIS)
