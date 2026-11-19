# Answer 2-1: keep only the placebo subjects of DM
library(dplyr)

pharmaversesdtm::dm |>
  filter(ARM == "Placebo") |>
  nrow()
