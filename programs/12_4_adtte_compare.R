# Chapter 12: ADTTE by hand against admiral. There is no reference ADTTE
library(diffdf)

# derive_param_tte() does not keep the labels of ADSL: compare the values only
adtte_hand <- readRDS("data/adtte_hand.rds") |>
  haven::zap_label()
adtte <- readRDS("data/adtte.rds") |>
  haven::zap_label()

diffdf(adtte_hand, adtte, keys = c("USUBJID", "PARAMCD"))

# the time-to-event data sets in pharmaverseadam
grep("adtte", data(package = "pharmaverseadam")$results[, "Item"], value = TRUE)
