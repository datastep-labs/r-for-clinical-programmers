# Answer 2-2: diastolic blood pressure. Records with no value, and the rows that two filters lose
library(dplyr)

diabp <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "DIABP")

nrow(diabp)
diabp |> filter(is.na(VSSTRESN)) |> nrow()
diabp |> filter(VSSTRESN >= 90) |> nrow()
diabp |> filter(VSSTRESN < 90) |> nrow()
