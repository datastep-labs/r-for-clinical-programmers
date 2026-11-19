# Answer 9-1: the duration of treatment in days. The first day counts, so add 1
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  mutate(TRTDURD = as.numeric(TRTEDT - TRTSDT) + 1)

adsl |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, TRTSDT, TRTEDT, TRTDURD)

summary(adsl$TRTDURD)
