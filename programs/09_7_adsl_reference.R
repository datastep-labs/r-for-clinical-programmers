# EXPECT: WARNING Not all Values Compared Equal
# Chapter 9: compare our ADSL with the reference ADSL of pharmaverseadam
library(dplyr)
library(diffdf)

vars <- c("USUBJID", "TRT01P", "TRT01A", "TRTSDT", "TRTEDT", "SAFFL", "EOSSTT")

# zap_label() removes the variable labels: here we compare values, not labels
ours <- readRDS("data/adsl.rds") |>
  select(all_of(vars)) |>
  haven::zap_label()
ref <- pharmaverseadam::adsl |>
  filter(ARMCD != "Scrnfail") |>
  select(all_of(vars)) |>
  haven::zap_label()

diffdf(ours, ref, keys = "USUBJID")
