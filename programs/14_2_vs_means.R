# Chapter 14: the numbers of a figure: mean change in weight per visit
library(dplyr)

weight <- pharmaverseadam::advs |>
  filter(SAFFL == "Y", PARAMCD == "WEIGHT", ANL01FL == "Y", AVISITN %in% 2:26)

# one record per subject and visit? not here: check before you take a mean
weight |>
  count(USUBJID, AVISITN) |>
  count(records = n)
weight |>
  filter(USUBJID == "01-701-1015", AVISITN == 2) |>
  select(USUBJID, AVISIT, AVAL, CHG, DTYPE)

# DTYPE = "AVERAGE" is a derived copy of the same value: keep the collected one
means <- weight |>
  filter(is.na(DTYPE)) |>
  group_by(TRTA, AVISITN) |>
  summarise(
    n = n(), mean = mean(CHG), se = sd(CHG) / sqrt(n()),
    .groups = "drop"
  )
saveRDS(means, "output/vs_means.rds")

means |>
  filter(AVISITN == 24) |>
  mutate(across(c(mean, se), \(x) round(x, 2)))
