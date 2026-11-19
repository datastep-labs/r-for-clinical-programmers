# Answer 22-2: the two typos of 22_2_typo.R, fixed
library(dplyr)

adsl_saf <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

adsl_saf |>
  group_by(TRT01A) |>
  summarise(subjects = n_distinct(USUBJID))

nrow(adsl_saf)
