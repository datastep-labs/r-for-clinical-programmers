# Answer 13-5: the TEAE table for severe events only, with tbl_hierarchical()
library(dplyr)
library(gtsummary)

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose"
)
adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))

pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y", AESEV == "SEVERE") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols))) |>
  tbl_hierarchical(
    variables = c(AEBODSYS, AEDECOD), by = TRT, id = USUBJID,
    denominator = adsl, overall_row = TRUE,
    label = list(..ard_hierarchical_overall.. = "ANY SEVERE TEAE")
  ) |>
  sort_hierarchical() |>
  as_tibble(col_labels = FALSE) |>
  mutate(label = stringr::str_trunc(label, 40)) |>
  head(4)
