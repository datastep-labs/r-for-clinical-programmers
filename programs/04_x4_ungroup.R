# Answer 4-4: drop the groups after summarise(), so the percent is of all 254 subjects
library(dplyr)

pct <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  group_by(ARM, SEX) |>
  summarise(n = n(), .groups = "drop") |>
  mutate(PCT = round(100 * n / sum(n), 1))
pct

sum(pct$n)
sum(pct$PCT)
