# Chapter 7: pivot_wider() makes one row per subject from one row per test
library(dplyr)

vs_bl <- pharmaversesdtm::vs |>
  filter(
    VSBLFL == "Y",
    VSTESTCD %in% c("DIABP", "PULSE", "SYSBP"),
    VSTPT == "AFTER LYING DOWN FOR 5 MINUTES"
  ) |>
  select(USUBJID, VSTESTCD, VSSTRESN)
vs_bl |> filter(USUBJID == "01-701-1015")

wide <- vs_bl |>
  tidyr::pivot_wider(
    id_cols = USUBJID,
    names_from = VSTESTCD,
    values_from = VSSTRESN,
    names_prefix = "BL_"
  )
wide |> print(n = 3)
c(long = nrow(vs_bl), wide = nrow(wide))
