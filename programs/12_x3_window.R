# Answer 12-3: the dermatologic events of the first 12 weeks (days 1 to 84)
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRTSDT, RFENDT) |>
  mutate(WEEK12DT = TRTSDT + 83)

# first the events inside the window, then the first one of them
first_derm <- readRDS("data/adae.rds") |>
  filter(
    TRTEMFL == "Y",
    grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", AEDECOD) |
      (AEBODSYS == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
        !AEDECOD %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA"))
  ) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one") |>
  filter(ASTDT <= WEEK12DT) |>
  arrange(USUBJID, ASTDT, AESEQ) |>
  slice_head(n = 1, by = USUBJID) |>
  select(USUBJID, ASTDT)

adtte12 <- adsl |>
  left_join(first_derm, by = join_by(USUBJID), relationship = "one-to-one") |>
  mutate(
    ADT = case_when(
      !is.na(ASTDT) ~ ASTDT,
      RFENDT <= WEEK12DT ~ RFENDT,
      .default = WEEK12DT
    ),
    CNSR = if_else(!is.na(ASTDT), 0L, 1L),
    EVNTDESC = case_when(
      !is.na(ASTDT) ~ "Dermatologic event",
      RFENDT <= WEEK12DT ~ "Study completion date",
      .default = "End of at-risk period"
    ),
    AVAL = as.numeric(ADT - TRTSDT) + 1
  )

adtte12 |>
  count(CNSR, EVNTDESC)

adtte12 |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1033", "01-705-1059")) |>
  select(USUBJID, TRTSDT, WEEK12DT, RFENDT, ADT, AVAL, CNSR)
