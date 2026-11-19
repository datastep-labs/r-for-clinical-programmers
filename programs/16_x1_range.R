# Answer 16-1: check 9, weights outside a plausible range
library(dplyr)

weight <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT")

range(weight$VSSTRESN)
weight |>
  filter(VSSTRESN < 30 | VSSTRESN > 200) |>
  nrow()
