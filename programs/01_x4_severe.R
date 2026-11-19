# Answer 1-4: subjects with a severe treatment-emergent adverse event, per arm
library(dplyr)

pharmaverseadam::adae |>
  filter(TRTEMFL == "Y", AESEV == "SEVERE") |>
  group_by(TRT01A) |>
  summarise(
    records = n(),
    subjects = n_distinct(USUBJID)
  )
