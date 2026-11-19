# Chapter 2: filter(), select(), mutate() and arrange(), joined by the pipe
library(dplyr)

dm <- pharmaversesdtm::dm
nrow(dm)

dm_rand <- dm |>
  filter(ARMCD != "Scrnfail") |>
  select(USUBJID, SITEID, AGE, SEX, ARM)
nrow(dm_rand)

dm_rand |>
  filter(SITEID == "701", SEX == "F") |>
  mutate(AGE_MONTHS = AGE * 12) |>
  arrange(desc(AGE)) |>
  print(n = 5)
