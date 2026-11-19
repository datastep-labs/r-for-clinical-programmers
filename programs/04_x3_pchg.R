# Answer 4-3: percent change from baseline weight. Divide only when the baseline is there and not 0
library(dplyr)

pharmaversesdtm::vs |>
  filter(USUBJID == "01-701-1015", VSTESTCD == "WEIGHT") |>
  arrange(VISITNUM) |>
  mutate(
    BASE = VSSTRESN[VSBLFL %in% "Y"],
    BASEVIS = VISITNUM[VSBLFL %in% "Y"],
    CHG = if_else(VISITNUM > BASEVIS, VSSTRESN - BASE, NA),
    PCHG = if_else(!is.na(BASE) & BASE != 0, round(100 * CHG / BASE, 2), NA),
    .by = USUBJID
  ) |>
  select(VISIT, VSSTRESN, BASE, CHG, PCHG) |>
  print(n = 4)
