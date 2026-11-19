# Chapter 6: the big N per arm, computed once
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")

bign <- adsl |> count(TRT01A, name = "BIGN")
bign

# the column headers of a table
bign |> mutate(header = paste0(TRT01A, " (N=", BIGN, ")"))

# one number by name: a named vector
n_by_arm <- pull(bign, BIGN, name = TRT01A)
n_by_arm["Placebo"]

# planned arm and actual treatment are not the same for every subject
adsl |> count(ARM, TRT01A)
