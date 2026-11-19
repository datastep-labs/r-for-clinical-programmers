# Answer 1-2: how many randomised subjects are older than 80?
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y", AGE > 80) |>
  count()
