# Chapter 4: tidyr::fill() carries the last observation forward (LOCF), with a flag
library(dplyr)
library(tidyr)

pharmaversesdtm::vs |>
  filter(
    USUBJID == "01-703-1279", VSTESTCD == "SYSBP",
    VSTPT == "AFTER STANDING FOR 3 MINUTES"
  ) |>
  select(USUBJID, VISITNUM, VISIT, VSSTRESN) |>
  arrange(USUBJID, VISITNUM) |>
  mutate(AVAL = VSSTRESN, DTYPE = if_else(is.na(AVAL), "LOCF", NA)) |>
  group_by(USUBJID) |>
  fill(AVAL, .direction = "down") |>
  ungroup()
