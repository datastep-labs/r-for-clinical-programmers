# Answer 13-2: subjects with at least one serious TEAE, with the zeros
library(dplyr)
library(tidyr)

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose"
)
bign <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols))) |>
  count(TRT, name = "N")

pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y", AESER == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols))) |>
  distinct(TRT, USUBJID) |>
  count(TRT) |>
  complete(TRT, fill = list(n = 0)) |>
  left_join(bign, by = "TRT") |>
  mutate(pct = round(100 * n / N, 1))
