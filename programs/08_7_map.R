# Chapter 8: map() calls a function for each element of a list
library(dplyr)
library(purrr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")

one_var <- function(var) {
  adsl |>
    count(VALUE = .data[[var]]) |>
    mutate(VARIABLE = var, .before = 1)
}

tables <- map(c("SEX", "RACE", "ETHNIC"), one_var)
length(tables)
tables[[1]]

# stack the results into one data frame
list_rbind(tables)

# map_dfr() does map() and the stacking in one call (an older form)
nrow(map_dfr(c("SEX", "RACE", "ETHNIC"), one_var))

# walk() is for the side effect only, here a printed line
walk(c("SEX", "RACE", "ETHNIC"), \(v) cat(v, "has", n_distinct(adsl[[v]]), "values\n"))
