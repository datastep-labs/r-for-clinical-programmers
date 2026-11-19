# Chapter 8: {{ }} passes a column name from the caller to a dplyr verb
library(dplyr)

freq_one <- function(data, var) {
  data |>
    count({{ var }}) |>
    mutate(pct = round(100 * n / sum(n), 1))
}

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")

freq_one(adsl, SEX)
freq_one(adsl, RACE)
freq_one(adsl |> filter(TRT01A == "Placebo"), SEX)
