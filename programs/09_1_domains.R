# Chapter 9: what one record of each SDTM domain means. Count the rows and the subjects
library(dplyr)

dm <- pharmaversesdtm::dm
ex <- pharmaversesdtm::ex
ds <- pharmaversesdtm::ds
suppdm <- pharmaversesdtm::suppdm
ae <- pharmaversesdtm::ae

tibble(
  domain = c("DM", "EX", "DS", "SUPPDM", "AE"),
  rows = c(nrow(dm), nrow(ex), nrow(ds), nrow(suppdm), nrow(ae)),
  subjects = c(
    n_distinct(dm$USUBJID), n_distinct(ex$USUBJID), n_distinct(ds$USUBJID),
    n_distinct(suppdm$USUBJID), n_distinct(ae$USUBJID)
  )
)

# --SEQ numbers the records of a subject, --DTC is a date as text,
# --DY is the study day
ae |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AESEQ, AEDECOD, AESTDTC, AESTDY)

ex |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, EXSEQ, EXTRT, EXDOSE, EXSTDTC, EXENDTC)
