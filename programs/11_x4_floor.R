# Answer 11-4: a start date "2013-03" and a first dose on 18 March 2013
library(dplyr)
library(admiral)

cases <- tibble(
  USUBJID = c("A", "B"),
  AESTDTC = c("2013-03", "2013-02"),
  TRTSDT = as.Date(c("2013-03-18", "2013-03-18"))
)

cases |>
  derive_vars_dt(
    dtc = AESTDTC, new_vars_prefix = "AST", highest_imputation = "M",
    date_imputation = "first", min_dates = exprs(TRTSDT)
  ) |>
  mutate(TRTEMFL = if_else(ASTDT >= TRTSDT, "Y", NA))
