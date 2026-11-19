# Chapter 13: the adverse event table with gtsummary::tbl_hierarchical()
library(dplyr)
library(gtsummary)

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose"
)
adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))
teae <- pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))

ae <- teae |>
  tbl_hierarchical(
    variables = c(AEBODSYS, AEDECOD),
    by = TRT,
    id = USUBJID, # count subjects, not records
    denominator = adsl, # percent of the big N
    overall_row = TRUE,
    statistic = everything() ~ "{n} ({p}%)",
    digits = everything() ~ list(n = 0, p = 1),
    label = list(..ard_hierarchical_overall.. = "ANY TEAE")
  ) |>
  add_overall(last = TRUE) |>
  sort_hierarchical()
saveRDS(ae, "output/t_ae_gts.rds")

options(width = 90)
ae |>
  as_tibble(col_labels = FALSE) |>
  mutate(label = stringr::str_trunc(label, 40)) |>
  head(10) |>
  as.data.frame() |>
  print(right = FALSE, row.names = FALSE)
