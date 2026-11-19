# Answer 2-4: count the adverse events by severity, in clinical order
library(dplyr)

pharmaversesdtm::ae |>
  mutate(AESEV = factor(AESEV, levels = c("MILD", "MODERATE", "SEVERE"))) |>
  count(AESEV)
