# Chapter 3: date functions. Duration, study day (there is no day 0) and age in whole years
library(dplyr)
library(lubridate)

trtsdt <- ymd("2014-01-02")
year(trtsdt)
month(trtsdt)

tibble(ADT = ymd(c("2013-12-31", "2014-01-01", "2014-01-02", "2014-01-03"))) |>
  mutate(
    DIFF = as.numeric(ADT - trtsdt),
    ADY = if_else(ADT >= trtsdt, DIFF + 1, DIFF)
  )

pharmaversesdtm::ae |>
  filter(USUBJID == "01-701-1015") |>
  mutate(
    ASTDT = ymd(AESTDTC),
    AENDT = ymd(AEENDTC),
    ADURN = as.numeric(AENDT - ASTDT) + 1,
    ASTDY = if_else(ASTDT >= trtsdt, as.numeric(ASTDT - trtsdt) + 1, as.numeric(ASTDT - trtsdt))
  ) |>
  select(AEDECOD, ASTDT, AENDT, ADURN, ASTDY, AESTDY)

brthdt <- ymd("1950-12-26")
time_length(interval(brthdt, trtsdt), "years")
floor(time_length(interval(brthdt, trtsdt), "years"))
