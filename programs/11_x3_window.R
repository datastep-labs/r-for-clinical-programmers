# Answer 11-3: the reference rule, with a window of 30 days after the last dose
library(dplyr)
library(admiral)

adae <- readRDS("data/adae.rds") |>
  derive_var_trtemfl(
    new_var = TRTEM30FL, start_date = ASTDT, end_date = AENDT,
    trt_start_date = TRTSDT, trt_end_date = TRTEDT, end_window = 30
  )

adae |>
  count(TRTEMFL, TRTEM30FL)
