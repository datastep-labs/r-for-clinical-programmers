# Chapter 13: the big N, the number of subjects in each column of a table
library(dplyr)

saf <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

# randomised to one arm, treated with another: 12 subjects
saf |>
  count(ARM, TRT01A)

# the columns of the table: short names for the actual treatments, and a Total
cols <- c(
  "Placebo" = "Placebo",
  "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose",
  "Total" = "Total"
)

# Total: every subject a second time, with the treatment "Total"
adsl <- bind_rows(saf, mutate(saf, TRT01A = "Total")) |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))

bign <- adsl |>
  count(TRT, name = "N") |>
  mutate(header = paste0(TRT, " (N=", N, ")"))
bign

adsl |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, ARM, TRT01A, TRT)
