# Exercise 8-5: map() over the arms; the result agrees with group_by()
library(dplyr)
library(purrr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
arms <- sort(unique(adsl$TRT01A))

age_stats <- function(arm) {
  adsl |>
    filter(TRT01A == arm) |>
    summarise(TRT01A = arm, n = n(), mean = round(mean(AGE), 1))
}

by_map <- map(arms, age_stats) |> list_rbind()
by_map

by_group <- adsl |>
  group_by(TRT01A) |>
  summarise(n = n(), mean = round(mean(AGE), 1))
all.equal(by_map, by_group, check.attributes = FALSE)
