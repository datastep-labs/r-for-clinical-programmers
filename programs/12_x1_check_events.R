# Answer 12-1: check the event source before you trust AVAL
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, RFENDT)

derm <- readRDS("data/adae.rds") |>
  filter(
    TRTEMFL == "Y",
    grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", AEDECOD) |
      (AEBODSYS == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
        !AEDECOD %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA"))
  ) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one")

derm |>
  summarise(
    events = n(),
    no_start_date = sum(is.na(ASTDT)),
    imputed_start = sum(!is.na(ASTDTF)),
    after_end_of_study = sum(ASTDT > RFENDT)
  )
