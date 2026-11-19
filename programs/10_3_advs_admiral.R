# Chapter 10: the same ADVS with admiral
library(dplyr)
library(admiral)

adsl <- readRDS("data/adsl.rds")
params <- tibble(
  VSTESTCD = c("SYSBP", "DIABP", "PULSE", "WEIGHT"),
  PARAMCD = c("SYSBP", "DIABP", "PULSE", "WEIGHT"),
  PARAM = c(
    "Systolic Blood Pressure (mmHg)", "Diastolic Blood Pressure (mmHg)",
    "Pulse Rate (beats/min)", "Weight (kg)"
  )
)

advs <- pharmaversesdtm::vs |>
  filter(VSTESTCD %in% params$VSTESTCD) |>
  derive_vars_merged(
    dataset_add = adsl, by_vars = exprs(USUBJID), new_vars = exprs(TRTSDT)
  ) |>
  derive_vars_merged_lookup(
    dataset_add = params, by_vars = exprs(VSTESTCD),
    new_vars = exprs(PARAMCD, PARAM)
  ) |>
  derive_vars_dt(dtc = VSDTC, new_vars_prefix = "A") |>
  derive_vars_dy(reference_date = TRTSDT, source_vars = exprs(ADT)) |>
  mutate(
    AVAL = VSSTRESN, ATPTN = VSTPTNUM, ATPT = VSTPT,
    AVISIT = case_when(
      VISIT == "BASELINE" ~ "Baseline",
      startsWith(VISIT, "WEEK") ~ stringr::str_to_title(VISIT)
    ),
    AVISITN = case_when(
      VISIT == "BASELINE" ~ 0,
      startsWith(VISIT, "WEEK") ~
        as.numeric(stringr::str_extract(VISIT, "[0-9]+"))
    )
  ) |>
  # ABLFL: the last row of each group among the rows that can be baseline
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = exprs(USUBJID, PARAMCD, ATPTN), order = exprs(ADT, VSSEQ),
      new_var = ABLFL, mode = "last"
    ),
    filter = !is.na(AVAL) & ADT <= TRTSDT
  ) |>
  derive_var_base(
    by_vars = exprs(USUBJID, PARAMCD, ATPTN), source_var = AVAL, new_var = BASE
  ) |>
  restrict_derivation(derivation = derive_var_chg, filter = AVISITN > 0) |>
  restrict_derivation(derivation = derive_var_pchg, filter = AVISITN > 0) |>
  select(
    STUDYID, USUBJID, VSSEQ, PARAMCD, PARAM, ATPTN, ATPT, VISIT, AVISIT,
    AVISITN, ADT, ADY, TRTSDT, AVAL, ABLFL, BASE, CHG, PCHG
  ) |>
  arrange(USUBJID, PARAMCD, ADT, ATPTN)

dim(advs)
saveRDS(advs, "data/advs.rds")
