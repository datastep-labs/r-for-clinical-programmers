# Chapter 8: .data[[ ]] uses a column whose name is in a text value
library(dplyr)

freq_chr <- function(data, var) {
  data |>
    count(.data[[var]]) |>
    mutate(pct = round(100 * n / sum(n), 1))
}

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
freq_chr(adsl, "SEX")

# the names can come from data, so a loop can give them one by one
for (v in c("SEX", "ETHNIC")) {
  print(freq_chr(adsl, v))
}
