# Answer 11-2: AOCCSFL marks one event per subject and system organ class
library(dplyr)

adae <- readRDS("data/adae.rds")

adae |>
  filter(AOCCSFL == "Y") |>
  nrow()

adae |>
  filter(TRTEMFL == "Y") |>
  distinct(USUBJID, AEBODSYS) |>
  nrow()
