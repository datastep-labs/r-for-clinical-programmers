# Chapter 4: group_by() and row_number() mark the first and the last row of each subject
library(dplyr)

ae <- pharmaversesdtm::ae |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023")) |>
  select(USUBJID, AESEQ, AEDECOD) |>
  arrange(USUBJID, AESEQ)

ae |>
  group_by(USUBJID) |>
  mutate(
    N_AE = row_number(),
    FIRST = row_number() == 1,
    LAST = row_number() == n()
  ) |>
  ungroup()

ae |>
  group_by(USUBJID) |>
  summarise(
    n_ae = n(),
    first_ae = first(AEDECOD),
    last_ae = last(AEDECOD)
  )
