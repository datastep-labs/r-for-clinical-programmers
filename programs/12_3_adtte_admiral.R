# Chapter 12: the same ADTTE with admiral: an event, a censoring, one call
library(dplyr)
library(admiral)

adsl <- readRDS("data/adsl.rds") |>
  filter(SAFFL == "Y")
adae <- readRDS("data/adae.rds") |>
  mutate(
    CQ01NAM = if_else(
      grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", AEDECOD) |
        (AEBODSYS == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
          !AEDECOD %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA")),
      "DERMATOLOGIC EVENTS", NA
    )
  )

derm_event <- event_source(
  dataset_name = "adae",
  filter = TRTEMFL == "Y" & CQ01NAM == "DERMATOLOGIC EVENTS",
  date = ASTDT,
  order = exprs(AESEQ),
  set_values_to = exprs(
    EVNTDESC = "Dermatologic event",
    SRCDOM = "ADAE", SRCVAR = "ASTDT", SRCSEQ = AESEQ
  )
)
end_of_study <- censor_source(
  dataset_name = "adsl",
  date = RFENDT,
  set_values_to = exprs(
    EVNTDESC = "Study completion date", SRCDOM = "ADSL", SRCVAR = "RFENDT"
  )
)

adtte <- derive_param_tte(
  dataset_adsl = adsl,
  start_date = TRTSDT,
  event_conditions = list(derm_event),
  censor_conditions = list(end_of_study),
  source_datasets = list(adsl = adsl, adae = adae),
  set_values_to = exprs(
    PARAMCD = "TTDE", PARAM = "Time to First Dermatologic Event"
  )
) |>
  derive_vars_duration(new_var = AVAL, start_date = STARTDT, end_date = ADT) |>
  select(
    STUDYID, USUBJID, PARAMCD, PARAM, STARTDT, ADT, AVAL, CNSR, EVNTDESC,
    SRCDOM, SRCVAR, SRCSEQ
  )

adtte |>
  count(CNSR, EVNTDESC)

saveRDS(adtte, "data/adtte.rds")
