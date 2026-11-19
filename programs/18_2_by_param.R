# Chapter 18: one summary per parameter. split() makes a list, map() works on each
library(dplyr)
library(purrr)

# Baseline rows; blood pressure and pulse in one position (lying down)
bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815)

by_param <- split(bl, bl$PARAMCD)
length(by_param)
names(by_param)

summ <- function(data) {
  data |>
    summarise(
      n = n(), mean = round(mean(AVAL), 1), sd = round(sd(AVAL), 2),
      .by = TRT01P
    ) |>
    arrange(TRT01P)
}
tables <- map(by_param, summ)
tables$DIABP

# When one table is enough, group_by() does the same without a list
bl |>
  filter(PARAMCD %in% c("DIABP", "SYSBP")) |>
  summarise(n = n(), mean = round(mean(AVAL), 1), .by = c(PARAMCD, TRT01P)) |>
  arrange(PARAMCD, TRT01P)
