# Answer 3-1: search the verbatim term AETERM for "pain"
library(dplyr)
library(stringr)

pharmaversesdtm::ae |>
  filter(str_detect(AETERM, regex("pain", ignore_case = TRUE))) |>
  nrow()
