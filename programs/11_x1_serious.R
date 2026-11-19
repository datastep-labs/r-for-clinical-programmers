# Answer 11-1: subjects with a treatment-emergent serious event, two ways
library(dplyr)

adae <- readRDS("data/adae.rds")

# count each subject once
adae |>
  filter(TRTEMFL == "Y", AESER == "Y") |>
  summarise(subjects = n_distinct(USUBJID))

# AOCCFL marks the first event of a subject, serious or not
adae |>
  filter(AOCCFL == "Y", AESER == "Y") |>
  nrow()
