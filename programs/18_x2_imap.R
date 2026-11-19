# Answer 18-2: imap() gives each element and its name: a title per table
library(dplyr)
library(purrr)

bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815)
by_param <- split(bl, bl$PARAMCD)

iwalk(by_param, \(d, code) {
  cat(sprintf("%-7s n = %d, mean = %.1f\n", code, nrow(d), mean(d$AVAL)))
})
