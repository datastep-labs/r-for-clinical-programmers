# Chapter 12: the event of the pilot TTE parameter: a dermatologic adverse event
library(dplyr)

# The specification of the customized query CQ01, "DERMATOLOGIC EVENTS"
is_derm <- function(aedecod, aebodsys) {
  grepl("APPLICATION|DERMATITIS|ERYTHEMA|BLISTER", aedecod) |
    (aebodsys == "SKIN AND SUBCUTANEOUS TISSUE DISORDERS" &
      !aedecod %in% c("COLD SWEAT", "HYPERHIDROSIS", "ALOPECIA"))
}

derm <- readRDS("data/adae.rds") |>
  filter(is_derm(AEDECOD, AEBODSYS))

derm |>
  summarise(events = n(), subjects = n_distinct(USUBJID), .by = TRTEMFL)

derm |>
  count(AEDECOD, sort = TRUE) |>
  print(n = 5)

derm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AESEQ, AEDECOD, ASTDT, TRTEMFL)
