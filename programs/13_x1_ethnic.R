# Answer 13-1: the ethnicity section of the demographics table
library(dplyr)
library(tidyr)

round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}
n_pct <- function(n, N) sprintf("%d (%.1f%%)", n, round_half_up(100 * n / N, 1))

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose", "Total" = "Total"
)
saf <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adsl <- bind_rows(saf, mutate(saf, TRT01A = "Total")) |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))
bign <- count(adsl, TRT, name = "N")

adsl |>
  count(TRT, label = ETHNIC) |>
  complete(TRT, label, fill = list(n = 0)) |>
  left_join(bign, by = "TRT") |>
  mutate(value = n_pct(n, N)) |>
  select(label, TRT, value) |>
  pivot_wider(names_from = TRT, values_from = value)
