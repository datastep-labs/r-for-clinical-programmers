# Chapter 7: pivot_longer() turns the columns back into rows
library(dplyr)

wide <- pharmaversesdtm::vs |>
  filter(
    VSBLFL == "Y",
    VSTESTCD %in% c("DIABP", "PULSE", "SYSBP"),
    VSTPT == "AFTER LYING DOWN FOR 5 MINUTES"
  ) |>
  tidyr::pivot_wider(
    id_cols = USUBJID, names_from = VSTESTCD, values_from = VSSTRESN,
    names_prefix = "BL_"
  )

long <- wide |>
  tidyr::pivot_longer(
    cols = starts_with("BL_"),
    names_to = "PARAMCD",
    names_prefix = "BL_",
    values_to = "AVAL"
  )
long |> print(n = 6)
