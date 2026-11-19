# Chapter 6: summary statistics per group with summarise()
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  group_by(TRT01A) |>
  summarise(
    n = n(),
    mean = round(mean(AGE), 1),
    sd = round(sd(AGE), 1),
    median = median(AGE),
    q1 = quantile(AGE, 0.25),
    q3 = quantile(AGE, 0.75),
    min = min(AGE),
    max = max(AGE)
  )

# one missing value makes the mean missing, unless you say na.rm = TRUE
pharmaversesdtm::vs |>
  filter(VSTESTCD == "PULSE", VISIT == "WEEK 2") |>
  summarise(
    n = n(),
    n_missing = sum(is.na(VSSTRESN)),
    mean = mean(VSSTRESN),
    mean_known = round(mean(VSSTRESN, na.rm = TRUE), 1)
  )
