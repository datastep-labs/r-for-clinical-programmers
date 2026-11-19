# Chapter 16: compare at the end. WEIGHTBL against two independent sources
library(dplyr)
library(diffdf)

ours <- readRDS("data/16_adsl_weightbl.rds") |>
  select(USUBJID, WEIGHTBL) |>
  haven::zap_label()

# Source 1: the baseline of your ADVS of chapter 10, another program
advs_bl <- readRDS("data/advs.rds") |>
  filter(PARAMCD == "WEIGHT", ABLFL == "Y") |>
  select(USUBJID, WEIGHTBL = AVAL) |>
  haven::zap_label()
diffdf(ours, advs_bl, keys = "USUBJID")

# Source 2: the reference ADVS of pharmaverseadam
ref_bl <- pharmaverseadam::advs |>
  filter(PARAMCD == "WEIGHT", ABLFL == "Y") |>
  select(USUBJID, WEIGHTBL = AVAL) |>
  haven::zap_label()
diffdf(ours, ref_bl, keys = "USUBJID")
