# Answer 13-3: the three system organ classes with the most subjects
library(dplyr)

pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y") |>
  distinct(AEBODSYS, USUBJID) |>
  count(AEBODSYS, sort = TRUE) |>
  head(3)
