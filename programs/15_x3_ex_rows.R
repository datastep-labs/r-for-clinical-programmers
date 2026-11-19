# Answer 15-3: the EX rows of the six subjects behind the TRTEDT differences
library(dplyr)

ours <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTEDT)
ref <- pharmaverseadam::adsl |>
  select(USUBJID, TRTEDT_REF = TRTEDT)

six <- inner_join(ours, ref, by = join_by(USUBJID)) |>
  filter(!TRTEDT %in% TRTEDT_REF | is.na(TRTEDT_REF)) |>
  pull(USUBJID) |>
  as.character()
six

pharmaversesdtm::ex |>
  filter(USUBJID %in% six) |>
  select(USUBJID, EXSEQ, EXSTDTC, EXENDTC) |>
  print(n = 30)
