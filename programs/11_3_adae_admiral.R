# Chapter 11: the same ADAE with admiral
library(dplyr)
library(admiral)

adsl <- readRDS("data/adsl.rds")

adae <- pharmaversesdtm::ae |>
  select(
    STUDYID, USUBJID, AESEQ, AETERM, AEDECOD, AEBODSYS, AESEV, AESER, AESTDTC,
    AEENDTC
  ) |>
  derive_vars_merged(
    dataset_add = adsl, by_vars = exprs(USUBJID),
    new_vars = exprs(TRTSDT, TRTEDT, TRTA = TRT01A)
  ) |>
  # impute a missing day or month to the first; never before the first dose
  # when the first dose is in the known part (min_dates)
  derive_vars_dt(
    dtc = AESTDTC, new_vars_prefix = "AST", highest_imputation = "M",
    date_imputation = "first", min_dates = exprs(TRTSDT)
  ) |>
  derive_vars_dt(dtc = AEENDTC, new_vars_prefix = "AEN") |>
  derive_vars_dy(reference_date = TRTSDT, source_vars = exprs(ASTDT)) |>
  derive_var_trtemfl(
    start_date = ASTDT, end_date = AENDT, trt_start_date = TRTSDT
  ) |>
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = exprs(USUBJID), order = exprs(ASTDT, AESEQ),
      new_var = AOCCFL, mode = "first"
    ),
    filter = TRTEMFL == "Y"
  ) |>
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = exprs(USUBJID, AEBODSYS), order = exprs(ASTDT, AESEQ),
      new_var = AOCCSFL, mode = "first"
    ),
    filter = TRTEMFL == "Y"
  ) |>
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = exprs(USUBJID, AEBODSYS, AEDECOD), order = exprs(ASTDT, AESEQ),
      new_var = AOCCPFL, mode = "first"
    ),
    filter = TRTEMFL == "Y"
  ) |>
  arrange(USUBJID, AESEQ)

dim(adae)
saveRDS(adae, "data/adae.rds")
