# Chapter 16: the decisions as data. Each one says what it must change, and the
# program checks that it did
library(dplyr)

decisions <- tribble(
  ~id,  ~question,                                  ~answer,             ~expect,
  "D1", "Weight on the day of the dose: baseline?", "yes: on or before", 253,
  "D2", "VSBLFL or the SAP rule?",                  "the SAP rule",      1,
  "D3", "No weight before the dose?",               "WEIGHTBL is NA",    0
)

adsl_wt <- readRDS("data/16_adsl_weightbl.rds")
found <- c(
  D1 = sum(adsl_wt$WTBLSRC == "day of dose", na.rm = TRUE),
  D2 = sum(adsl_wt$WTBLVIS != "BASELINE", na.rm = TRUE),
  D3 = sum(is.na(adsl_wt$WEIGHTBL))
)

check <- decisions |>
  mutate(found = found[id], ok = found == expect)
check |>
  select(id, answer, expect, found, ok)

# A decision that does not hold stops the run
stopifnot(all(check$ok))
