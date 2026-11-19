# Chapter 10: the same ADLB with admiral
library(dplyr)
library(admiral)

adsl <- readRDS("data/adsl.rds")

adlb <- pharmaversesdtm::lb |>
  filter(LBCAT == "CHEMISTRY") |>
  derive_vars_merged(
    dataset_add = adsl, by_vars = exprs(USUBJID), new_vars = exprs(TRTSDT)
  ) |>
  derive_vars_dt(dtc = LBDTC, new_vars_prefix = "A") |>
  derive_vars_dy(reference_date = TRTSDT, source_vars = exprs(ADT)) |>
  mutate(
    PARAMCD = LBTESTCD, PARAM = LBTEST, AVAL = LBSTRESN,
    week = startsWith(VISIT, "WEEK"),
    AVISIT = if_else(week, stringr::str_to_title(VISIT), NA),
    AVISITN = if_else(
      week, as.numeric(stringr::str_extract(VISIT, "[0-9]+")), NA
    ),
    ANRLO = LBSTNRLO, ANRHI = LBSTNRHI
  ) |>
  derive_var_anrind() |>
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = exprs(USUBJID, PARAMCD), order = exprs(ADT, LBSEQ),
      new_var = ABLFL, mode = "last"
    ),
    filter = !is.na(AVAL) & ADT <= TRTSDT
  ) |>
  derive_var_base(
    by_vars = exprs(USUBJID, PARAMCD), source_var = AVAL, new_var = BASE
  ) |>
  derive_var_base(
    by_vars = exprs(USUBJID, PARAMCD), source_var = ANRIND, new_var = BNRIND
  ) |>
  restrict_derivation(derivation = derive_var_chg, filter = AVISITN > 0) |>
  restrict_derivation(derivation = derive_var_pchg, filter = AVISITN > 0) |>
  select(
    STUDYID, USUBJID, LBSEQ, PARAMCD, PARAM, VISIT, AVISIT, AVISITN, ADT, ADY,
    TRTSDT, AVAL, ANRLO, ANRHI, ANRIND, ABLFL, BASE, BNRIND, CHG, PCHG
  ) |>
  arrange(USUBJID, PARAMCD, ADT, LBSEQ)

dim(adlb)
saveRDS(adlb, "data/adlb.rds")
