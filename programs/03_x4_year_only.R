# Answer 3-4: the subjects with an AE start date that has only the year
library(dplyr)
library(stringr)

pharmaversesdtm::ae |>
  filter(str_detect(AESTDTC, "^\\d{4}$")) |>
  distinct(USUBJID) |>
  nrow()
