# Chapter 14: time to the first dermatologic event, and its median
library(dplyr)
library(survival)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(TRT = factor(
    TRT01A, c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
  ))

# the event: the first treatment-emergent AE of the dermatologic query
first_derm <- pharmaverseadam::adae |>
  filter(
    TRTEMFL == "Y",
    grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", AEDECOD) |
      (AEBODSYS == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
        !AEDECOD %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA"))
  ) |>
  group_by(USUBJID) |>
  summarise(EVNTDT = min(ASTDT))

# no event: censored at the end of study. AVAL in days from the first dose
ttde <- adsl |>
  left_join(first_derm, by = "USUBJID") |>
  mutate(
    CNSR = if_else(is.na(EVNTDT), 1, 0),
    ADT = coalesce(EVNTDT, EOSDT),
    AVAL = as.numeric(ADT - TRTSDT) + 1
  ) |>
  select(USUBJID, TRT, TRTSDT, ADT, AVAL, CNSR)
saveRDS(ttde, "output/ttde.rds")

ttde |> filter(USUBJID == "01-701-1015")
ttde |> count(TRT, event = CNSR == 0)

# Kaplan-Meier: Surv() wants the event as 1, so give it 1 - CNSR
km <- survfit(Surv(AVAL, 1 - CNSR) ~ TRT, data = ttde)
km
