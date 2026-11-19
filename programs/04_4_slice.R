# Chapter 4: slice_head() and slice_max() keep chosen rows of each group. Watch the ties
library(dplyr)

ae <- pharmaversesdtm::ae |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023")) |>
  mutate(SEVN = match(AESEV, c("MILD", "MODERATE", "SEVERE"))) |>
  select(USUBJID, AESEQ, AEDECOD, AESEV, SEVN, AESTDTC)

ae |>
  arrange(USUBJID, AESTDTC, AESEQ) |>
  slice_head(n = 1, by = USUBJID)

ae |> slice_max(SEVN, n = 1, by = USUBJID)

ae |> slice_max(SEVN, n = 1, by = USUBJID, with_ties = FALSE)
