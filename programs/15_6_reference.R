# EXPECT: WARNING Not all Values Compared Equal
# Chapter 15: our ADSL against the reference ADSL of pharmaverseadam
library(dplyr)
library(diffdf)

vars <- c("USUBJID", "TRTSDT", "TRTEDT", "AGEGR1", "SAFFL")
ours <- readRDS("data/adsl.rds") |>
  select(all_of(vars)) |>
  haven::zap_label()
ref <- pharmaverseadam::adsl |>
  filter(ARMCD != "Scrnfail") |>
  select(all_of(vars)) |>
  haven::zap_label()

res <- diffdf(ours, ref, keys = "USUBJID")
res$NumDiff

# 254 of 254 differ: look for a rule, not for 254 bugs
inner_join(ours, ref, by = join_by(USUBJID), suffix = c("", "_REF")) |>
  count(AGEGR1, AGEGR1_REF)
