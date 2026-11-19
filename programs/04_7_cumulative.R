# Chapter 4: cumsum() and cummax() give running values inside each subject
library(dplyr)

pharmaversesdtm::ae |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023")) |>
  mutate(SEVN = match(AESEV, c("MILD", "MODERATE", "SEVERE"))) |>
  select(USUBJID, AESEQ, AESEV, SEVN) |>
  arrange(USUBJID, AESEQ) |>
  mutate(
    N_SO_FAR = cumsum(SEVN >= 1),
    N_MOD_SO_FAR = cumsum(SEVN >= 2),
    WORST_SO_FAR = cummax(SEVN),
    .by = USUBJID
  )
