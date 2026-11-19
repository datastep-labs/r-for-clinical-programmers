# Answer 14-3: the placebo subjects at risk at day 90, counted from the data
library(dplyr)

ttde <- readRDS("output/ttde.rds") # made by 14_4

# at risk at day 90: no event and not censored before day 90
ttde |>
  filter(TRT == "Placebo") |>
  summarise(at_risk_90 = sum(AVAL >= 90))
