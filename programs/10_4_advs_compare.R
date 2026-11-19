# Chapter 10: ADVS by hand against admiral, then against the reference ADVS
library(dplyr)
library(diffdf)

# admiral drops the labels that the SDTM columns bring: compare the values only
advs_hand <- readRDS("data/advs_hand.rds") |>
  haven::zap_label()
advs <- readRDS("data/advs.rds") |>
  haven::zap_label()

diffdf(advs_hand, advs, keys = c("USUBJID", "VSSEQ"))

# The reference has derived rows too (DTYPE is not missing)
pharmaverseadam::advs |>
  filter(PARAMCD %in% advs$PARAMCD) |>
  count(DTYPE)

# Compare the rows that come from VS
vars <- c(
  "USUBJID", "VSSEQ", "AVISIT", "AVISITN", "ADT", "ADY", "AVAL", "ABLFL",
  "BASE", "CHG", "PCHG"
)
ref <- pharmaverseadam::advs |>
  filter(PARAMCD %in% advs$PARAMCD, is.na(DTYPE)) |>
  select(all_of(vars)) |>
  haven::zap_label()
ours <- advs |>
  select(all_of(vars))

diffdf(ours, ref, keys = c("USUBJID", "VSSEQ"))
