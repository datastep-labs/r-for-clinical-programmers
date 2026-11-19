# Chapter 4: carry the baseline value to every row of the subject, then compute the change
library(dplyr)

wt <- pharmaversesdtm::vs |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023"), VSTESTCD == "WEIGHT") |>
  select(USUBJID, VISITNUM, VISIT, VSBLFL, VSSTRESN) |>
  arrange(USUBJID, VISITNUM)

wt$VSBLFL[1:3] == "Y"
wt$VSSTRESN[1:3][wt$VSBLFL[1:3] == "Y"]

wt |>
  group_by(USUBJID) |>
  mutate(
    BASE = VSSTRESN[VSBLFL %in% "Y"],
    BASEVIS = VISITNUM[VSBLFL %in% "Y"],
    CHG = if_else(VISITNUM > BASEVIS, VSSTRESN - BASE, NA)
  ) |>
  ungroup() |>
  select(-BASEVIS) |>
  print(n = 5)
