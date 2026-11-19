# EXPECT: WARNING differing attributes
# Chapter 15: compare production (chapter 9) with the QC program
library(dplyr)
library(diffdf)

vars <- c("USUBJID", "TRTSDT", "TRTEDT", "AGEGR1", "SAFFL")
prod <- readRDS("data/adsl.rds") |>
  select(all_of(vars)) |>
  haven::zap_label()
qc <- readRDS("data/15_qc_adsl.rds")

diffdf(prod, qc, keys = "USUBJID")

# The values agree; only a label differs. Compare the values only
diffdf(prod, haven::zap_label(qc), keys = "USUBJID")
