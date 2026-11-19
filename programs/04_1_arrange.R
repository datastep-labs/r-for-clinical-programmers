# Chapter 4: arrange() sorts rows. NA goes last, and text sorts by its codes (upper case first)
library(dplyr)

ae <- pharmaversesdtm::ae |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023")) |>
  select(USUBJID, AESEQ, AEDECOD, AESTDTC, AEENDTC)
ae

ae |> arrange(USUBJID, AESEQ)
ae |> arrange(AEENDTC)
ae |> arrange(desc(AEENDTC))

letters4 <- tibble(X = c("b", "B", "a", "A"))
letters4 |> arrange(X) |> pull(X)
sort(letters4$X)
