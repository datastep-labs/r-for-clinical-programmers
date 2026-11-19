# Chapter 16: WEIGHTBL in small numbered steps, with the decisions apart
#
# Purpose:   WEIGHTBL, the baseline weight in kg, for ADSL
# Input:     data/adsl.rds (TRTSDT), pharmaversesdtm::vs (VSTESTCD WEIGHT)
# Rule:      the last non-missing weight on or before TRTSDT (the SAP rule
#            of chapter 10), not the SDTM flag VSBLFL
# Decisions: D1 2026-11-19  A weight on the day of the first dose counts:
#                           VSDTC has no time (check 7, 253 subjects)
#            D2 2026-11-19  VSBLFL is not used: for 01-702-1082 it is on
#                           no row, the SAP rule takes SCREENING 1 (check 8)
#            D3 2026-11-19  No weight before the dose gives NA (check 6: 0)
# Change log:
#   1.0  2026-11-19  First version.
library(dplyr)

adsl <- readRDS("data/adsl.rds")

# Step 010: the weights of the randomised subjects, with a real date
wt_010 <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT", !is.na(VSSTRESN)) |>
  transmute(USUBJID, VSSEQ, VISIT, ADT = as.Date(VSDTC), AVAL = VSSTRESN) |>
  inner_join(select(adsl, USUBJID, TRTSDT), by = join_by(USUBJID))

# Step 020: the decision. Which row is the baseline, and why (WTBLSRC)
wt_020 <- wt_010 |>
  filter(ADT <= TRTSDT) |> # D1: on or before
  arrange(USUBJID, ADT, VSSEQ) |>
  slice_tail(n = 1, by = USUBJID) |>
  mutate(WTBLSRC = if_else(ADT == TRTSDT, "day of dose", "before dose"))

# Step 030: the computation. Copy the value to ADSL, one row per subject
adsl_wt <- adsl |>
  left_join(
    wt_020 |> select(USUBJID, WEIGHTBL = AVAL, WTBLSRC, WTBLVIS = VISIT),
    by = join_by(USUBJID), relationship = "one-to-one"
  ) # D3: no row gives NA

# The proof that the decisions ran as agreed
count(adsl_wt, WTBLSRC, WTBLVIS)
adsl_wt |>
  filter(USUBJID %in% c("01-701-1015", "01-702-1082")) |>
  select(USUBJID, TRTSDT, WEIGHTBL, WTBLSRC, WTBLVIS)
saveRDS(adsl_wt, "data/16_adsl_weightbl.rds")
