# Answer 10-4: ABLFL without the filter of restrict_derivation()
library(dplyr)
library(admiral)

advs <- readRDS("data/advs.rds") |>
  filter(PARAMCD == "WEIGHT") |>
  select(-ABLFL) |>
  derive_var_extreme_flag(
    by_vars = exprs(USUBJID, PARAMCD, ATPTN), order = exprs(ADT, VSSEQ),
    new_var = ABLFL, mode = "last"
  )

advs |>
  filter(ABLFL == "Y") |>
  count(VISIT)
