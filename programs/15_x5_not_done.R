# Answer 15-5: the AVAL rule, written as the data needs it
library(dplyr)

advs <- readRDS("data/advs.rds") |>
  left_join(
    pharmaversesdtm::vs |> select(USUBJID, VSSEQ, VSSTAT),
    by = join_by(USUBJID, VSSEQ)
  )

# AVAL may be missing only when the test was not done, and then must be
advs |>
  summarise(
    missing_not_explained = sum(is.na(AVAL) & !VSSTAT %in% "NOT DONE"),
    not_done_with_value = sum(!is.na(AVAL) & VSSTAT %in% "NOT DONE")
  )
