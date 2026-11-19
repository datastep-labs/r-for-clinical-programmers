# Chapter 2: impute a partial date early (start dates) or late (end dates), with a flag
library(dplyr)
library(lubridate)

tibble(DTC = c("2014-03-15", "2014-03-15T09:30", "2014-03", "2014", NA)) |>
  mutate(
    DTC10 = substr(DTC, 1, 10),
    DTF = case_when(
      nchar(DTC10) == 7 ~ "D",
      nchar(DTC10) == 4 ~ "M"
    ),
    ASTDT = ymd(DTC10, truncated = 2),
    AENDT = case_when(
      DTF == "M" ~ make_date(year(ASTDT), 12, 31),
      DTF == "D" ~ rollforward(ASTDT),
      .default = ASTDT
    )
  ) |>
  select(DTC, DTF, ASTDT, AENDT)
