# Exercise 7-2: a missing age falls through to .default
library(dplyr)

ages <- tibble(AGE = c(63, NA, 85))

ages |>
  mutate(
    NO_CHECK = case_when(AGE < 65 ~ "<65", AGE <= 80 ~ "65-80", .default = ">80"),
    CHECKED = case_when(
      is.na(AGE) ~ "Missing",
      AGE < 65 ~ "<65",
      AGE <= 80 ~ "65-80",
      .default = ">80"
    )
  )
