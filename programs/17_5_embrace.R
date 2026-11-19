# Chapter 17: {{ }} passes the code of an argument on. enquo() and !! are its two halves
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

mean_by <- function(data, var, by) {
  data |>
    summarise(n = n(), mean = round(mean({{ var }}), 1), .by = {{ by }})
}
mean_by(adsl, AGE, ARM)

# The same in two steps: enquo() keeps the code, !! puts it in
mean_by2 <- function(data, var, by) {
  var <- rlang::enquo(var)
  by <- rlang::enquo(by)
  cat("Mean of", rlang::as_label(var), "by", rlang::as_label(by), "\n")
  data |>
    summarise(n = n(), mean = round(mean(!!var), 1), .by = !!by)
}
mean_by2(adsl, AGE, SEX)

# The caller can give code, not only a name
mean_by(adsl, AGE * 12, SEX)
