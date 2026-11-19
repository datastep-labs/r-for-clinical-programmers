# Chapter 14: a Kaplan-Meier plot with the number of subjects at risk
library(dplyr)
library(ggsurvfit)

ttde <- readRDS("output/ttde.rds") # made by 14_4

km <- survfit2(Surv(AVAL, 1 - CNSR) ~ TRT, data = ttde)

# the numbers under the plot: subjects at risk at day 0, 30, 60, ...
tidy_survfit(km, times = seq(0, 180, by = 30)) |>
  select(strata, time, n.risk) |>
  tidyr::pivot_wider(names_from = strata, values_from = n.risk)

ggsurvfit(km) +
  add_censor_mark() +
  add_risktable(times = seq(0, 180, by = 30), risktable_stats = "n.risk") +
  scale_x_continuous(breaks = seq(0, 180, by = 30)) +
  labs(
    title = "Time to first dermatologic event (safety population)",
    x = "Days since first dose", y = "Probability without event"
  ) +
  theme(legend.position = "bottom")
