# Answer 13-4: the percents where round() and round_half_up() differ
library(dplyr)
library(tidyr)
options(width = 90) # the table is wider than 80 characters

round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}

saf <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adsl <- bind_rows(saf, mutate(saf, TRT01A = "Total"))

adsl |>
  select(TRT01A, AGEGR1, SEX, RACE) |>
  pivot_longer(-TRT01A, names_to = "variable", values_to = "value") |>
  count(TRT01A, variable, value) |>
  group_by(TRT01A, variable) |>
  mutate(N = sum(n)) |>
  ungroup() |>
  mutate(
    pct = 100 * n / N,
    r = sprintf("%.1f", round(pct, 1)),
    half_up = sprintf("%.1f", round_half_up(pct, 1))
  ) |>
  filter(r != half_up)
