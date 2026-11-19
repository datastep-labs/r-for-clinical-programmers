# Exercise 8-2: freq_one() on the female subjects only
library(dplyr)

freq_one <- function(data, var) {
  data |>
    count({{ var }}) |>
    mutate(pct = round(100 * n / sum(n), 1))
}

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
freq_one(adsl |> filter(SEX == "F"), RACE)
