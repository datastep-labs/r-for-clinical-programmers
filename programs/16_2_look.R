# Chapter 16: one check failed. Look at the subject before you decide anything
library(dplyr)

trtsdt <- readRDS("data/adsl.rds") |>
  filter(USUBJID == "01-702-1082") |>
  pull(TRTSDT)
trtsdt

pharmaversesdtm::vs |>
  filter(USUBJID == "01-702-1082", VSTESTCD == "WEIGHT") |>
  select(VSSEQ, VISIT, VSDTC, VSSTRESN, VSBLFL)

# Which visits does this subject have before the first dose, in any VS test?
pharmaversesdtm::vs |>
  filter(USUBJID == "01-702-1082", as.Date(VSDTC) <= trtsdt) |>
  count(VISIT, VSTESTCD)
