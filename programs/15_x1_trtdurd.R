# EXPECT: WARNING Not all Values Compared Equal
# Answer 15-1: TRTDURD by a second way, compared with the reference
library(dplyr)
library(diffdf)

ours <- readRDS("data/adsl.rds") |>
  transmute(USUBJID, TRTDURD = as.numeric(TRTEDT - TRTSDT) + 1) |>
  haven::zap_label()
ref <- pharmaverseadam::adsl |>
  filter(ARMCD != "Scrnfail") |>
  select(USUBJID, TRTDURD) |>
  haven::zap_label()

ours |>
  filter(USUBJID == "01-701-1015")
diffdf(ours, ref, keys = "USUBJID")
