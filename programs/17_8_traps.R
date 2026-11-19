# EXPECT: WARNING argument is not numeric or logical
# Chapter 17: two common traps of data masking
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

# Trap 1: an argument with the name of a column. ARM == ARM is always TRUE
count_arm <- function(data, ARM) {
  data |> filter(ARM == ARM) |> nrow()
}
count_arm(adsl, "Placebo")

# The fix: .env$ARM is the argument, not the column
count_arm <- function(data, ARM) {
  data |> filter(.data$ARM == .env$ARM) |> nrow()
}
count_arm(adsl, "Placebo")

# Trap 2: a text where {{ }} expects a name. mean("AGE") is not a mean
mean_of <- function(data, var) {
  data |> summarise(mean = mean({{ var }}))
}
mean_of(adsl, "AGE")
