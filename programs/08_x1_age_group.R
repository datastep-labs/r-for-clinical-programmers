# Exercise 8-1: a function that makes the age group, used inside mutate()
library(dplyr)

age_group <- function(age) {
  stopifnot(is.numeric(age))
  case_when(
    is.na(age) ~ "Missing",
    age < 65 ~ "<65",
    age <= 80 ~ "65-80",
    .default = ">80"
  )
}

age_group(c(63, 65, 80, 81, NA))

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(AGEGR = age_group(AGE)) |>
  count(AGEGR)
