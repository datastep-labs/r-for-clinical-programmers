# Answer 18-1: leave some parameters out. Build the list without them
library(dplyr)
library(purrr)

exclude <- c("HEIGHT", "TEMP")

bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815, !PARAMCD %in% exclude)

tables <- split(bl, bl$PARAMCD) |>
  map(\(d) summarise(d, n = n(), mean = round(mean(AVAL), 1), .by = TRT01P))
length(tables)
names(tables)
