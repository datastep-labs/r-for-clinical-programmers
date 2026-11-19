# Chapter 13: a demographics table by hand: big N, compute, arrange, print
library(dplyr)
library(tidyr)

round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}
n_pct <- function(n, N) sprintf("%d (%.1f%%)", n, round_half_up(100 * n / N, 1))

# 1. population and big N (as in 13_1)
cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose", "Total" = "Total"
)
saf <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adsl <- bind_rows(saf, mutate(saf, TRT01A = "Total")) |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))
bign <- count(adsl, TRT, name = "N")

# 2. compute: age, four lines of text per column
age <- adsl |>
  group_by(TRT) |>
  summarise(
    n = as.character(n()),
    `Mean (SD)` = sprintf(
      "%.1f (%.2f)", round_half_up(mean(AGE), 1), round_half_up(sd(AGE), 2)
    ),
    Median = sprintf("%.1f", round_half_up(median(AGE), 1)),
    `Min, Max` = paste0(min(AGE), ", ", max(AGE))
  ) |>
  pivot_longer(-TRT, names_to = "label", values_to = "value") |>
  mutate(section = "Age (years)")

# 2. compute: age group, sex and race, subjects per value, percent of big N
# (factors give the order of the lines: text would sort ">64" before "18-64")
cats <- adsl |>
  transmute(
    TRT,
    `Age group` = factor(AGEGR1, c("18-64", ">64")),
    Sex = factor(SEX), Race = factor(RACE)
  ) |>
  pivot_longer(-TRT, names_to = "section", values_to = "label") |>
  count(TRT, section, label) |>
  complete(TRT, nesting(section, label), fill = list(n = 0)) |>
  left_join(bign, by = "TRT") |>
  mutate(value = n_pct(n, N))

# 3. arrange: one row per printed line, one column per treatment
layout <- bind_rows(age, cats) |>
  select(section, label, TRT, value) |>
  mutate(label = as.character(label)) |>
  pivot_wider(names_from = TRT, values_from = value) |>
  arrange(factor(section, c("Age (years)", "Age group", "Sex", "Race")))
saveRDS(layout, "output/t_demog.rds")

# 4. print: a heading line per section, the other lines indented
options(width = 90) # the table is 83 characters wide: keep it on one line
sections <- distinct(layout, section) |> mutate(label = section)
bind_rows(sections, mutate(layout, label = paste0("  ", label))) |>
  arrange(factor(section, unique(layout$section))) |>
  select(-section) |>
  as.data.frame() |>
  print(na.print = "", right = FALSE, row.names = FALSE)
