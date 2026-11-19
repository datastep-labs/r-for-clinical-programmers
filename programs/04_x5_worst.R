# Answer 4-5: the worst severity of each subject, then the subjects per worst severity
library(dplyr)

pharmaversesdtm::ae |>
  mutate(SEVN = match(AESEV, c("MILD", "MODERATE", "SEVERE"))) |>
  summarise(WORST = max(SEVN), .by = USUBJID) |>
  count(WORST)
