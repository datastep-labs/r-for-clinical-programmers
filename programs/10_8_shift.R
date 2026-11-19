# Chapter 10: a shift table for ALT, from the baseline range to the worst range
library(dplyr)

adlb <- readRDS("data/adlb.rds")

# the worst ANRIND of each subject after baseline: HIGH before LOW before NORMAL
worst <- adlb |>
  filter(PARAMCD == "ALT", AVISITN > 0, !is.na(ANRIND)) |>
  summarise(
    BNRIND = first(BNRIND),
    WORST = case_when(
      any(ANRIND == "HIGH") ~ "HIGH",
      any(ANRIND == "LOW") ~ "LOW",
      .default = "NORMAL"
    ),
    .by = USUBJID
  )

worst |>
  filter(USUBJID == "01-701-1015")

worst |>
  count(BNRIND, WORST) |>
  tidyr::pivot_wider(names_from = WORST, values_from = n, values_fill = 0) |>
  select(BNRIND, LOW, NORMAL, HIGH)
