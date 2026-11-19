# Answer 10-1: ANL01FL, one analysis row per subject, parameter, position, visit
library(dplyr)

advs <- readRDS("data/advs.rds")

advs_anl <- advs |>
  arrange(USUBJID, PARAMCD, ATPTN, AVISITN, ADT, VSSEQ) |>
  mutate(
    ANL01FL = if_else(!is.na(AVISITN) & row_number() == n(), "Y", NA),
    .by = c(USUBJID, PARAMCD, ATPTN, AVISITN)
  )

# the groups with more than one row at an analysis visit
advs_anl |>
  filter(!is.na(AVISITN)) |>
  count(USUBJID, PARAMCD, ATPTN, AVISIT) |>
  filter(n > 1)

advs_anl |>
  count(PARAMCD, ANL01FL)
