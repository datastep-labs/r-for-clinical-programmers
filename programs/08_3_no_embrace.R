# EXPECT: ERROR Must group by variables found
# Chapter 8: without {{ }}, count() looks for a column named var
library(dplyr)

freq_bad <- function(data, var) {
  data |>
    count(var) |>
    mutate(pct = round(100 * n / sum(n), 1))
}

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
freq_bad(adsl, SEX)
