# Chapter 4: lag() and lead() read the value of the previous or the next row
library(dplyr)

pharmaversesdtm::vs |>
  filter(USUBJID == "01-701-1015", VSTESTCD == "WEIGHT") |>
  arrange(VISITNUM) |>
  select(VISIT, VSSTRESN) |>
  mutate(
    PREV = lag(VSSTRESN),
    NEXT = lead(VSSTRESN),
    CHG_PREV = VSSTRESN - PREV
  ) |>
  print(n = 4)
