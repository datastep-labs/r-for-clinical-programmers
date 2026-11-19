# Answer 17-2: a variable with the name of a column. The column wins in filter()
library(dplyr)

alt <- pharmaverseadam::adlb |>
  filter(PARAMCD == "ALT", !is.na(AVAL), is.na(DTYPE))

ANRHI <- 40
alt |> filter(AVAL > ANRHI) |> nrow() # the column ANRHI of each row
alt |> filter(AVAL > .env$ANRHI) |> nrow() # the value 40
