# Chapter 18: lists from the data. The codes, their labels, and a count
library(dplyr)

advs <- pharmaverseadam::advs

# One row per parameter, in the order of the code
params <- advs |>
  distinct(PARAMCD, PARAM) |>
  arrange(PARAMCD) |>
  haven::zap_label()
params

# A vector of the codes, and how many there are
codes <- params$PARAMCD
codes
length(codes)

# A named vector is a lookup: the label of a code
labels <- setNames(params$PARAM, params$PARAMCD)
labels[["DIABP"]]

# One value from the data: the size of the safety population
n_saf <- sum(pharmaverseadam::adsl$SAFFL == "Y", na.rm = TRUE)
n_saf
