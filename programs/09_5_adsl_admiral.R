# Chapter 9: the same ADSL with admiral. Each derive_*() call is one step of the chain
library(dplyr)
library(admiral)

dm <- pharmaversesdtm::dm
ds <- pharmaversesdtm::ds
suppdm <- pharmaversesdtm::suppdm
ex <- pharmaversesdtm::ex |>
  derive_vars_dt(dtc = EXSTDTC, new_vars_prefix = "EXST") |>
  derive_vars_dt(dtc = EXENDTC, new_vars_prefix = "EXEN")

dose_of <- function(arm) {
  case_when(
    arm == "Placebo" ~ 0,
    arm == "Xanomeline Low Dose" ~ 54,
    arm == "Xanomeline High Dose" ~ 81
  )
}

adsl <- dm |>
  filter(ARMCD != "Scrnfail") |>
  select(
    STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEU, SEX, RACE, ETHNIC,
    ARM, ACTARM, RFSTDTC, RFENDTC
  ) |>
  mutate(
    TRT01P = ARM, TRT01PN = dose_of(ARM),
    TRT01A = ACTARM, TRT01AN = dose_of(ACTARM)
  ) |>
  # TRTSDT: the first EX record by start date
  derive_vars_merged(
    dataset_add = ex, by_vars = exprs(USUBJID),
    new_vars = exprs(TRTSDT = EXSTDT),
    order = exprs(EXSTDT, EXSEQ), mode = "first"
  ) |>
  # TRTEDT: the last EX end date, or RFENDTC when a record is open
  derive_vars_merged(
    dataset_add = ex, by_vars = exprs(USUBJID), filter_add = !is.na(EXENDT),
    new_vars = exprs(TRTEDT = EXENDT),
    order = exprs(EXENDT, EXSEQ), mode = "last"
  ) |>
  derive_var_merged_exist_flag(
    dataset_add = ex, by_vars = exprs(USUBJID),
    new_var = OPENFL, condition = is.na(EXENDT)
  ) |>
  mutate(
    TRTEDT = if_else(OPENFL %in% "Y", convert_dtc_to_dt(RFENDTC), TRTEDT)
  ) |>
  select(-OPENFL) |>
  # the population flags: Y when SUPPDM has the record, else N
  derive_var_merged_exist_flag(
    dataset_add = suppdm, by_vars = exprs(USUBJID), new_var = SAFFL,
    condition = QNAM == "SAFETY" & QVAL == "Y",
    false_value = "N", missing_value = "N"
  ) |>
  derive_var_merged_exist_flag(
    dataset_add = suppdm, by_vars = exprs(USUBJID), new_var = ITTFL,
    condition = QNAM == "ITT" & QVAL == "Y",
    false_value = "N", missing_value = "N"
  ) |>
  derive_var_merged_exist_flag(
    dataset_add = suppdm, by_vars = exprs(USUBJID), new_var = EFFFL,
    condition = QNAM == "EFFICACY" & QVAL == "Y",
    false_value = "N", missing_value = "N"
  ) |>
  derive_var_merged_exist_flag(
    dataset_add = suppdm, by_vars = exprs(USUBJID), new_var = COMP24FL,
    condition = QNAM == "COMPLT24" & QVAL == "Y",
    false_value = "N", missing_value = "N"
  ) |>
  # end of study status and reason, from the disposition event of DS
  derive_vars_merged(
    dataset_add = ds, by_vars = exprs(USUBJID),
    filter_add = DSCAT == "DISPOSITION EVENT",
    new_vars = exprs(
      EOSSTT = if_else(DSDECOD == "COMPLETED", "COMPLETED", "DISCONTINUED"),
      DCSREAS = if_else(DSDECOD == "COMPLETED", NA, DSDECOD)
    )
  ) |>
  mutate(
    AGEGR1 = case_when(AGE < 65 ~ "<65", AGE <= 80 ~ "65-80", AGE > 80 ~ ">80"),
    RFENDT = convert_dtc_to_dt(RFENDTC)
  )

dim(adsl)
saveRDS(adsl, "data/adsl.rds")
