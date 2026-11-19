# Chapter 4: distinct() keeps one row per key. Look at what it removes
library(dplyr)

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AESEQ, AEDECOD, AESEV, AESTDTC)
nrow(ae)

ae_pt <- ae |> distinct(USUBJID, AEDECOD)
nrow(ae_pt)

ae_dups <- ae |> filter(duplicated(pick(USUBJID, AEDECOD)))
nrow(ae_dups)

ae |>
  arrange(USUBJID, AEDECOD, AESTDTC, AESEQ) |>
  distinct(USUBJID, AEDECOD, .keep_all = TRUE) |>
  filter(USUBJID == "01-701-1023")
