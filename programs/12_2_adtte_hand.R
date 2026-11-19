# Chapter 12: ADTTE by hand: time to the first dermatologic event, or censoring
library(dplyr)

is_derm <- function(aedecod, aebodsys) {
  grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", aedecod) |
    (aebodsys == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
      !aedecod %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA"))
}

adsl <- readRDS("data/adsl.rds") |>
  filter(SAFFL == "Y") |>
  select(STUDYID, USUBJID, TRTSDT, RFENDT)

# Step 010: the first treatment-emergent dermatologic event of each subject
first_derm <- readRDS("data/adae.rds") |>
  filter(TRTEMFL == "Y", is_derm(AEDECOD, AEBODSYS)) |>
  arrange(USUBJID, ASTDT, AESEQ) |>
  slice_head(n = 1, by = USUBJID) |>
  select(USUBJID, ASTDT, AESEQ)

# Step 020: one row per subject. Start from ADSL, so no subject is lost
adtte_hand <- adsl |>
  left_join(first_derm, by = join_by(USUBJID), relationship = "one-to-one") |>
  mutate(
    PARAMCD = "TTDE", PARAM = "Time to First Dermatologic Event",
    STARTDT = TRTSDT,
    event = !is.na(ASTDT),
    ADT = if_else(event, ASTDT, RFENDT),
    CNSR = if_else(event, 0L, 1L),
    EVNTDESC = if_else(event, "Dermatologic event", "Study completion date"),
    SRCDOM = if_else(event, "ADAE", "ADSL"),
    SRCVAR = if_else(event, "ASTDT", "RFENDT"),
    SRCSEQ = if_else(event, AESEQ, NA)
  ) |>
  # Step 030: AVAL in days. The first day counts: an event on the day of the
  # first dose has AVAL = 1
  mutate(AVAL = as.numeric(ADT - STARTDT) + 1) |>
  select(
    STUDYID, USUBJID, PARAMCD, PARAM, STARTDT, ADT, AVAL, CNSR, EVNTDESC,
    SRCDOM, SRCVAR, SRCSEQ
  )

adtte_hand |>
  count(CNSR, EVNTDESC)

adtte_hand |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1033")) |>
  select(USUBJID, STARTDT, ADT, AVAL, CNSR, SRCVAR)

saveRDS(adtte_hand, "data/adtte_hand.rds")
