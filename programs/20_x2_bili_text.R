# Answer 20-2: the values of LBORRES that are not numbers
library(dplyr)

pharmaversesdtm::lb |>
  filter(LBTESTCD == "BILI") |>
  filter(is.na(suppressWarnings(as.numeric(LBORRES)))) |>
  count(LBORRES)
