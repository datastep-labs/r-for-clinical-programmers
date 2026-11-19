# Exercise 7-3: names from two columns: one column per test and time point
library(dplyr)

pharmaversesdtm::vs |>
  filter(
    USUBJID == "01-701-1015", VSBLFL == "Y",
    VSTESTCD %in% c("DIABP", "PULSE", "SYSBP")
  ) |>
  tidyr::pivot_wider(
    id_cols = USUBJID,
    names_from = c(VSTESTCD, VSTPTNUM),
    values_from = VSSTRESN
  )
