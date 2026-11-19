# Answer 10-2: CHG on every row that has AVAL and BASE, also before and at baseline
library(dplyr)

advs <- readRDS("data/advs.rds") |>
  filter(PARAMCD == "WEIGHT") |>
  mutate(CHG_ALL = AVAL - BASE)

advs |>
  summarise(
    chg_after_baseline = sum(!is.na(CHG)),
    chg_every_row = sum(!is.na(CHG_ALL))
  )

advs |>
  filter(USUBJID == "01-701-1015") |>
  select(VISIT, AVAL, BASE, CHG, CHG_ALL) |>
  print(n = 3)
