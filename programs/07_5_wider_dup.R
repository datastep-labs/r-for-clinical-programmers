# EXPECT: WARNING Values from `VSSTRESN` are not uniquely identified
# Chapter 7: without the time point, each test has three baseline values
library(dplyr)

vs_bl <- pharmaversesdtm::vs |>
  filter(VSBLFL == "Y", VSTESTCD %in% c("DIABP", "PULSE", "SYSBP")) |>
  select(USUBJID, VSTESTCD, VSTPT, VSSTRESN)

wide <- vs_bl |>
  tidyr::pivot_wider(
    id_cols = USUBJID, names_from = VSTESTCD, values_from = VSSTRESN
  )
wide |> print(n = 3)
