# Answer 1-1: count the women and men among the randomised subjects
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  count(SEX)
